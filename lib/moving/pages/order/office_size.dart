import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shipbay/moving/moving_menu.dart';
import 'package:shipbay/moving/services/api.dart';
import 'package:shipbay/moving/moving_appbar.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';

class OfficeSize extends StatefulWidget {
  @override
  _OfficeSizeState createState() => _OfficeSizeState();
}

class _OfficeSizeState extends State<OfficeSize> {
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
                Container(child: Progress(progress: 24.0)),
                Container(
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Office size",
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
                                          child: Tooltip(
                                            message:
                                                "${types[index]['employees']}",
                                            child: RaisedButton(
                                                color: primary,
                                                child: Text(
                                                  "${types[index]['title']}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(30.0)),
                                                onPressed: () {
                                                  _next(context, types[index]);
                                                }),
                                          ),
                                        ),
                                      );
                                    },
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
  void initState() {
    super.initState();
    _getOfficeSizes();
  }

  _next(context, type) async {
    await store.remove('moving-size');
    await store.save('office-size', type);
    Navigator.pushReplacementNamed(context, '/vehicle-sizes');
  }

  _back(constext) async {
    if (await store.read('to-state') != null) {
      Navigator.pushReplacementNamed(context, '/to-state');
    } else {
      Navigator.pushReplacementNamed(context, '/to');
    }
  }

  _getOfficeSizes() async {
    List response = await getData('moving/office-sizes');
    setState(() {
      types = response;
    });
  }
}
