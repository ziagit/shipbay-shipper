import 'package:flutter/material.dart';
import 'package:shipbay/services/settings.dart';

class HowWorks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: primary),
      ),
      body: Center(
        child: Text("How it works will be loaded here"),
      ),
    );
  }
}
