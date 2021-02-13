import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/custom_appbar.dart';
import 'package:shipbay/pages/shared/main_menu.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/pages/tracking/tracking.dart';
import 'package:shipbay/services/settings.dart';
import 'package:shipbay/services/api.dart';

class PickupServices extends StatefulWidget {
  @override
  _PickupServicesState createState() => _PickupServicesState();
}

class _PickupServicesState extends State<PickupServices> {
  Map<String, bool> _services = {
    'Inside pickup': false,
    'Tailgate': false,
  };
  List services;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(''),
      drawer: MainMenu(),
      endDrawer: Tracking(),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                SizedBox(child: Progress(progress: 18.0)),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Pickup services",
                        style: TextStyle(fontSize: 22.0, height: 2.0),
                      ),
                      SizedBox(height: 16.0),
                      ListView(
                        shrinkWrap: true,
                        children: _services.keys.map((String key) {
                          return CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: primary,
                            value: _services[key],
                            onChanged: (bool val) {
                              setState(() {
                                _services[key] = val;
                              });
                            },
                            title: Text(
                              key,
                              style: TextStyle(fontSize: 11.0),
                            ),
                          );
                        }).toList(),
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
                Navigator.pushReplacementNamed(context, '/pickup');
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
    _getPickServices();
    _init();
  }

  _next(context) {
    Store store = Store();
    store.save('pickup-services', _services);
    Navigator.pushReplacementNamed(context, '/pickup-date');
  }

  _init() async {
    Store store = Store();
    var data = await store.read('pickup-services');
    if (data != null) {
      setState(() {
        _services['Inside pickup'] = data['Inside pickup'];
        _services['Tailgate'] = data['Tailgate'];
      });
    }
  }

  _getPickServices() async {
    List response = await getPickServices();
    /* setState(() {
      print(",,,,,,,,,,,,,,,");
      print(response);
    }); */
  }
}
