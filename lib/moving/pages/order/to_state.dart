import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shipbay/moving/moving_menu.dart';
import 'package:shipbay/moving/services/api.dart';
import 'package:shipbay/moving/moving_appbar.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';

class ToState extends StatefulWidget {
  @override
  _ToStateState createState() => _ToStateState();
}

class _ToStateState extends State<ToState> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _stairController = TextEditingController();
  var selectedType;
  List<dynamic> types;
  Store store = Store();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MovingAppBar(''),
      drawer: MovingMenu(),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                SizedBox(child: Progress(progress: 18.0)),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "What will be used there?",
                        style: TextStyle(fontSize: 22.0, height: 2.0),
                      ),
                      SizedBox(height: 16.0),
                      types == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Loading"),
                                JumpingDotsProgressIndicator(
                                  fontSize: 20.0,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: types.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          50, 10, 50, 10),
                                      child: SizedBox(
                                        width: 200,
                                        height: 46.0,
                                        child: RaisedButton(
                                            color: primary,
                                            child: Text(
                                              "${types[index]['title']}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0)),
                                            onPressed: () {
                                              _next(context, types[index]);
                                            }),
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(50, 10, 50, 10),
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
                                            context, '/from');
                                      },
                                    ),
                                  ),
                                )
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

  @override
  void initState() {
    super.initState();
    _init();
    _get();
  }

  _next(context, type) async {
    if (type['code'] == 'stair') {
      this.selectedType = type;
      _addStair(context);
    } else {
      await store.save('to-state', {
        "title": type['title'],
        "code": type['code'],
        "floor": null,
      });
      if (await store.read("type") == "office") {
        Navigator.pushReplacementNamed(context, '/office-sizes');
      } else {
        Navigator.pushReplacementNamed(context, '/moving-sizes');
      }
    }
  }

  _init() async {
    var data = await store.read('to-state');
    if (data != null) {
      setState(() {
        _stairController.text = data['floor'];
        selectedType = data;
      });
    }
  }

  _get() async {
    var response = await getData('moving/moving-types');
    setState(() {
      types = response;
    });
  }

  void _addStair(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Which floor?'),
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
                      controller: _stairController,
                      decoration:
                          InputDecoration(labelText: 'number of floors'),
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
                            Navigator.pop(context, _stairController.text);
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
    ).then((value) async {
      if (value != null && value != false) {
        await store.save('to-state', {
          "title": selectedType['title'],
          "code": selectedType['code'],
          "floor": value,
        });
        if (await store.read("type") == "office") {
          Navigator.pushReplacementNamed(context, '/office-sizes');
        } else {
          Navigator.pushReplacementNamed(context, '/moving-sizes');
        }
      } else {
        setState(() {
          print("dialog canceled");
        });
      }
    });
  }
}
