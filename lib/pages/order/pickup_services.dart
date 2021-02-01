import 'package:flutter/material.dart';
import 'package:shipbay/pages/shared/progress.dart';
import 'package:shipbay/pages/store/store.dart';
import 'package:shipbay/services/settings.dart';

class PickupServices extends StatefulWidget {
  @override
  _PickupServicesState createState() => _PickupServicesState();
}

class _PickupServicesState extends State<PickupServices> {
  Map<String, bool> _services = {
    'Inside pickup': false,
    'Tailgate': false,
  };
  @override
  Widget build(BuildContext context) {
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
            Navigator.pushReplacementNamed(context, '/pickup');
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                SizedBox(child: Progress(progress: 12.0)),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Pickup services",
                        style: TextStyle(fontSize: 22.0, height: 2.0),
                      ),
                      SizedBox(height: 16.0),
                      ListView(
                        shrinkWrap: true,
                        children: _services.keys.map((String key) {
                          return CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: primary,
                            value: _services[key],
                            onChanged: (bool val) {
                              setState(() {
                                _services[key] = val;
                              });
                            },
                            title: Text(
                              key,
                              style: TextStyle(fontSize: 11.0),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: 0,
                            backgroundColor: inActive,
                            foregroundColor: primary,
                            child: Icon(Icons.keyboard_arrow_left),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/pickup');
                            },
                          ),
                          SizedBox(width: 16.0),
                          FloatingActionButton(
                            heroTag: 1,
                            backgroundColor: primary,
                            child: Icon(Icons.keyboard_arrow_right),
                            onPressed: () {
                              _next(context);
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

  @override
  void initState() {
    super.initState();
    _init();
  }

  _next(context) {
    Store store = Store();
    store.save('pickup-services', _services);
    Navigator.pushReplacementNamed(context, '/pickup-date');
  }

  _init() async {
    Store store = Store();
    var data = await store.read('pickup-services');
    if (data != null) {
      setState(() {
        _services['Inside pickup'] = data['Inside pickup'];
        _services['Tailgate'] = data['Tailgate'];
      });
    }
  }
}
