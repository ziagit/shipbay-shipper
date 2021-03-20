import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shipbay/moving/models/mover_model.dart';
import 'package:shipbay/moving/moving_menu.dart';
import 'package:shipbay/moving/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/settings.dart';
import 'package:shipbay/moving/moving_appbar.dart';
import 'package:shipbay/shared/components/progress.dart';

import 'package:shipbay/shared/services/store.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:progress_indicators/progress_indicators.dart';

class Movers extends StatefulWidget {
  @override
  _MoversState createState() => _MoversState();
}

class _MoversState extends State<Movers> {
  var _distance;
  var _duration;

  Map order = {};
  List movers;
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
      appBar: MovingAppBar(''),
      drawer: MovingMenu(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 100.0)),
                Text(
                  "Select a mover",
                  style: TextStyle(fontSize: 22.0, height: 2.0),
                ),
                SizedBox(height: 16.0),
                Container(
                  decoration: _customStyle(context),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              "From: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Flexible(
                              child: Text(
                                order['from'] != null
                                    ? "${order['from']['formatted_address']}"
                                    : "",
                                style: TextStyle(fontSize: 13.0),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "To: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Flexible(
                              child: Text(
                                order['to'] != null
                                    ? "${order['to']['formatted_address']}"
                                    : "",
                                style: TextStyle(fontSize: 13.0),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                              decoration: _customStyle2(context),
                              child: Text("$_distance km"),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                              decoration: _customStyle2(context),
                              child: Row(
                                children: [
                                  Text(
                                    "$_duration mins",
                                    style: TextStyle(
                                        backgroundColor: Colors.orange[100]),
                                  ),
                                  Icon(Icons.car_repair)
                                ],
                              ),
                            ),
                          ],
                        ),
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

  Decoration _customStyle2(context) {
    return BoxDecoration(
      color: Colors.orange[100],
      borderRadius: BorderRadius.circular(30.0),
    );
  }

  _init() async {
    var from = await store.read('from');
    var to = await store.read('to');
    setState(() {
      order['from'] = from;
      order['to'] = to;
    });
    var response = await getDestance(from, to);
    if (response['rows'][0]['elements'][0]['status'] == 'OK') {
      setState(() {
        _distance =
            (response['rows'][0]['elements'][0]['distance']['value'] / 1000)
                .toStringAsFixed(1);
        _duration =
            (response['rows'][0]['elements'][0]['duration']['value'] / 60)
                .toStringAsFixed(0);
      });
    }
    order['type'] = await store.read('type');
    order['from']['from_state'] = await store.read('from-state');
    order['from']['type'] = await store.read('from-location-type');
    order['to']['to_state'] = await store.read('to-state');
    order['to']['type'] = await store.read('to-location-type');
    order['contacts'] = await store.read('contacts');
    order['moving_date'] = await store.read('moving-date');
    order['moving_size'] = await store.read('moving-size');
    order['office_size'] = await store.read('office-size');
    order['vehicle'] = await store.read('vehicle');
    order['number_of_movers'] = await store.read('number-of-movers');
    var supplies = await store.read('supplies');
    order['supplies'] = [];
    for (int i = 0; i < supplies.length; i++) {
      var obj = {"name": "", "code": "", "number": ""};
      if (supplies[i]['number'] is String) {
        obj['name'] = supplies[i]['name'];
        obj['code'] = supplies[i]['code'];
        obj['number'] = supplies[i]['number'];
        order['supplies'].add(obj);
      }
    }
  }

  Future<List<Mover>> _get() async {
    var response = await getMovers(
        jsonEncode(<String, dynamic>{
          "type": order['type'],
          "from": order['from'],
          "to": order['to'],
          "contacts": order['contacts'],
          "moving_date": order['moving_date'],
          "moving_size": order['moving_size'],
          "office_size": order['office_size'],
          "number_of_movers": order['number_of_movers'],
          "supplies": order['supplies'],
          "vehicle": order['vehicle'],
          "distance": _distance,
          "duration": _duration,
        }),
        'moving/carriers-rate');
    var jsonData = jsonDecode(response.body);
    if (response.statusCode != 200 || jsonData.length == 0) {
      print("erorr $jsonData");
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text('Something is wrong, please check the Source or Destination!'),
      ));
    } else {
      List<Mover> movers = [];
      for (int i = 0; i < jsonData.length; i++) {
        Mover mover = Mover(
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
        movers.add(mover);
      }
      return movers;
    }
  }

  _next(context, mover) async {
    store.save('mover', mover);
    String token = await store.read('token');
    if (token != null) {
      Navigator.pushReplacementNamed(context, '/payment');
    } else {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }
}
