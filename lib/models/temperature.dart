class Temperature {
  double max_temp;
  double min_temp;

  Temperature();
  Temperature.fromJson(Map<String, dynamic> json) {
    max_temp = json['max_temp'];
    min_temp = json['min_temp'];
  }
  Map<String, dynamic> toJson() => {'max_temp': max_temp, 'min_temp': min_temp};
}
