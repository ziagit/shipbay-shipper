import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/store.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Store store = Store();
  int _selectedPage = 0;
  PageController _pageController;
  void _changePage(pageNum) {
    setState(() {
      _selectedPage = pageNum;
      _pageController.animateToPage(
        pageNum,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  _onPageViewChange(int page) {
    setState(() {
      _selectedPage = page;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
        body: SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.3, 0.5, 0.7, 0.9],
            colors: [
              Colors.orange[600],
              Colors.orange[200],
              Colors.orange[100],
              Colors.orange[50],
              Colors.orange[50],
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageViewChange,
                children: [
                  Container(
                    child: Center(
                      child: Page1(),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Page2(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TabButton(
                    text: "",
                    pageNumber: 0,
                    selectedPage: _selectedPage,
                    onPressed: () {
                      _changePage(0);
                    },
                  ),
                  SizedBox(width: 10),
                  TabButton(
                    text: "",
                    pageNumber: 1,
                    selectedPage: _selectedPage,
                    onPressed: () {
                      _changePage(1);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          "White gloves moving booked in a few taps.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 60.0,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image(
                                          image: AssetImage(
                                              "assets/images/transparent.png")),
                                    ),
                                    Text(
                                      "Up-front pricing",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10.0),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 60.0,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image(
                                          image: AssetImage(
                                              "assets/images/nosignup.png")),
                                    ),
                                    Text(
                                      "No Signe-up",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10.0),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 60.0,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image(
                                          image: AssetImage(
                                              "assets/images/inssured.png")),
                                    ),
                                    Text(
                                      "Fully Insured",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10.0),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          color: Colors.white,
                          child: Text(
                            "Freight",
                            style: TextStyle(
                                color: primary, fontWeight: FontWeight.w600),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () {
                            _navigate('shipping', '/pickup');
                          },
                        ),
                        SizedBox(width: 10.0),
                        RaisedButton(
                          color: primary,
                          child: Text(
                            "Moving",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () {
                            _navigate('moving', '/moving');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  _navigate(app, path) async {
    await store.save('app', app);
    Navigator.pushReplacementNamed(context, '$path');
  }
}

class TabButton extends StatelessWidget {
  final String text;
  final int selectedPage;
  final int pageNumber;
  final Function onPressed;
  TabButton({this.text, this.selectedPage, this.pageNumber, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 10,
        decoration: BoxDecoration(
            color: selectedPage == pageNumber
                ? Colors.orange[300]
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(color: Colors.orange[300])),
        child: Text(
          text ?? "Tab button",
          style: TextStyle(
              color: selectedPage == pageNumber
                  ? Colors.transparent
                  : Colors.orange[300]),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/stack.png'),
          Text("We offer fast and trusted services!")
        ],
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(80.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/tingsapp2.png'),
          Text("Do you have any shipment?")
        ],
      ),
    );
  }
}
