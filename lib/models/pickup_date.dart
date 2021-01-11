class PickupDate {
  String date;
  String time;

  PickupDate();

  PickupDate.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
  }
  Map<String, dynamic> toJson() => {
        'date': date,
        'time': time,
      };
}
