class PickupDateModel {
  String date;
  String time;
  bool is_appointment;

  PickupDateModel();

  PickupDateModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    is_appointment = json['is_appointment'];
  }
  Map<String, dynamic> toJson() => {
        'date': date,
        'time': time,
        'is_appointment': is_appointment,
      };
}
