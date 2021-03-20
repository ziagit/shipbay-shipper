import 'package:flutter/material.dart';
import 'package:shipbay/shipping/models/additional_details_model.dart';
import 'package:shipbay/shipping/models/contact_model.dart';
import 'package:shipbay/moving/moving_appbar.dart';
import 'package:shipbay/shipping/shipping_appbar.dart';
import 'package:shipbay/shipping/shipping_menu.dart';
import 'package:shipbay/shared/components/progress.dart';
import 'package:shipbay/shared/services/store.dart';
import 'package:shipbay/shared/services/colors.dart';
import 'package:email_validator/email_validator.dart';

class AdditionalDetails extends StatefulWidget {
  @override
  _AdditionalDetailsState createState() => _AdditionalDetailsState();
}

class _AdditionalDetailsState extends State<AdditionalDetails> {
  Store store = Store();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _estimatedCostController = TextEditingController();
  TextEditingController _instructionsController = TextEditingController();
  String _pickupName;
  String _pickupPhone;
  String _pickupEmail;
  String _deliveryName;
  String _deliveryPhone;
  String _deliveryEmail;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List _contacts;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: ShippingAppBar(''),
      drawer: ShippingMenu(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(child: Progress(progress: 65.0)),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Additional details",
                          style: TextStyle(fontSize: 22.0, height: 2.0),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          style: TextStyle(fontSize: 14.0),
                          controller: _estimatedCostController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid value';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Estimated shipment value(\$)'),
                        ),
                        TextFormField(
                          style: TextStyle(fontSize: 14.0),
                          controller: _instructionsController,
                          decoration:
                              InputDecoration(labelText: 'Instructions'),
                        ),
                        SizedBox(height: 24.0),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Contacts: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              _pickupName == null
                                  ? IconButton(
                                      icon: Icon(Icons.add, color: primary),
                                      onPressed: () {
                                        _addDialog(context);
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.edit, color: primary),
                                      onPressed: () {
                                        _editDialog(context);
                                      })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _pickupName == null
                    ? Container()
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.topLeft,
                        decoration: _customStyle(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("$_pickupName"),
                            Text("$_pickupPhone"),
                            Text("$_pickupEmail"),
                          ],
                        ),
                      ),
                SizedBox(height: 20.0),
                _deliveryName == null
                    ? Container()
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.topLeft,
                        decoration: _customStyle(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("$_deliveryName"),
                            Text("$_deliveryPhone"),
                            Text("$_deliveryEmail"),
                          ],
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: inActive,
              foregroundColor: primary,
              heroTag: "btn",
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/items');
              },
              child: Icon(Icons.keyboard_arrow_left),
            ),
            SizedBox(
              width: 40,
            ),
            FloatingActionButton(
              backgroundColor: primary,
              heroTag: "btn2",
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _next(context);
                }
              },
              child: Icon(Icons.keyboard_arrow_right),
            )
          ],
        ),
      ),
    );
  }

  Decoration _customStyle(context) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        new BoxShadow(
          color: Colors.grey.shade200,
          offset: new Offset(0.0, 10.0),
          blurRadius: 10.0,
          spreadRadius: 1.0,
        )
      ],
    );
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  _addDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return Container(
                height: height - 400, width: width - 100, child: AddContacts());
          },
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context, false), // passing false
            child: Text('Cancel'),
          ),
        ],
      ),
    ).then((contact) {
      if (contact != false) {
        setState(() {
          _pickupName = contact.pickupName;
          _pickupPhone = contact.pickupPhone;
          _pickupEmail = contact.pickupEmail;
          _deliveryName = contact.deliveryName;
          _deliveryPhone = contact.deliveryPhone;
          _deliveryEmail = contact.deliveryEmail;
        });
      }
    });
  }

  _editDialog(context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Builder(
          builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return Container(
              height: height - 400,
              width: width - 100,
              child: EditContacts(
                contacts: {
                  'pickupName': _pickupName,
                  'pickupPhone': _pickupPhone,
                  'pickupEmail': _deliveryEmail,
                  'deliveryName': _deliveryName,
                  'deliveryPhone': _deliveryPhone,
                  'deliveryEmail': _deliveryEmail
                },
              ),
            );
          },
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context, false), // passing false
            child: Text('Cancel'),
          ),
        ],
      ),
    ).then((contact) {
      if (contact != false) {
        setState(() {
          _pickupName = contact.pickupName;
          _pickupPhone = contact.pickupPhone;
          _pickupEmail = contact.pickupEmail;
          _deliveryName = contact.deliveryName;
          _deliveryPhone = contact.deliveryPhone;
          _deliveryEmail = contact.deliveryEmail;
        });
      }
    });
  }

  _init() async {
    var data = await store.read('additional-details');
    print('........................');
    print(data);
    setState(() {
      if (data != null) {
        _estimatedCostController.text = data['estimated_cost'].toString();
        _instructionsController.text = data['instructions'];
        _pickupName = data['pickup_name'];
        _pickupPhone = data['pickup_phone'];
        _pickupEmail = data['pickup_email'];
        _deliveryName = data['delivery_name'];
        _deliveryPhone = data['delivery_phone'];
        _deliveryEmail = data['delivery_email'];
      }
    });
  }

  _next(context) {
    AdditionalDetailsModel additionalDetailsModel = AdditionalDetailsModel();
    additionalDetailsModel.estimated_cost =
        double.parse(_estimatedCostController.text);
    additionalDetailsModel.instructions = _instructionsController.text;
    additionalDetailsModel.pickup_name = _pickupName;
    additionalDetailsModel.pickup_phone = _pickupPhone;
    additionalDetailsModel.pickup_email = _pickupEmail;
    additionalDetailsModel.delivery_name = _deliveryName;
    additionalDetailsModel.delivery_phone = _deliveryPhone;
    additionalDetailsModel.delivery_email = _deliveryEmail;

    if (additionalDetailsModel.estimated_cost == null ||
        additionalDetailsModel.pickup_name == null ||
        additionalDetailsModel.pickup_email == null ||
        additionalDetailsModel.pickup_phone == null ||
        additionalDetailsModel.delivery_name == null ||
        additionalDetailsModel.delivery_email == null ||
        additionalDetailsModel.delivery_phone == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please provide a valid contact information!"),
      ));
    } else {
      store.save('additional-details', additionalDetailsModel);
      Navigator.pushReplacementNamed(context, '/carriers');
    }
  }
}

