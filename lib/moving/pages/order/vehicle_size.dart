import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shipbay/moving/moving_menu.dart';
import 'package:shipbay/moving/services/api.dart';
import 'package:shipbay/moving/moving_appbar.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';

class VehicleSize extends StatefulWidget {
  @override
  _VehicleSizeState createState() => _VehicleSizeState();
}

class _VehicleSizeState extends State<VehicleSize> {
  List types;
  String type;
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
                Container(child: Progress(progress: 36.0)),
                Container(
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Select the size of vehicle?",
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
                                            message: type == 'office'
                                                ? "${types[index]['office_recommended']}"
                                                : "${types[index]['recommended']}",
                                            child: RaisedButton(
                                                color: primary,
                                                child: Text(
                                                  "${types[index]['name']}",
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
                                        color: Colors.transparent,
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
    _init();
    _get();
  }

  _init() async {
    String t = await store.read('type');
    setState(() {
      type = t;
    });
    print(type);
  }

  _next(context, type) async {
    await store.save('vehicle', type);
    Navigator.pushReplacementNamed(context, '/number-of-movers');
  }

  _back(context) async {
    if (await store.read("type") == "office") {
      Navigator.pushReplacementNamed(context, '/office-sizes');
    } else {
      Navigator.pushReplacementNamed(context, '/moving-sizes');
    }
  }

  _get() async {
    List response = await getData('moving/vehicles');
    print(response);
    setState(() {
      types = response;
    });
  }
}
