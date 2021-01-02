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
        backgroundColor: Colors.orange[900],
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/carriers');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          width: 350.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            // the box shawdow property allows for fine tuning as aposed to shadowColor
            boxShadow: [
              new BoxShadow(
                  color: Colors.grey.shade200,
                  // offset, the X,Y coordinates to offset the shadow
                  offset: new Offset(0.0, 10.0),
                  // blurRadius, the higher the number the more smeared look
                  blurRadius: 10.0,
                  spreadRadius: 1.0)
            ],
          ),

          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: <Widget>[
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
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.orange[900]),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ],
          ),
          // child: Text("This is where your content goes")
        ),
      ),
    );
  }
}
