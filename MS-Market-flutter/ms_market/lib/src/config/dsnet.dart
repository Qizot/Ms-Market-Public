

class DSNetApiConfig {
  String authUri;
  String clientId;
  String scheme;

  factory DSNetApiConfig({String authUri, String scheme, String clientId}){
    if (DSNetApiConfig._instance == null) {
      DSNetApiConfig._instance = DSNetApiConfig._privateConstructor(authUri: authUri, scheme: scheme, clientId: clientId);
    }
    return _instance;
  }

  DSNetApiConfig._privateConstructor({this.authUri, this.scheme, this.clientId});

  static DSNetApiConfig _instance;

  static DSNetApiConfig get instance { return _instance;}

}