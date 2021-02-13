import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/main_menu.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/api.dart';
import 'package:shipbay/services/settings.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Store store = Store();
  List orders = List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
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
      drawer: MainMenu(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: bodyData(),
        ),
      ),
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  Widget bodyData() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: orders.length == 0
              ? Container(
                  child: Column(
                    children: [
                      Text("There is no order yet"),
                      SizedBox(height: 20.0),
                      RaisedButton(
                        color: primary,
                        child: Text(
                          "Start",
                          style: TextStyle(fontSize: 12.0, color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/pickup');
                        },
                      )
                    ],
                  ),
                )
              : DataTable(
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text("Origin"),
                      numeric: false,
                      onSort: (i, b) {},
                    ),
                    DataColumn(
                      label: Text("Destination"),
                      numeric: false,
                      onSort: (i, b) {},
                    ),
                    DataColumn(
                      label: Text("Date"),
                      numeric: false,
                      onSort: (i, b) {},
                    ),
                    DataColumn(
                      label: Text("Status"),
                      numeric: false,
                      onSort: (i, b) {},
                    ),
                    DataColumn(
                      label: Text("Actions"),
                      numeric: false,
                      onSort: (i, b) {},
                    ),
                  ],
                  rows: orders
                      .map(
                        (order) => DataRow(
                          cells: [
                            DataCell(
                                Text(
                                  order['full_address'][0]['city'],
                                ),
                                showEditIcon: false,
                                placeholder: false),
                            DataCell(Text(order['full_address'][1]['city']),
                                showEditIcon: false, placeholder: false),
                            DataCell(Text(order['created_at']),
                                showEditIcon: false, placeholder: false),
                            DataCell(
                                Text(order['job_with_status']['jobstatus']
                                    ['title']),
                                showEditIcon: false,
                                placeholder: false),
                            DataCell(
                                IconButton(
                                  icon: Icon(Icons.more_horiz, color: primary),
                                  onPressed: () {
                                    _edit(order);
                                  },
                                ),
                                showEditIcon: false,
                                placeholder: false),
                          ],
                        ),
                      )
                      .toList(),
                ),
        ),
      );

  _init() async {
    var token = await store.read('token');
    var data = await getOrders(token);
    setState(() {
      orders = data;
    });
  }

  _edit(order) {
    Navigator.pushReplacementNamed(context, '/order-details',
        arguments: order['id']);
  }
}
