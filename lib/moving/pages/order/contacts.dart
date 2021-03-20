import 'package:flutter/material.dart';
import 'package:shipbay/moving/moving_menu.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:shipbay/shared/services/settings.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shipbay/moving/moving_appbar.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/store.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  Store store = Store();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _instructionsController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: MovingAppBar(''),
      drawer: MovingMenu(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 90.0)),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Contact details",
                          style: TextStyle(fontSize: 22.0, height: 2.0),
                        ),
                        TextFormField(
                          controller: _nameController,
                          style: TextStyle(fontSize: 12.0),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                        ),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Phone'),
                          style: TextStyle(fontSize: 12.0),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required!';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          style: TextStyle(fontSize: 12.0),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Required!';
                            }
                            if (!isEmailValid(_emailController.text)) {
                              return 'Eanter a valid email!';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 14.0),
                          controller: _instructionsController,
                          decoration:
                              InputDecoration(labelText: 'Instructions'),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                          child: SizedBox(
                            width: 300,
                            height: 46.0,
                            child: RaisedButton(
                              color: primary,
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                _next(context);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                          child: SizedBox(
                            width: 300,
                            height: 46.0,
                            child: RaisedButton(
                              child: Text(
                                "Back",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: primary),
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/supplies');
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  bool isEmailValid(email) {
    final bool isValid = EmailValidator.validate(email);
    return isValid;
  }

  _init() async {
    var data = await store.read('contacts');
    print(data);
    if (data != null) {
      setState(() {
        _instructionsController.text = data['instructions'];
        _nameController.text = data['name'];
        _phoneController.text = data['phone'];
        _emailController.text = data['email'];
      });
    }
  }

  _next(context) {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please provide valid contact information!"),
      ));
    } else {
      store.save('contacts', {
        "name": _nameController.text,
        "phone": _phoneController.text,
        "email": _emailController.text,
        "instructions": _instructionsController.text
      });
      Navigator.pushReplacementNamed(context, '/movers');
    }
  }
}
