import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.0),
          color: Colors.orange[900],
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  margin: EdgeInsets.only(top: 30.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://s3.amazonaws.com/creativetim_bucket/new_logo.png'),
                        fit: BoxFit.fill),
                  ),
                ),
                Text(
                  'Zia Akbari',
                  style: TextStyle(fontSize: 22.0, color: Colors.white),
                ),
                Text(
                  'zia.csco@gmail.com',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text(
            "Profile",
            style: TextStyle(fontSize: 18.0),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/shipper');
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text(
            "Settings",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        ListTile(
          leading: Icon(Icons.arrow_back),
          title: Text(
            "Logout",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ],
    ));
  }
}
