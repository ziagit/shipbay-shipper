class Carrier {
  int id;
  String first_name;
  String last_name;
  String phone;
  double price;
  String company;
  String detail;
  double rates;
  String website;
  String logo;

  Carrier(this.id, this.first_name, this.last_name, this.phone, this.price,
      this.company, this.detail, this.rates, this.website, this.logo);

  Carrier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    phone = json['phone'];
    price = json['price'].toDouble();
    company = json['company'];
    detail = json['detail'];
    rates = json['rates'].toDouble();
    website = json['website'];
    logo = json['logo'];
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': first_name,
        'last_name': last_name,
        'phone': phone,
        'price': price,
        'company': company,
        'detail': detail,
        'rates': rates,
        'website': website,
        'logo': logo,
      };
}
