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
        backgroundColor: Color(0xF8FAF8),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/carriers');
          },
        ),
      ),

      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 150.0,
                  child: Image(
                    image: AssetImage('assets/images/coffeequery.png'),
                  ),
                ),
                SizedBox(height: 24.0),
                Text(
                  "Login",
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(
                  height: 16.0,
                ),
                Form(
                    child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Username'),
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Password'),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(width: 1.0),
                        FlatButton(
                          child: Text("Forget password"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 24.0),
                    SizedBox(
                      width: double.infinity,
                      height: 46.0,
                      child: RaisedButton(
                        color: Colors.orange[900],
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () {
                          //
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(width: 1.0),
                        FlatButton(
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.orange[900]),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                        ),
                      ],
                    ),
                  ],
                ))
              ],
            ),
          ),
        ],
      ),
      // child: Text("This is where your content goes")
    );
  }
}
