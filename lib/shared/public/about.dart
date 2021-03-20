import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:flutter_html/flutter_html.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  String _htmlData;
  String _arg;
  String _title = "About Moving";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$_title",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: _htmlData == null
                  ? Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Loading"),
                          JumpingDotsProgressIndicator(
                            fontSize: 20.0,
                          ),
                        ],
                      ),
                    )
                  : Html(
                      data: _htmlData,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _arg = ModalRoute.of(context).settings.arguments;
      _get(_arg);
    });
  }

  _get(_arg) async {
    if (_arg == 'shipping/') {
      setState(() {
        _title = "About shipment";
      });
    }
    var response = await getData('$_arg' + 'get-about');

    var jsonData = jsonDecode(response.body);
    print("..................");
    print("$jsonData");
    setState(() {
      _htmlData = jsonData['body'].toString();
    });
  }
}
