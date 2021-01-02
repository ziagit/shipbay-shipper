import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
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
                      "Register",
                      style: TextStyle(fontSize: 24.0),
                    ),
                    SizedBox(height: 16.0),
                    Form(
                        child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Name'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Email'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Password'),
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Confirm password'),
                        ),
                        SizedBox(height: 16.0),
                        FlatButton(
                          onPressed: () {},
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.orange[900]),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/signin');
                          },
                          child: Text(
                            'Already have an account',
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
              )
            ],
          ),
          // child: Text("This is where your content goes")
        ),
      ),
    );
  }
}
