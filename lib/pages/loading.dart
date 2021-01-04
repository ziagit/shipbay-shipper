import 'package:flutter/material.dart';
import 'package:shipbay/services/api.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String name = 'Loading';

  void setupCountries() async {
    Countries instance =
        Countries(name: 'Canada', code: 'CA', url: 'countries/1');
    await instance.getData();
    Navigator.pushReplacementNamed(context, '/home',
        arguments: {'name': instance.name, 'code': instance.code});
  }

  @override
  void initState() {
    super.initState();
    setupCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(50.0),
      child: Text(name),
    ));
  }
}
