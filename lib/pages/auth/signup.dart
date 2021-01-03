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
                  "Register",
                  style: TextStyle(fontSize: 24.0),
                ),
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
                      decoration: InputDecoration(hintText: 'Confirm password'),
                    ),
                    SizedBox(height: 60.0),
                    SizedBox(
                      width: double.infinity,
                      height: 46.0,
                      child: RaisedButton(
                        color: Colors.orange[900],
                        child: Text(
                          "Signup",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () {
                          //;
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(width: 1.0),
                        FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/signin');
                          },
                          child: Text(
                            'Signin',
                            style: TextStyle(color: Colors.orange[900]),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        )
                      ],
                    )
                  ],
                ))
              ],
            ),
          )
        ],
      ),
      // child: Text("This is where your content goes")
    );
  }
}
