class ImageToken {
  String id;
  String itemId;
  String token;

  ImageToken({this.id, this.itemId, this.token});

  ImageToken.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['itemId'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['itemId'] = this.itemId;
    data['token'] = this.token;
    return data;
  }
}