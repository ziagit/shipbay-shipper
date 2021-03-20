class ContactModel {
  String pickupName;
  String pickupPhone;
  String pickupEmail;
  String deliveryName;
  String deliveryPhone;
  String deliveryEmail;

  ContactModel();
  ContactModel.fromJson(Map<String, dynamic> json) {
    pickupName = json['pickupName'];
    pickupPhone = json['pickupPhone'];
    pickupEmail = json['pickupEmail'];
    deliveryName = json['deliveryName'];
    deliveryPhone = json['deliveryPhone'];
    deliveryEmail = json['deliveryEmail'];
  }
  Map<String, dynamic> toJson() => {
        pickupName: pickupName,
        pickupPhone: pickupPhone,
        pickupEmail: pickupEmail,
        deliveryName: deliveryName,
        deliveryPhone: deliveryPhone,
        deliveryEmail: deliveryEmail
      };
}