class AddContacts extends StatefulWidget {
  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  TextEditingController _pickupNameController = TextEditingController();
  TextEditingController _pickupPhoneController = TextEditingController();
  TextEditingController _pickupEmailController = TextEditingController();
  TextEditingController _deliveryNameController = TextEditingController();
  TextEditingController _deliveryPhoneController = TextEditingController();
  TextEditingController _deliveryEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            ExpansionTile(
              backgroundColor: Colors.white,
              initiallyExpanded: true,
              title: Text("Pickup"),
              children: <Widget>[
                TextFormField(
                  controller: _pickupNameController,
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
                  controller: _pickupPhoneController,
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
                  controller: _pickupEmailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required!';
                    }
                    if (!isEmailValid(_pickupEmailController.text)) {
                      return 'Eanter a valid email!';
                    }
                    return null;
                  },
                ),
              ],
            ),
            ExpansionTile(
              backgroundColor: Colors.white,
              title: Text("Delivery"),
              children: <Widget>[
                TextFormField(
                  controller: _deliveryNameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _deliveryPhoneController,
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
                  controller: _deliveryEmailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required!';
                    }
                    if (!isEmailValid(_deliveryEmailController.text)) {
                      return 'Eanter a valid email!';
                    }
                    return null;
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),
            IconButton(
                icon: Icon(Icons.add_circle_outline, color: primary),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _add(context);
                  }
                })
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  bool isEmailValid(email) {
    final bool isValid = EmailValidator.validate(email);
    return isValid;
  }

  _add(context) {
    ContactModel _contactModel = ContactModel();
    _contactModel.pickupName = _pickupNameController.text;
    _contactModel.pickupPhone = _pickupPhoneController.text;
    _contactModel.pickupEmail = _pickupEmailController.text;
    _contactModel.deliveryName = _deliveryNameController.text;
    _contactModel.deliveryPhone = _deliveryPhoneController.text;
    _contactModel.deliveryEmail = _deliveryEmailController.text;
    if ((_contactModel.pickupName).isEmpty ||
        (_contactModel.pickupEmail).isEmpty ||
        (_contactModel.pickupPhone).isEmpty ||
        (_contactModel.deliveryEmail).isEmpty ||
        (_contactModel.deliveryName).isEmpty ||
        (_contactModel.deliveryPhone).isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Provide valid data!"),
        ),
      );
    } else {
      Navigator.pop(context, _contactModel);
    }
  }
}

