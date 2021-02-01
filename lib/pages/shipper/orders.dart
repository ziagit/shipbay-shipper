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
        iconTheme: IconThemeData(color: primary),
        elevation: 0,
      ),
      drawer: MainMenu(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          child: bodyData(),
        ),
      ),
    );
  }

  @override
  void initState() {
    _get();
    super.initState();
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

  _get() async {
    var token = await store.read('token');
    var data = await getOrders(token);
    setState(() {
      orders = data;
    });
    print(orders);
  }

  _edit(order) {
    Navigator.pushReplacementNamed(context, '/order-details',
        arguments: order['id']);
  }
}
