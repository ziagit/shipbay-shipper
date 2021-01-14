import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';

class Carriers extends StatefulWidget {
  @override
  _CarriersState createState() => _CarriersState();
}

class _CarriersState extends State<Carriers> {
  String _src_city;
  String _des_city;
  @override
  Widget build(BuildContext context) {
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
            Navigator.pushReplacementNamed(context, '/additional-details');
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 85.0)),
                SizedBox(height: 24.0),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(children: <Widget>[
                      Text("$_src_city"),
                      Icon(Icons.arrow_right),
                      Text("$_des_city")
                    ]),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Image(
                            image: AssetImage('assets/images/coffeequery.png'),
                          ),
                          title: Text("Carrier"),
                          subtitle: Text("Read more about this carrier"),
                        ),
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: Text('Select'),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/signin');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
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

  read() async {
    Store store = Store();
    var pickup = await store.read('pickup');
    var delivery = await store.read('delivery');
    if (pickup != null && delivery != null) {
      setState(() {
        _src_city = pickup['city'];
        _des_city = delivery['city'];
      });
    }
    makeOrder();
  }

  makeOrder() async {
    Map order = {};
    Store store = Store();
    var pickup = await store.read('pickup');
    var delivery = await store.read('delivery');
    var items = await store.read('items');
    var pickupServices = await store.read('pickup-services');
    var deliveryServices = await store.read('delivery-services');
    var pickupDate = await store.read('pickup-date');
    var deliveryAppointmentTime = await store.read('delivery-appointment-time');
    var itemConditions = await store.read('item-condition');
    var itemTemperature = await store.read('temperature');
    print(itemTemperature['max_temp']);
    order['src'] = pickup;
    order['src']['accessories'] = [];
    order['src']['accessories'].add(pickup['location_type']);

    if (pickupServices['Inside pickup'] == true) {
      order['src']['accessories'].add('in');
    }
    if (pickupServices['Tailgate'] == true) {
      order['src']['accessories'].add('tl');
    }
    order['src']['accessories'].add(delivery['location_type']);
    if (pickupDate['is_appointment'] == true) {
      order['src']['accessories'].add(delivery['ap']);
      order['src']['appointmentTime'] = pickupDate['time'];
    }
    order['pickDate'] = pickupDate['date'];

    order['des'] = delivery;
    order['des']['accessories'] = [];
    if (deliveryServices['Inside pickup'] == true) {
      order['des']['accessories'].add('in');
    }
    if (deliveryServices['Tailgate'] == true) {
      order['des']['accessories'].add('tl');
    }
    if (deliveryServices['Appointment'] == true) {
      order['des']['accessories'].add('ap');
    }
    if (deliveryAppointmentTime != null) {
      order['des']['appointmentTime'] = deliveryAppointmentTime;
    }
    order['myItem'] = {};
    order['myItem']['items'] = items;
    order['myItem']['conditions'] = [];
    if (itemConditions['Stackable']) {
      order['myItem']['conditions'].add('st');
    }
    if (itemConditions['Dangerous']) {
      order['myItem']['conditions'].add('dg');
    }
    if (itemConditions['Temperature sensitive']) {
      order['myItem']['conditions'].add('tm');
      order['myItem']['maxTemp'] = itemTemperature['max_temp'].toString();
      order['myItem']['minTemp'] = itemTemperature['min_temp'].toString();
    }

    print("okh fuck.................");
    print(order);
  }
}
