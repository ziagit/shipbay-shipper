import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shipbay/moving/models/moving_date_model.dart';
import 'package:shipbay/moving/moving_menu.dart';
import 'package:shipbay/shared/services/colors.dart';

import 'package:shipbay/shared/services/settings.dart';
import 'package:shipbay/moving/moving_appbar.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/store.dart';

class MovingDate extends StatefulWidget {
  @override
  _MovingDateState createState() => _MovingDateState();
}

class _MovingDateState extends State<MovingDate> {
  Store store = Store();

  bool _isAppointment = false;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
                Container(child: Progress(progress: 60.0)),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "When you moving?",
                          style: TextStyle(fontSize: 22.0, height: 2.0),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _dateController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid address';
                            }
                            return null;
                          },
                          decoration:
                              InputDecoration(hintText: 'Select a date'),
                          onTap: () {
                            _selectDate(context);
                          },
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              activeColor: primary,
                              value: _isAppointment,
                              onChanged: (bool val) {
                                setState(() {
                                  _isAppointment = val;
                                  if (!val) {
                                    _timeController.text = null;
                                  }
                                });
                              },
                            ),
                            Text(
                              "Appointment",
                              style: TextStyle(fontSize: 11.0),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: _isAppointment,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _timeController,
                                onTap: () {
                                  _selectTime(context);
                                },
                                decoration:
                                    InputDecoration(hintText: 'Select time'),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                          child: SizedBox(
                            width: 300,
                            height: 46.0,
                            child: RaisedButton(
                              color: primary,
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                _next(context);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                          child: SizedBox(
                            width: 300,
                            height: 46.0,
                            child: RaisedButton(
                              child: Text(
                                "Back",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: primary),
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/number-of-movers');
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: _date.subtract(Duration(days: 0)),
        lastDate: DateTime(2100),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.orange,
            ),
            child: child,
          );
        });
    if (_datePicker != null && _datePicker != _date) {
      DateFormat formater = DateFormat('yyyy-MM-dd');
      String stringFormat = formater.format(_datePicker);

      setState(() {
        _dateController = TextEditingController(text: stringFormat);
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
              primarySwatch: Colors.orange,
            ),
            child: child,
          );
        });
    if (_timePicker != null && _timePicker != _time) {
      String stringFormat = _timeFormater(_timePicker);
      setState(() {
        _timeController = TextEditingController(text: stringFormat);
      });
    }
  }

  String _timeFormater(_t) {
    String _h = _t.hour < 10 ? "0" + _t.hour.toString() : _t.hour.toString();
    String _m =
        _t.minute < 10 ? "0" + _t.minute.toString() : _t.minute.toString();
    String _ampm = _t.hour >= 12 ? 'pm' : 'am';
    return "$_h:$_m $_ampm";
  }

  _next(context) async {
    MovingDateModel movingDateModel = MovingDateModel();
    movingDateModel.date = _dateController.text;
    movingDateModel.time = _isAppointment ? _timeController.text : null;
    movingDateModel.is_appointment = _isAppointment;
    await store.save('moving-date', movingDateModel);
    if (_isAppointment && _timeController.text == '') {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Time is required!'),
      ));
    } else {
      Navigator.pushReplacementNamed(context, '/supplies');
    }
  }

  _init() async {
    var data = await store.read('moving-date');
    if (data != null) {
      setState(() {
        _dateController.text = data['date'];
        _timeController.text = data['time'];
        _isAppointment = data['is_appointment'];
      });
    }
  }
}
