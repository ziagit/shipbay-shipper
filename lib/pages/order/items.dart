import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/services/settings.dart';

class Items extends StatefulWidget {
  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  Map<String, bool> services = {
    'Stackable': false,
    'Dangerous': false,
    'Temperature sensitive': false,
  };
  bool _isTemperature = false;
  String dropdownValue = 'Pallets';
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
                      TextFormField(
                        decoration:
                            InputDecoration(hintText: 'Item description'),
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
                        items: <String>[
                          'Pallets',
                          'Pieces',
                          'Bundles',
                          'Box',
                          'Crate'
                        ].map<DropdownMenuItem<String>>((String value) {
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
                              decoration: InputDecoration(hintText: 'Length'),
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration: InputDecoration(hintText: 'Width'),
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
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
                              decoration: InputDecoration(hintText: 'Weight'),
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                          Flexible(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(hintText: 'Number of items'),
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Is your item?"),
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: services.keys.map((String key) {
                          return new CheckboxListTile(
                            activeColor: primary,
                            title: new Text(
                              key,
                              style: TextStyle(fontSize: 11.0),
                            ),
                            value: services[key],
                            onChanged: (bool val) {
                              print("checkbox value: $key");
                              setState(() {
                                if (key == "Temperature sensitive") {
                                  _isTemperature = !_isTemperature;
                                }
                                services[key] = val;
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
                                decoration:
                                    InputDecoration(hintText: 'Min(FRH)'),
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
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
}
