class AdditionalDetailsModel {
  double estimated_cost;
  String instructions;
  String pickup_name;
  String pickup_phone;
  String pickup_email;
  String delivery_name;
  String delivery_phone;
  String delivery_email;

  AdditionalDetailsModel();
  AdditionalDetailsModel.fromJson(Map<String, dynamic> json) {
    estimated_cost = json['estimated_cost'];
    instructions = json['instructions'];
    pickup_name = json['pickup_name'];
    pickup_phone = json['pickup_phone'];
    pickup_email = json['pickup_email'];
    delivery_name = json['delivery_name'];
    delivery_phone = json['delivery_phone'];
    delivery_email = json['delivery_email'];
  }
  Map<String, dynamic> toJson() => {
        'estimated_cost': estimated_cost,
        'instructions': instructions,
        'pickup_name': pickup_name,
        'pickup_phone': pickup_phone,
        'pickup_email': pickup_email,
        'delivery_name': delivery_name,
        'delivery_phone': delivery_phone,
        'delivery_email': delivery_email,
      };
}
