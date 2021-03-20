class Country {
  String name;
  String id;
  String code;
  String created_at;
  String updated_at;

  Country(this.id, this.name, this.code, this.created_at, this.updated_at);

  Country.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'].toString();
    this.name = jsonObject['name'].toString();
    this.code = jsonObject['code'].toString();
    this.created_at = jsonObject['created_at'].toString();
    this.updated_at = jsonObject['updated_at'].toString();
  }
}
