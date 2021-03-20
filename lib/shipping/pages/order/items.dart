import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipbay/shipping/models/item_model.dart';
import 'package:shipbay/shipping/models/temperature.dart';
import 'package:shipbay/shipping/shipping_appbar.dart';
import 'package:shipbay/shipping/shipping_menu.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shipping/services/api.dart';

class Items extends StatefulWidget {
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  var _items = List<ItemModel>();
  List _selectedServices = List();
  List<dynamic> _services;

  TextEditingController _minTempController = TextEditingController();
  TextEditingController _maxTempController = TextEditingController();

  bool _isTemperature = false;
  Store store = Store();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: ShippingAppBar(''),
      drawer: ShippingMenu(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                SizedBox(child: Progress(progress: 55.0)),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Items to be delivered",
                        style: TextStyle(fontSize: 22.0, height: 2.0),
                      ),
                      SizedBox(height: 16.0),
                      Visibility(
                        visible: _items.isNotEmpty,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.grey.shade200,
                                      offset: new Offset(0.0, 10.0),
                                      blurRadius: 10.0,
                                      spreadRadius: 1.0,
                                    )
                                  ]),
                              height: 70.0,
                              child: ListView.builder(
                                itemCount: _items.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(_items[index].description,
                                              style: TextStyle(fontSize: 12.0)),
                                          SizedBox(width: 20.0),
                                          Text(
                                              "${(_items[index].weight * _items[index].number).toString()} Pounds",
                                              style: TextStyle(fontSize: 12.0)),
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.remove_circle_outline,
                                            color: Colors.red),
                                        onPressed: () {
                                          _remove(index);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      IconButton(
                          icon: Icon(Icons.add_circle_outline, color: primary),
                          onPressed: () {
                            _addDialog(context);
                          }),
                      SizedBox(height: 20.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Is your item?"),
                      ),
                      _services == null
                          ? Container(
                              child: Text("Loading..."),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _services.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CheckboxListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  activeColor: primary,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  value: _selectedServices
                                      .contains(_services[index]['code']),
                                  onChanged: (bool selected) {
                                    _onServiceSelected(
                                        selected, _services[index]['code']);
                                  },
                                  title: Text(
                                    _services[index]['name'],
                                    style: TextStyle(fontSize: 11.0),
                                  ),
                                );
                              }),
                      Visibility(
                        visible: _isTemperature,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                controller: _minTempController,
                                decoration:
                                    InputDecoration(hintText: 'Min(FRH)'),
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: _maxTempController,
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(hintText: 'Max(FRH)'),
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: inActive,
              foregroundColor: primary,
              heroTag: "btn",
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/delivery-services');
              },
              child: Icon(Icons.keyboard_arrow_left),
            ),
            SizedBox(
              width: 40,
            ),
            FloatingActionButton(
              backgroundColor: primary,
              heroTag: "btn2",
              onPressed: () {
                _next(context);
              },
              child: Icon(Icons.keyboard_arrow_right),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getItemCondition();
    _init();
  }

  _addDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return Container(
                height: height - 400, width: width - 100, child: AddItem());
          },
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context, false), // passing false
            child: Text('Cancel'),
          ),
        ],
      ),
    ).then((value) {
      if (value != false) {
        setState(() {
          _items.add(value);
        });
      }
    });
  }

  _remove(index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _onServiceSelected(bool selected, code) {
    if (selected == true) {
      setState(() {
        _selectedServices.add(code);
        if (code == 'tm') {
          _isTemperature = true;
        }
      });
    } else {
      setState(() {
        _selectedServices.remove(code);
        if (code == 'tm') {
          _isTemperature = false;
        }
      });
    }
  }

  _init() async {
    var _savedItem = await store.read('items');
    var _savedConditions = await store.read('item-condition');
    var _temp = await store.read('temperature');

    setState(() {
      if (_savedItem != null) {
        for (int i = 0; i < _savedItem.length; i++) {
          ItemModel _item = ItemModel();
          _item.description = _savedItem[i]['description'];
          _item.type = _savedItem[i]['type'];
          _item.length = _savedItem[i]['length'];
          _item.width = _savedItem[i]['width'];
          _item.height = _savedItem[i]['height'];
          _item.weight = _savedItem[i]['weight'];
          _item.number = _savedItem[i]['number'];
          _items.add(_item);
        }
      }

      if (_savedConditions != null) {
        _selectedServices = _savedConditions;
        if (_savedConditions.contains('tm')) {
          _isTemperature = true;
          _minTempController.text = _temp['min_temp'].toString();
          _maxTempController.text = _temp['max_temp'].toString();
        }
      }
    });
  }

  _next(context) {
    if (_isTemperature) {
      if (_minTempController.text == '' || _maxTempController.text == '') {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('You should add an item!'),
        ));
        return;
      }
      Temperature temperature = Temperature();
      temperature.min_temp = double.parse(_minTempController.text);
      temperature.max_temp = double.parse(_maxTempController.text);
      store.save('temperature', temperature);
    }
    if (_items.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('You should add an item!'),
      ));
      return;
    }
    store.save('items', _items);

    if (_selectedServices.length > 0) {
      store.save('item-condition', _selectedServices);
    } else {
      store.remove('item-condition');
    }

    Navigator.pushReplacementNamed(context, '/additional-details');
  }

  _getItemCondition() async {
    var response = await getAccessory('shipping/item-condition');
    setState(() {
      _services = response;
    });
  }
}

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _lengthController = TextEditingController();
  TextEditingController _widthController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  String dropdownValue = 'Pallets';
  var _types;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 16.0),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Item description'),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a valid description';
              }
              return null;
            },
          ),
          DropdownButtonFormField<String>(
            value: dropdownValue,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['Pallets', 'Pieces', 'Bundles', 'Box', 'Crate']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  controller: _lengthController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Length(in)'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter > 0';
                    }
                    return null;
                  },
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: _widthController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Width(in)'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter > 0';
                    }
                    return null;
                  },
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Height(in)'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter > 0';
                    }
                    return null;
                  },
                  style: TextStyle(fontSize: 12.0),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Weight(lb)'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter > 0';
                    }
                    return null;
                  },
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Number of items'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter > 0';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 40.0),
          FlatButton(
              child: Text(
                'Add',
                style: TextStyle(fontSize: 12.0, color: Colors.white),
              ),
              color: primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _add(context);
                }
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getTypes();
    _numberController.text = 1.toString();
  }

  _getTypes() async {
    List response = await getAccessory('shipping/item-type');
    setState(() {
      _types = response;
    });
  }

  _add(context) {
    ItemModel _itemModel = ItemModel();
    _itemModel.type = 1;
    _itemModel.description = _descriptionController.text;
    _itemModel.length = double.parse(_lengthController.text);
    _itemModel.width = double.parse(_widthController.text);
    _itemModel.height = double.parse(_heightController.text);
    _itemModel.weight = double.parse(_weightController.text);
    _itemModel.number = int.parse(_numberController.text);
    Navigator.pop(context, _itemModel);
  }
}
