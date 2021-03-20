import 'package:flutter/material.dart';
import 'package:shipbay/moving/moving_appbar.dart';
import 'package:shipbay/shipping/shipping_appbar.dart';
import 'package:shipbay/shipping/shipping_menu.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shipping/services/api.dart';

class PickupServices extends StatefulWidget {
  @override
  _PickupServicesState createState() => _PickupServicesState();
}

class _PickupServicesState extends State<PickupServices> {
  List _selectedServices = List();
  List<dynamic> _services;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ShippingAppBar(''),
      drawer: ShippingMenu(),
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
    _init();
    _getPickServices();
  }

  void _onServiceSelected(bool selected, code) {
    if (selected == true) {
      setState(() {
        _selectedServices.add(code);
      });
    } else {
      setState(() {
        _selectedServices.remove(code);
      });
    }
  }

  _next(context) {
    Store store = Store();
    store.save('pickup-services', _selectedServices);
    Navigator.pushReplacementNamed(context, '/pickup-date');
  }

  _init() async {
    Store store = Store();
    var data = await store.read('pickup-services');
    if (data != null) {
      setState(() {
        _selectedServices = data;
      });
    }
  }

  _getPickServices() async {
    var response = await getAccessory('shipping/pick-services');
    setState(() {
      _services = response;
    });
  }
}
