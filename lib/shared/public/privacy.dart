import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:flutter_html/flutter_html.dart';

class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  String _htmlData;
  String _arg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy Notice",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
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
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Html(
                  data: _htmlData,
                ),
              ),
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _arg = ModalRoute.of(context).settings.arguments;
      print(_arg);
      _get(_arg);
    });
  }

  _get(_arg) async {
    var response = await getData('$_arg' + 'get-privacy');
    var jsonData = jsonDecode(response.body);
    setState(() {
      _htmlData = jsonData['body'].toString();
    });
  }
}
