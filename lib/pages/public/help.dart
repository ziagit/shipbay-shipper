import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shipbay/services/settings.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  num position = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: primary),
        elevation: 0,
      ),
      body: Center(
        child: Text("Content of Help Center will be loaded here."),
      ),

      /* IndexedStack(
        index: position,
        children: <Widget>[
          WebView(
            initialUrl: 'http://35.184.16.20/#/help',
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (value) {
              setState(() {
                position = 1;
              });
            },
            onPageFinished: (value) {
              setState(() {
                position = 0;
              });
            },
          ),
          Container(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(primary),
              ),
            ),
          ),
        ], 
      ),*/
    );
  }
}
