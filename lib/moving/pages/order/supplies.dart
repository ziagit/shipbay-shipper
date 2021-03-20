import 'package:flutter/material.dart';
import 'package:shipbay/moving/moving_menu.dart';
import 'package:shipbay/moving/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/moving/moving_appbar.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/store.dart';

class Supplies extends StatefulWidget {
  @override
  _SuppliesState createState() => _SuppliesState();
}

class _SuppliesState extends State<Supplies> {
  Store store = Store();

  bool rememberMe = false;
  List supplies;
  String supplyNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MovingAppBar(''),
      drawer: MovingMenu(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 72.0)),
                Container(
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Moving supplies",
                          style: TextStyle(fontSize: 22.0, height: 2.0),
                        ),
                        SizedBox(height: 16.0),
                        supplies == null
                            ? Container(
                                child: Text("Loading..."),
                              )
                            : Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: supplies.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Supply(
                                                index: index,
                                                supNumber: supplies[index]
                                                    ['number'],
                                                customFunction: _updateData,
                                              ),
                                              Text(
                                                  "${supplies[index]['name']}"),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 30.0,
                                            child: Text(int.parse(
                                                        "${supplies[index]['number']}") >
                                                    0
                                                ? "${supplies[index]['number']}"
                                                : ""),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  SizedBox(height: 20.0),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        50, 10, 50, 10),
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
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        onPressed: () {
                                          _next(context);
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        50, 10, 50, 10),
                                    child: SizedBox(
                                      width: 300,
                                      height: 46.0,
                                      child: RaisedButton(
                                        child: Text(
                                          "Back",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: primary),
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context, '/moving-date');
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
    super.initState();
    _init();
  }

  _init() async {
    var s = await store.read('supplies');
    if (s == null) {
      _getSupplies();
    } else {
      setState(() {
        supplies = s;
      });
    }
  }

  _updateData(index, value) {
    setState(() {
      supplies[index]['number'] = value;
    });
  }

  _next(context) async {
    await store.save('supplies', supplies);
    Navigator.pushReplacementNamed(context, '/contacts');
  }

  _getSupplies() async {
    List response = await getData('moving/moving-supplies');
    print("init supplies");
    print(response);
    setState(() {
      supplies = response;
    });
  }
}

class Supply extends StatefulWidget {
  final supNumber;
  final index;
  final customFunction;
  Supply({Key key, this.index, this.supNumber, this.customFunction})
      : super(key: key);

  @override
  _SupplyState createState() => _SupplyState();
}

class _SupplyState extends State<Supply> {
  bool rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: rememberMe,
        activeColor: primary,
        onChanged: _onRememberMeChanged);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  _init() {
    if (widget.supNumber is String) {
      rememberMe = true;
    }
  }

  void _onRememberMeChanged(bool newValue) => setState(
        () {
          rememberMe = newValue;
          if (rememberMe) {
            _addNumber(context);
          } else {
            widget.customFunction(widget.index, 0);
          }
        },
      );
  void _addNumber(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('How many?'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            var width = MediaQuery.of(context).size.width;
            return Form(
              key: _formKey,
              child: Container(
                height: 150,
                width: width - 100,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _numberController,
                      decoration: InputDecoration(labelText: 'number'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    FlatButton(
                        child: Text(
                          'Add',
                          style: TextStyle(fontSize: 12.0, color: Colors.white),
                        ),
                        color: primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0)),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Navigator.pop(context, _numberController.text);
                          }
                        })
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context, false), // passing false
            child: Text('Cancel'),
          ),
        ],
      ),
    ).then((value) {
      if (value != null && value != false) {
        widget.customFunction(widget.index, value);
      } else {
        setState(() {
          rememberMe = false;
        });
      }
    });
  }
}
