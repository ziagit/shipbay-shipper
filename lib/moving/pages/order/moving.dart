import 'package:flutter/material.dart';
import 'package:shipbay/moving/moving_menu.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/moving/moving_appbar.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/store.dart';

class Moving extends StatefulWidget {
  @override
  _MovingState createState() => _MovingState();
}

class _MovingState extends State<Moving> {
  List types;
  Store store = Store();

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
                Container(child: Progress(progress: 0)),
                Container(
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Moving type?",
                          style: TextStyle(fontSize: 22.0, height: 2.0),
                        ),
                        SizedBox(height: 16.0),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(50, 10, 50, 10),
                              child: SizedBox(
                                width: 300,
                                height: 46.0,
                                child: RaisedButton(
                                    color: primary,
                                    child: Text(
                                      "Office",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    onPressed: () {
                                      _next(context, 'office');
                                    }),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(50, 10, 50, 10),
                              child: SizedBox(
                                width: 300,
                                height: 46.0,
                                child: RaisedButton(
                                    color: primary,
                                    child: Text(
                                      "Residential",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    onPressed: () {
                                      _next(context, 'residential');
                                    }),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(50, 10, 50, 10),
                              child: SizedBox(
                                width: 300,
                                height: 46.0,
                                child: FlatButton(
                                  child: Text(
                                    "Back",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: primary),
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  onPressed: () {
                                    _back(context);
                                  },
                                ),
                              ),
                            )
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
  void initState() {}

  _next(context, type) async {
    await store.save('type', type);
    Navigator.pushReplacementNamed(context, '/from');
  }

  _back(constext) async {
    Navigator.pushReplacementNamed(context, '/home');
  }
}
