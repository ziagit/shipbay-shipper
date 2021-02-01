import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/main_menu.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/settings.dart';
import 'package:shipbay/services/api.dart';
import 'package:progress_indicators/progress_indicators.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Store store = Store();
  var orderId;
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
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/orders');
          },
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.edit,
                color: primary,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      drawer: MainMenu(),
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
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: _customStyle(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Order details",
                                style:
                                    TextStyle(color: primary, fontSize: 18.0)),
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
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: _customStyle(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Pickup details",
                                style:
                                    TextStyle(color: primary, fontSize: 18.0)),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${order['full_address'][0]['city']}, ${order['full_address'][0]['state']}, ${order['full_address'][0]['zip']}, ${order['full_address'][0]['country']['name']}",
                                style:
                                    TextStyle(color: fontColor, fontSize: 12.0),
                              )),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${order['contacts'][0]['name']}",
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${order['contacts'][0]['phone']}",
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${order['contacts'][0]['email']}",
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: _customStyle(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Delivery details",
                                style:
                                    TextStyle(color: primary, fontSize: 18.0)),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${order['full_address'][1]['city']}, ${order['full_address'][1]['state']}, ${order['full_address'][1]['zip']}, ${order['full_address'][1]['country']['name']}",
                                style:
                                    TextStyle(color: fontColor, fontSize: 12.0),
                              )),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${order['contacts'][1]['name']}",
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${order['contacts'][1]['phone']}",
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${order['contacts'][1]['email']}",
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
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
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: _customStyle(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Generall details",
                                style:
                                    TextStyle(color: primary, fontSize: 18.0)),
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
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "\$${order['cost']}",
                              style:
                                  TextStyle(color: fontColor, fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
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
      orderId = ModalRoute.of(context).settings.arguments;
    });
    _get();
  }

  _get() async {
    var token = await store.read('token');
    var data = await getOrder(orderId.toString(), token);
    setState(() {
      order = data;
    });
    print(order['items']);
  }
}
