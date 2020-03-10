

class AppConfig {
  String apiUrl;
  String itemImageUrl;


  factory AppConfig({String apiUrl, String itemImageUrl}){
    if (AppConfig._instance == null) {
      AppConfig._instance = AppConfig._privateConstructor(apiUrl: apiUrl, itemImageUrl: itemImageUrl);
    }
    return _instance;
  }

  AppConfig._privateConstructor({this.apiUrl, this.itemImageUrl});

  static AppConfig _instance;

  static AppConfig get instance { return _instance;}

}