import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text("Login"),
                  Form(
                      child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Username'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: 'Password'),
                      ),
                      SizedBox(height: 16.0),
                      FlatButton(
                        onPressed: () {},
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.orange[900]),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      ),
                      FlatButton(
                        onPressed: () {},
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.orange[900]),
                        ),
                        shape: Border.all(color: Colors.orange[900]),
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
