

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:ms_market/src/config/dsnet.dart';

class DSNetProvider {

  // launches browser for authentication with DSNET panel
  // then gets authorization code required for obtaining access token
  Future<String> getAuthorizationCode() async {
    String authUri = DSNetApiConfig.instance.authUri;
    String clientId = DSNetApiConfig.instance.clientId;
    String scheme = DSNetApiConfig.instance.scheme;

    final url = authUri +
        '?response_type=code&client_id=$clientId&redirect_uri=$scheme:/oauthredirect';
    print(url);

    final result = await FlutterWebAuth.authenticate(
        url: url, callbackUrlScheme: scheme);

    return Uri.parse(result).queryParameters['code'];
  }
}