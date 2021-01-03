import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';

class PickupDate extends StatefulWidget {
  @override
  _PickupDateState createState() => _PickupDateState();
}

class _PickupDateState extends State<PickupDate> {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

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
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay _timePicker = await showTimePicker(
        context: context,
        initialTime: _time,
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.deepOrange,
            ),
            child: child,
          );
        });
    if (_timePicker != null && _timePicker != _time) {
      setState(() {
        _time = _timePicker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool is_appointment = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xF8FAF8),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/pickup-services');
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 25.0)),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "When to pickup?",
                        style: TextStyle(fontSize: 24.0, height: 2.0),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        onTap: () {
                          _selectDate(context);
                        },
                        decoration: InputDecoration(hintText: 'Select a date'),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: <Widget>[
                          Flexible(
                              child: CheckboxListTile(
                            activeColor: Colors.pink[300],
                            dense: true,
                            title: Text(
                              "Appointment",
                              style: TextStyle(fontSize: 11.0),
                            ),
                            value: is_appointment,
                            onChanged: (bool value) {
                              setState(() {
                                print("app value $value");
                                is_appointment = value;
                              });
                            },
                          ))
                        ],
                      ),
                      Visibility(
                        visible: is_appointment,
                        child: TextFormField(
                          onTap: () {
                            _selectTime(context);
                          },
                          decoration: InputDecoration(hintText: 'Select time'),
                        ),
                      ),
                      SizedBox(height: 16.0),
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
                          SizedBox(width: 16.0),
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
