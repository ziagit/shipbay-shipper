class Carrier {
  int index;
  String first_name;
  String last_name;
  String phone;
  double price;
  String company;
  String detail;
  int rates;
  String website;
  String logo;

  Carrier(this.index, this.first_name, this.last_name, this.phone, this.price,
      this.company, this.detail, this.rates, this.website, this.logo);

  Carrier.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    phone = json['phone'];
    price = json['price'];
    company = json['company'];
    detail = json['detail'];
    rates = json['rates'];
    website = json['website'];
    logo = json['logo'];
  }
  Map<String, dynamic> toJson() => {
        'index': index,
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
