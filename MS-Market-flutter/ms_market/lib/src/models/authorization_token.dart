class AuthorizationToken {
  String token;
  String tokenType;
  int ttl;

  AuthorizationToken({this.token, this.tokenType, this.ttl});

  AuthorizationToken.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    tokenType = json['tokenType'];
    ttl = json['ttl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['tokenType'] = this.tokenType;
    data['ttl'] = this.ttl;
    return data;
  }
}