import 'package:flutter/material.dart';
import 'package:shipbay/moving/moving_menu.dart';
import 'package:shipbay/moving/services/api.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';

class CustomerOrderDetails extends StatefulWidget {
  @override
  _CustomerOrderDetailsState createState() => _CustomerOrderDetailsState();
}

class _CustomerOrderDetailsState extends State<CustomerOrderDetails> {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  bool received = false;
  Store store = Store();
  var order;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: primary),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<int>(
            key: _key,
            itemBuilder: (context) {
              return <PopupMenuEntry<int>>[
                PopupMenuItem(child: Text('Received'), value: 1),
              ];
            },
            onSelected: (value) {
              _received(order['job_with_status']['jobstatus']['id']);
            },
          ),
        ],
      ),
      drawer: MovingMenu(),
      body: Container(
        child: order == null
            ? Container(
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Loading"),
                    JumpingDotsProgressIndicator(
                      fontSize: 20.0,
                    ),
                  ],
                )),
              )
            : ListView(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                    padding: EdgeInsets.all(20.0),
                    decoration: _customStyle(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Order",
                              style: TextStyle(color: primary, fontSize: 18.0)),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              order['uniqid'],
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            )),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              order['created_at'],
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                    padding: EdgeInsets.all(20.0),
                    decoration: _customStyle(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("From",
                              style: TextStyle(color: primary, fontSize: 18.0)),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Address: ${order['addresses'][0]['formatted_address']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Location type: ${order['locationtypes'][0]['title']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Floor: ${order['floor_from']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Used: ${order['movingtypes'][0]['title']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                    padding: EdgeInsets.all(20.0),
                    decoration: _customStyle(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("To",
                              style: TextStyle(color: primary, fontSize: 18.0)),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Address: ${order['addresses'][1]['formatted_address']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Location type: ${order['locationtypes'][1]['title']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Floor: ${order['floor_to']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Used: ${order['movingtypes'].length > 1 ? order['movingtypes'][1]['title'] : null}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                    padding: EdgeInsets.all(20.0),
                    decoration: _customStyle(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Contacts",
                              style: TextStyle(color: primary, fontSize: 18.0)),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${order['contact']['name']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${order['contact']['phone']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${order['contact']['email']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                    padding: EdgeInsets.all(20.0),
                    decoration: _customStyle(context),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Supplies",
                            style: TextStyle(color: primary, fontSize: 18.0),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: order['supplies'].length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.all(0.0),
                              title: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${order['supplies'][index]['name']}: ${order['supplies'][index]['pivot']['number']}",
                                      style: TextStyle(
                                          color: fontColor, fontSize: 12.0),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                    padding: EdgeInsets.all(20.0),
                    decoration: _customStyle(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Other information",
                              style: TextStyle(color: primary, fontSize: 18.0)),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Date to pickup: ${order['pickup_date']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Apointment time: ${order['appointment_time']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Type: ${order['type']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Number of requested movers: ${order['movernumber']['number']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        order['officesize'] == null
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Moving size: ${order['movingsize']['title']}",
                                  style: TextStyle(
                                      color: fontColor, fontSize: 12.0),
                                ),
                              )
                            : Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Moving size: ${order['officesize']['title']}",
                                  style: TextStyle(
                                      color: fontColor, fontSize: 12.0),
                                ),
                              ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Selected vehicle: ${order['vehicle']['name']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                    padding: EdgeInsets.all(20.0),
                    decoration: _customStyle(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Selected carrier",
                              style: TextStyle(color: primary, fontSize: 18.0)),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Name: ${order['job_with_status']['carrier']['first_name']}",
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            )),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Company name: ${order['job_with_status']['carrier']['company']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      int orderId = ModalRoute.of(context).settings.arguments;
      print("order id.................$orderId");
      _get(orderId);
    });
  }

  _get(id) async {
    var token = await store.read('token');
    var data = await getOrder(id.toString(), token);
    print("....................x.......................");
    print(data['supplies']);
    setState(() {
      order = data;
    });
    print(order['items']);
  }

  void _received(value) async {
    print(".....................");
    print(value);
  }
}
