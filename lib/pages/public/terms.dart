import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shipbay/services/settings.dart';

class Terms extends StatefulWidget {
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  num position = 1;
  WebViewController _myController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: primary),
        elevation: 0,
      ),
      body: Center(
        child: Text("Content of terms will be loaded here"),
      ),
    );
  }
}
