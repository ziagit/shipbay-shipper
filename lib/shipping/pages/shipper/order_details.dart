import 'package:flutter/material.dart';
import 'package:shipbay/shipping/shipping_menu.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shipping/services/api.dart';
import 'package:progress_indicators/progress_indicators.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
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
                PopupMenuItem(child: Text('Mark as received'), value: 1),
              ];
            },
            onSelected: (value) {
              _received(order['job_with_status']['jobstatus']['id']);
            },
          ),
        ],
      ),
      drawer: ShippingMenu(),
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
                          child: Text("Order details",
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
                          child: Text("Pickup details",
                              style: TextStyle(color: primary, fontSize: 18.0)),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Address: ${order['full_address'][0]['city']}, ${order['full_address'][0]['state']}, ${order['full_address'][0]['zip']}, ${order['full_address'][0]['country']['name']}",
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            )),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Name: ${order['contacts'][0]['name']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Phone: ${order['contacts'][0]['phone']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email:${order['contacts'][0]['email']}",
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
                          child: Text("Delivery details",
                              style: TextStyle(color: primary, fontSize: 18.0)),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Address: ${order['full_address'][1]['city']}, ${order['full_address'][1]['state']}, ${order['full_address'][1]['zip']}, ${order['full_address'][1]['country']['name']}",
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            )),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Name: ${order['contacts'][1]['name']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Phone: ${order['contacts'][1]['phone']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email: ${order['contacts'][1]['email']}",
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
                            "Item details",
                            style: TextStyle(color: primary, fontSize: 18.0),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: order['items'].length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.all(0.0),
                              title: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${order['items'][index]['description']}: ${order['items'][index]['dimentional_weight']} Pounds",
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
                          child: Text("Generall details",
                              style: TextStyle(color: primary, fontSize: 18.0)),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${order['pickup_date']}",
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            )),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "\$${order['estimated_value']}",
                            style: TextStyle(color: fontColor, fontSize: 12.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "\$${order['cost']}",
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
    print(data);
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
