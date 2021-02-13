import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipbay/models/item_model.dart';
import 'package:shipbay/models/temperature.dart';
import 'package:shipbay/pages/shared/custom_appbar.dart';
import 'package:shipbay/pages/shared/main_menu.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/pages/tracking/tracking.dart';
import 'package:shipbay/services/settings.dart';

class Items extends StatefulWidget {
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  var _items = List<ItemModel>();
  Map<String, bool> _services = {
    'Stackable': false,
    'Dangerous': false,
    'Temperature sensitive': false,
  };

  TextEditingController _minTempController = TextEditingController();
  TextEditingController _maxTempController = TextEditingController();

  bool _isTemperature = false;
  Store store = Store();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(''),
      drawer: MainMenu(),
      endDrawer: Tracking(),
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
                              height: 100.0,
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
                            _openDialog(context);
                          }),
                      SizedBox(height: 20.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Is your item?"),
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: _services.keys.map((String key) {
                          return new CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: primary,
                            title: new Text(
                              key,
                              style: TextStyle(fontSize: 11.0),
                            ),
                            value: _services[key],
                            onChanged: (bool val) {
                              setState(() {
                                if (key == "Temperature sensitive") {
                                  _isTemperature = !_isTemperature;
                                }
                                _services[key] = val;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      Visibility(
                        visible: _isTemperature,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                controller: _minTempController,
                                decoration:
                                    InputDecoration(hintText: 'Min(FRH)'),
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: _maxTempController,
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
    _init();
    super.initState();
  }

  _openDialog(context) {
    showDialog(
      context: context,
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
      ),
    ).then((value) {
      setState(() {
        _items.add(value);
      });
    });
  }

  _remove(index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  _init() async {
    var _savedItem = await store.read('items');
    var savedConditions = await store.read('item-condition');
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
      if (savedConditions != null) {
        _services['Stackable'] = savedConditions['Stackable'];
        _services['Dangerous'] = savedConditions['Dangerous'];
        _services['Temperature sensitive'] =
            savedConditions['Temperature sensitive'];
        _isTemperature = savedConditions['Temperature sensitive'];
      }
    });

    if (_isTemperature) {
      var temp = await store.read('temperature');

      _minTempController.text = temp['min_temp'].toString();
      _maxTempController.text = temp['max_temp'].toString();
    }
  }

  _next(context) {
    if (_items.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please add your item!'),
      ));
    } else {
      store.save('items', _items);
      store.save('item-condition', _services);

      if (_isTemperature) {
        Temperature temperature = Temperature();
        temperature.min_temp = double.parse(_minTempController.text);
        temperature.max_temp = double.parse(_maxTempController.text);
        store.save('temperature', temperature);
      } else {
        store.remove('temperature');
      }
      Navigator.pushReplacementNamed(context, '/additional-details');
    }
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
          SizedBox(height: 20.0),
          IconButton(
              icon: Icon(Icons.add_circle_outline, color: primary),
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
    //_getTypes();
    _numberController.text = 1.toString();
    super.initState();
  }

/*   Future<Map<String, dynamic>> _getTypes() async {
    try {
      var response = await http.get('http://192.168.2.14:8000/api/item-type',
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});
      _types = jsonDecode(response.body);
      print("................");
      print(_types);
    } catch (err) {
      print('err: ${err.toString()}');
    }
    return null;
  } */

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
