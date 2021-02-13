import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shipbay/services/settings.dart';

class Privacy extends StatefulWidget {
  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
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
        child: Text("Content of privacy will be loaded here"),
      ),
    );
  }
}
