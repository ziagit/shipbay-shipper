import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';

class PickupDate extends StatefulWidget {
  @override
  _PickupDateState createState() => _PickupDateState();
}

class _PickupDateState extends State<PickupDate> {
  String title = "Pick a date";
  DateTime _date = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2020),
        lastDate: DateTime(2050),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.deepOrange,
            ),
            child: child,
          );
        });
    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
        print(_date.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: Text("Pickup date"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
            child: Column(
          children: <Widget>[
            Expanded(
              child: Progress(),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Pickup time",
                      style: TextStyle(fontSize: 24.0, height: 2.0),
                    ),
                    TextFormField(
                      onTap: () {
                        _selectDate(context);
                      },
                      decoration: InputDecoration(hintText: 'Select a date'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                            value: false,
                            onChanged: (val) {
                              setState(() {
                                //do nothing
                              });
                            }),
                        Text(
                          "Appointment",
                          style: TextStyle(fontSize: 11.0),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton(
                          heroTag: 0,
                          backgroundColor: Colors.orange[50],
                          foregroundColor: Colors.orange[900],
                          child: Icon(Icons.keyboard_arrow_left),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/pickup-services');
                          },
                        ),
                        SizedBox(width: 12.0),
                        FloatingActionButton(
                          heroTag: 1,
                          backgroundColor: Colors.orange[900],
                          child: Icon(Icons.keyboard_arrow_right),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/delivery');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
