import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Progress extends StatefulWidget {
  int progress = 0;
  Progress(this.progress);
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new CircularPercentIndicator(
        radius: 120.0,
        lineWidth: 13.0,
        animation: true,
        percent: 0.7,
        center: new Text(
          "70%",
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: Colors.orange[900],
      ),
    );
  }
}