class EditContacts extends StatefulWidget {
  final contacts;
  EditContacts({Key key, this.contacts}) : super(key: key);
  @override
  _EditContactsState createState() => _EditContactsState();
}

class _EditContactsState extends State<EditContacts> {
  TextEditingController _pickupNameController = TextEditingController();
  TextEditingController _pickupPhoneController = TextEditingController();
  TextEditingController _pickupEmailController = TextEditingController();
  TextEditingController _deliveryNameController = TextEditingController();
  TextEditingController _deliveryPhoneController = TextEditingController();
  TextEditingController _deliveryEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            ExpansionTile(
              backgroundColor: Colors.white,
              initiallyExpanded: true,
              title: Text("Pickup"),
              children: <Widget>[
                TextFormField(
                  controller: _pickupNameController,
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
                  controller: _pickupPhoneController,
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
                  controller: _pickupEmailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required!';
                    }
                    return null;
                  },
                ),
              ],
            ),
            ExpansionTile(
              backgroundColor: Colors.white,
              initiallyExpanded: true,
              title: Text("Delivery"),
              children: <Widget>[
                TextFormField(
                  controller: _deliveryNameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _deliveryPhoneController,
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
                  controller: _deliveryEmailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  style: TextStyle(fontSize: 12.0),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Required!';
                    }
                    return null;
                  },
                ),
              ],
            ),
            SizedBox(height: 20.0),
            IconButton(
                icon: Icon(Icons.add, color: primary),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _update(context);
                  }
                })
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    setState(() {
      _pickupNameController.text = widget.contacts['pickupName'];
      _pickupPhoneController.text = widget.contacts['pickupPhone'];
      _pickupEmailController.text = widget.contacts['pickupEmail'];
      _deliveryNameController.text = widget.contacts['deliveryName'];
      _deliveryPhoneController.text = widget.contacts['deliveryPhone'];
      _deliveryEmailController.text = widget.contacts['deliveryEmail'];
    });
  }

  _update(context) {
    ContactModel _contactModel = ContactModel();
    _contactModel.pickupName = _pickupNameController.text;
    _contactModel.pickupPhone = _pickupPhoneController.text;
    _contactModel.pickupEmail = _pickupEmailController.text;
    _contactModel.deliveryName = _deliveryNameController.text;
    _contactModel.deliveryPhone = _deliveryPhoneController.text;
    _contactModel.deliveryEmail = _deliveryEmailController.text;
    if ((_contactModel.pickupName).isEmpty ||
        (_contactModel.pickupEmail).isEmpty ||
        (_contactModel.pickupPhone).isEmpty ||
        (_contactModel.deliveryEmail).isEmpty ||
        (_contactModel.deliveryName).isEmpty ||
        (_contactModel.deliveryPhone).isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Provide valid data!"),
        ),
      );
    } else {
      Navigator.pop(context, _contactModel);
    }
  }
}
