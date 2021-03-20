import 'package:flutter/material.dart';
import 'package:shipbay/shipping/models/carrier_model.dart';
import 'package:shipbay/shipping/shipping_appbar.dart';
import 'package:shipbay/shipping/shipping_menu.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/store.dart';
import 'dart:convert';
import 'package:shipbay/shared/services/colors.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shipbay/shipping/services/api.dart';

class Carriers extends StatefulWidget {
  @override
  _CarriersState createState() => _CarriersState();
}

class _CarriersState extends State<Carriers> {
  String _src_city;
  String _des_city;
  Map order = {};
  List carriers;
  Store store = Store();

  double _rating;
  double _userRating = 3.0;
  int _ratingBarMode = 1;
  bool _isRTLMode = false;
  bool _isVertical = false;
  IconData _selectedIcon;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
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
                Container(child: Progress(progress: 75.0)),
                Text(
                  "Select a carrier",
                  style: TextStyle(fontSize: 22.0, height: 2.0),
                ),
                SizedBox(height: 16.0),
                Container(
                  decoration: _customStyle(context),
                  padding: const EdgeInsets.all(24.0),
                  child: Row(children: <Widget>[
                    Text("$_src_city"),
                    Icon(Icons.arrow_right),
                    Text("$_des_city")
                  ]),
                ),
                SizedBox(height: 16.0),
                FutureBuilder(
                  future: _get(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        decoration: _customStyle(context),
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            children: [
                              Text("Loading"),
                              JumpingDotsProgressIndicator(
                                fontSize: 20.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            dense: true,
                            contentPadding:
                                EdgeInsets.only(left: 0.0, right: 0.0),
                            title: Container(
                              decoration: _customStyle(context),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        backgroundImage: AssetImage(
                                            'assets/images/coffeequery.png'),
                                      ),
                                      SizedBox(width: 5.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data[index].company,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 150.0,
                                            child: Text(
                                              "Read more about this carrier",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                          SizedBox(height: 16.0),
                                          SmoothStarRating(
                                              starCount: 5,
                                              rating:
                                                  snapshot.data[index].rates +
                                                      .0,
                                              size: 16.0,
                                              isReadOnly: true,
                                              color: Colors.orange,
                                              borderColor: Colors.orange,
                                              spacing: 0.0)
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.info,
                                                color: Colors.blue),
                                            onPressed: () {},
                                          ),
                                          Text(
                                              "\$${snapshot.data[index].price.toStringAsFixed(2)}",
                                              style: TextStyle(fontSize: 12.0))
                                        ],
                                      ),
                                      OutlineButton(
                                        borderSide: BorderSide(
                                            color: primary, width: 0.5),
                                        child: Text(
                                          "Select",
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        onPressed: () {
                                          _next(context, snapshot.data[index]);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                )
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
              heroTag: "btn2",
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/pickup');
              },
              child: Icon(Icons.edit),
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
  }

  Decoration _customStyle(context) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        new BoxShadow(
          color: Colors.grey.shade200,
          offset: new Offset(0.0, 10.0),
          blurRadius: 10.0,
          spreadRadius: 1.0,
        )
      ],
    );
  }

  _init() async {
    var pickup = await store.read('pickup');
    var delivery = await store.read('delivery');
    var items = await store.read('items');
    var pickupServices = await store.read('pickup-services');
    var deliveryServices = await store.read('delivery-services');
    var pickupDate = await store.read('pickup-date');
    var deliveryAppointmentTime = await store.read('delivery-appointment-time');
    var itemConditions = await store.read('item-condition');
    var itemTemperature = await store.read('temperature');

    if (pickup != null && delivery != null) {
      setState(() {
        _src_city = pickup['city'];
        _des_city = delivery['city'];
      });
    }

    order['src'] = pickup;
    order['src']['accessories'] = [];
    order['src']['accessories'].add(pickup['location_type']);
    for (int i = 0; i < pickupServices.length; i++) {
      order['src']['accessories'].add(pickupServices[i]);
    }
    if (pickupDate['time'] != null) {
      order['src']['accessories'].add('ap');
    }
    order['src']['appointmentTime'] = pickupDate['time'];
    order['pickDate'] = pickupDate['date'];

    order['des'] = delivery;
    order['des']['accessories'] = [];
    order['des']['accessories'].add(delivery['location_type']);
    for (int i = 0; i < deliveryServices.length; i++) {
      order['des']['accessories'].add(deliveryServices[i]);
    }
    order['des']['appointmentTime'] = deliveryAppointmentTime;
    order['myItem'] = {};
    order['myItem']['items'] = items;
    order['myItem']['conditions'] = [];

    for (int i = 0; i < itemConditions.length; i++) {
      order['myItem']['conditions'].add(itemConditions[i]);
    }
    order['myItem']['maxTemp'] =
        itemTemperature == null ? null : itemTemperature['max_temp'];
    order['myItem']['minTemp'] =
        itemTemperature == null ? null : itemTemperature['min_temp'];
  }

  Future<List<Carrier>> _get() async {
    var response = await carrierList(
        jsonEncode(<String, Object>{
          "src": order['src'],
          "pickDate": order['pickDate'],
          "des": order['des'],
          "myItem": order['myItem'],
        }),
        'shipping/carriers-rate');
    var jsonData = jsonDecode(response.body);
    if (response.statusCode != 200 || jsonData.length == 0) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text('Something is wrong, please check the Source or Destination!'),
      ));
    } else {
      List<Carrier> carriers = [];
      for (int i = 0; i < jsonData.length; i++) {
        Carrier carrier = Carrier(
            jsonData[i]['id'],
            jsonData[i]['first_name'],
            jsonData[i]['last_name'],
            jsonData[i]['phone'],
            jsonData[i]['price'].toDouble(),
            jsonData[i]['company'],
            jsonData[i]['detail'],
            jsonData[i]['rates'].toDouble(),
            jsonData[i]['website'],
            jsonData[i]['logo']);

        carriers.add(carrier);
      }
      return carriers;
    }
  }

  _next(context, carrier) async {
    store.save('carrier', carrier);
    String token = await store.read('token');
    if (token != null) {
      Navigator.pushReplacementNamed(context, '/payment-details');
    } else {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }
}
