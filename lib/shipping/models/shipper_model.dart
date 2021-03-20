class ShipperModel {
  String first_name;
  String last_name;
  String country;
  String state;
  String city;
  String zip;
  String address;
  String phone;
  int addressId;
  int contactId;
  ShipperModel();
  ShipperModel.fromJson(Map<String, dynamic> json) {
    first_name = json['first_name'];
    last_name = json['last_name'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    zip = json['zip'];
    address = json['address'];
    phone = json['phone'];
    addressId = json['addressId'];
    contactId = json['contactId'];
  }
  Map<String, dynamic> toJson() => {
        'first_name': first_name,
        'last_name': last_name,
        'country': country,
        'state': state,
        'city': city,
        'zip': zip,
        'address': address,
        'phone': phone,
        'addressId': addressId,
        'contactId': contactId,
      };
}
