import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shipbay/models/item_model.dart';
import 'package:shipbay/models/temperature.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/pickup-services');
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                SizedBox(child: Progress(progress: 61.0)),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Items to be delivered",
                        style: TextStyle(fontSize: 24.0, height: 2.0),
                      ),
                      SizedBox(height: 16.0),
                      Visibility(
                        visible: true,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              width: double.infinity,
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
                              height: 150.0,
                              child: ListView.builder(
                                itemCount: _items.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(_items[index].description),
                                          SizedBox(width: 20.0),
                                          Text(
                                              "${_items[index].weight.toString()} Pounds"),
                                        ],
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.remove,
                                            color: Colors.red),
                                        onPressed: () {
                                          remove(index);
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
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: 0,
                            backgroundColor: Colors.orange[50],
                            foregroundColor: Colors.orange[900],
                            child: Icon(Icons.keyboard_arrow_left),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/delivery-services');
                            },
                          ),
                          SizedBox(width: 12.0),
                          FloatingActionButton(
                            heroTag: 1,
                            backgroundColor: Colors.orange[900],
                            child: Icon(Icons.keyboard_arrow_right),
                            onPressed: () {
                              save();
                              Navigator.pushReplacementNamed(
                                  context, '/additional-details');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    read();
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

  remove(index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  read() async {
    Store store = Store();
    var _savedItem = await store.read('items');
    setState(() {
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
    });

    var savedConditions = await store.read('item-condition');
    if (savedConditions != null) {
      setState(() {
        _services['Stackable'] = savedConditions['Stackable'];
        _services['Dangerous'] = savedConditions['Dangerous'];
        _services['Temperature sensitive'] =
            savedConditions['Temperature sensitive'];
        _isTemperature = savedConditions['Temperature sensitive'];
      });
    }
    if (_isTemperature) {
      var temp = await store.read('temperature');

      print("..........");
      print(temp);

      _minTempController.text = temp['min_temp'].toString();
      _maxTempController.text = temp['max_temp'].toString();
    }
  }

  save() {
    Store store = Store();
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
  String dropdownValue = 'Pallets';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.0),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(hintText: 'Item description'),
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
                decoration: InputDecoration(hintText: 'Length'),
                style: TextStyle(fontSize: 12.0),
              ),
            ),
            Flexible(
              child: TextFormField(
                controller: _widthController,
                decoration: InputDecoration(hintText: 'Width'),
                style: TextStyle(fontSize: 12.0),
              ),
            ),
            Flexible(
              child: TextFormField(
                controller: _heightController,
                decoration: InputDecoration(hintText: 'Height'),
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
                decoration: InputDecoration(hintText: 'Weight'),
                style: TextStyle(fontSize: 12.0),
              ),
            ),
            Flexible(
              child: TextFormField(
                controller: _numberController,
                decoration: InputDecoration(hintText: 'Number of items'),
                style: TextStyle(fontSize: 12.0),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              add(context);
            })
      ],
    );
  }

  add(context) {
    ItemModel _itemModel = ItemModel();
    _itemModel.description = _descriptionController.text;
    _itemModel.length = double.parse(_lengthController.text);
    _itemModel.width = double.parse(_widthController.text);
    _itemModel.height = double.parse(_heightController.text);
    _itemModel.weight = double.parse(_weightController.text);
    _itemModel.number = int.parse(_numberController.text);
    Navigator.pop(context, _itemModel);
  }
}
