import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shipbay/services/settings.dart';
import 'package:shipbay/models/placePredictions.dart';
import 'package:shipbay/pages/shared/divider.dart';
import 'package:shipbay/pages/shared/prediction_tile.dart';

class GoogleAddress extends StatefulWidget {
  final selectedAddress;
  final keyword;
  GoogleAddress({Key key, this.selectedAddress, this.keyword})
      : super(key: key);
  @override
  _GoogleAddressState createState() => _GoogleAddressState();
}

class _GoogleAddressState extends State<GoogleAddress> {
  TextEditingController _addressController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          autofocus: true,
          controller: _addressController,
          decoration: InputDecoration(hintText: 'Postal code'),
          onChanged: (val) {
            findPlace(val);
          },
        ),
        (placePredictionList.length > 0)
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListView.separated(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (context, index) {
                    return PredictionTile(
                      placePredictions: placePredictionList[index],
                      callback: (val) {
                        widget.selectedAddress(val);
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, index) =>
                      DividerWidget(),
                  itemCount: placePredictionList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.keyword);
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoComplete =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components:ca";
      var res = await http.get(autoComplete);
      Map data = jsonDecode(res.body);
      var predictions = data['predictions'];
      var placesList = (predictions as List)
          .map((e) => PlacePredictions.fromJson(e))
          .toList();
      setState(() {
        placePredictionList = placesList;
      });
    }
  }
}