

class Dormitory {
  String name;
  String fullname;
  double latitude;
  double longitude;
  int index;

  Dormitory({this.name, this.fullname, this.latitude, this.longitude});

  Dormitory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fullname = json['fullname'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['fullname'] = this.fullname;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['index'] = index;
    return data;
  }

}