import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipbay/models/accessory.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:shipbay/services/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Pickup extends StatefulWidget {
  @override
  _PickupState createState() => _PickupState();
}

class _PickupState extends State<Pickup> {
  Future<List<Accessory>> _getAccessories() async {
    var response = await http.get("http://104.154.95.189/api/location-type");
    var jsonData = json.decode(response.body);

    List<Accessory> accessories = [];
    for (var a in jsonData) {
      Accessory accessory = Accessory(a['index'], a['name'], a['code']);
      accessories.add(accessory);
      print(a['name']);
    }
    if (accessories.isNotEmpty) {
      return accessories;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.orange[900]));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xF8FAF8),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  SizedBox(child: Progress(progress: 0.0)),
                  SizedBox(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Pickup address",
                          style: TextStyle(fontSize: 24.0, height: 2.0),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Postal code'),
                        ),
                        SizedBox(height: 16.0),
                        FutureBuilder(
                          future: _getAccessories(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data != null) {
                              return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(snapshot.data[index].name),
                                  );
                                },
                              );
                            } else {
                              return Text("no data");
                            }
                          },
                        ),
                        SizedBox(height: 16.0),
                        FloatingActionButton(
                          heroTag: 1,
                          backgroundColor: Colors.orange[900],
                          child: Icon(Icons.keyboard_arrow_right),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/pickup-services');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class Accessory {
  int index;
  String name;
  String code;
  Accessory(this.index, this.name, this.code);
}
