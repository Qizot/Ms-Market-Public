
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ms_market/src/config/config.dart';

class ItemImageUploadStatus {
  int code;
  String message;
  ItemImageUploadStatus({this.code, this.message});
}

class ItemUploadProvider {
  Dio dio = Dio();

  String _getExtension(String filename) {
    var index = filename.lastIndexOf('.');
    return filename.substring(index);
  }
  Future<ItemImageUploadStatus> uploadImage(String itemId, String token, File image) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(image.path, filename: itemId + _getExtension(image.path))
    });
    final response = await dio.post(AppConfig.instance.itemImageUrl + "/$itemId", 
      data: formData, 
      options: Options(
        headers: <String, String>{
          "Authorization": token,
          "Content-Type": "application/json"
        }
      )
    );
    print(response.data);
    final r = ItemImageUploadStatus(code: response.statusCode, message: response.data);
    print("got here");
    return r;
  }
}