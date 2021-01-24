import 'package:flutter/material.dart';
import 'package:shipbay/models/carrier_model.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:shipbay/services/settings.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

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
                FutureBuilder(
                  future: _getCarriers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text("Loading..."),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Container(
                              child: Card(
                                child: Padding(
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 150.0,
                                                child: Text(
                                                  "Read more about this carrier",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 12.0),
                                                ),
                                              ),
                                              SizedBox(height: 16.0),
                                              SmoothStarRating(
                                                  starCount: 5,
                                                  rating: snapshot
                                                          .data[index].rates +
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
                                                  style:
                                                      TextStyle(fontSize: 12.0))
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
                                              _next(context,
                                                  snapshot.data[index]);
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
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
    );
  }

  @override
  void initState() {
    read();
    initOrder();
    super.initState();
  }

  read() async {
    var pickup = await store.read('pickup');
    var delivery = await store.read('delivery');
    if (pickup != null && delivery != null) {
      setState(() {
        _src_city = pickup['city'];
        _des_city = delivery['city'];
      });
    }
  }

  initOrder() async {
    var pickup = await store.read('pickup');
    var delivery = await store.read('delivery');
    var items = await store.read('items');
    var pickupServices = await store.read('pickup-services');
    var deliveryServices = await store.read('delivery-services');
    var pickupDate = await store.read('pickup-date');
    var deliveryAppointmentTime = await store.read('delivery-appointment-time');
    var itemConditions = await store.read('item-condition');
    var itemTemperature = await store.read('temperature');
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
  }

  Future<List<Carrier>> _getCarriers() async {
    Response response = await post(
      "http://192.168.2.19:8000/api/carriers-rate",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, Object>{
        "src": order['src'],
        "pickDate": order['pickDate'],
        "des": order['des'],
        "myItem": order['myItem'],
      }),
    );

    var jsonData = jsonDecode(response.body);
    List<Carrier> carriers = [];
    for (int i = 0; i < jsonData.length; i++) {
      Carrier carrier = Carrier(
          i + 1,
          jsonData[i]['first_name'],
          jsonData[i]['last_name'],
          jsonData[i]['phone'],
          jsonData[i]['price'],
          jsonData[i]['company'],
          jsonData[i]['detail'],
          jsonData[i]['rates'],
          jsonData[i]['website'],
          jsonData[i]['logo']);
      carriers.add(carrier);
    }
    return carriers;
  }

  _next(context, carrier) async {
    store.save('carrier', carrier);
    String token = await store.read('token');
    if (token != null) {
      print(token);
      Navigator.pushReplacementNamed(context, '/payment-details');
    } else {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }
}
