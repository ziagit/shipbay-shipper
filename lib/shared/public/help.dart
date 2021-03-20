import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/api.dart';
import 'package:flutter_html/flutter_html.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> with SingleTickerProviderStateMixin {
  String _help;
  List _carrier;
  List _shipper;
  String _arg;
  TabController _controller;
  int _selectedIndex = 0;

  List<Widget> list = [
    Tab(icon: Icon(Icons.help_rounded), text: "How it works?"),
    Tab(icon: Icon(Icons.local_shipping_rounded), text: "Carrier"),
    Tab(icon: Icon(Icons.shopping_bag_sharp), text: "Shipper"),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Help Center",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: primary,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          bottom: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              controller: _controller,
              tabs: list),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _help == null
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
                      data: _help,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _carrier == null
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
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _carrier.length,
                      itemBuilder: (context, index) {
                        return ExpansionTile(
                          title: Text(_carrier[index]['title']),
                          children: [
                            Html(
                              data: _carrier[index]['body'],
                            ),
                          ],
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _shipper == null
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
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _shipper.length,
                      itemBuilder: (context, index) {
                        return ExpansionTile(
                          title: Text(_shipper[index]['title']),
                          children: [
                            Html(
                              data: _shipper[index]['body'],
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      _arg = ModalRoute.of(context).settings.arguments;
      print(_arg);
      _get(0, _arg);
    });

    // Create TabController for getting the index of current tab
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      _get(_selectedIndex, _arg);
    });
  }

  _get(_selectedIndex, _arg) async {
    if (_help == null && _selectedIndex == 0) {
      var response = await getData('$_arg' + 'get-faq');
      var jsonData = jsonDecode(response.body);
      setState(() {
        _help = jsonData['body'].toString();
      });
    } else if (_carrier == null && _selectedIndex == 1) {
      var response = await getFaqs('$_arg' + 'get-carrier-faq');

      print(response);
      setState(() {
        _carrier = response;
      });
    } else if (_shipper == null && _selectedIndex == 2) {
      var response = await getFaqs('$_arg' + 'get-shipper-faq');
      setState(() {
        _shipper = response;
      });
    }
  }
}
