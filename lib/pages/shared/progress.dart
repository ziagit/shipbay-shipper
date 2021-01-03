import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Progress extends StatefulWidget {
  final double progress;
  Progress({this.progress});
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    double prgValue = widget.progress != null ? widget.progress : 0.0;
    String perce = prgValue.toStringAsFixed(0);
    return Container(
      child: new CircularPercentIndicator(
        radius: 120.0,
        lineWidth: 13.0,
        animation: true,
        percent: prgValue / 100,
        center: new Text(
          "$perce%",
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: Colors.orange[900],
      ),
    );
  }
}
