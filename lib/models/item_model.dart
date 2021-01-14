class ItemModel {
  String description;
  String type;
  double length;
  double width;
  double height;
  double weight;
  int number;

  ItemModel();
  ItemModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    type = json['type'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    weight = json['weight'];
    number = json['number'];
  }
  Map<String, dynamic> toJson() => {
        'description': description,
        'type': type,
        'length': length,
        'width': width,
        'height': height,
        'weight': weight,
        'number': number,
      };
}
