import 'package:flutter/material.dart';
import 'package:shipbay/shipping/shipping_menu.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shipping/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';

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
            color: primary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      drawer: ShippingMenu(),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: orders.length == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
              : Container(child: bodyData())),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Widget bodyData() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
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
                          Text(order['job_with_status']['jobstatus']['title']),
                          showEditIcon: false,
                          placeholder: false),
                      DataCell(
                          IconButton(
                            icon: Icon(Icons.more_horiz, color: primary),
                            onPressed: () {
                              _edit(order['id']);
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
    print("xxxxxxxxxxxxxx");
    print(data);
    setState(() {
      orders = data;
    });
  }

  _edit(id) {
    Navigator.pushNamed(context, '/order-details', arguments: id);
  }
}
