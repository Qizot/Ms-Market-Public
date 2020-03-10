import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_market/src/app.dart';
import 'package:ms_market/src/config/config.dart';
import 'package:ms_market/src/config/dsnet.dart';
import 'package:ms_market/src/resources/providers/auth_provider.dart';
import 'package:ms_market/src/resources/services/dormitories.dart';
import 'package:ms_market/src/resources/services/graphql_client.dart';

String typenameDataIdFromObject(Object object) {
  if (object is Map<String, Object> &&
      object.containsKey('__typename') &&
      object.containsKey('id')) {
    return "${object['__typename']}/${object['id']}";
  }
  return null;
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  final address = "192.168.0.104";

  BlocSupervisor.delegate = SimpleBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  DSNetApiConfig(
    authUri: "https://panel.dsnet.agh.edu.pl/oauth/v2/auth", 
    clientId: "HERE GOES YOUR CLIENT ID",
    scheme: "msmarket",
  );

  AppConfig(
    apiUrl: "http://$address:4000/api/graphql",
    itemImageUrl: "http://$address:8080/image"
  );
  DormitoriesService();

  final HttpLink httpLink = HttpLink(
    uri: AppConfig.instance.apiUrl,
  );

  AuthProvider authProvider = AuthProvider();
  final AuthLink authLink = AuthLink(
    getToken: () async {
      final token = await authProvider.getToken();
      return 'Bearer $token';
    }
  );

  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: NormalizedInMemoryCache(
        dataIdFromObject: typenameDataIdFromObject,
      ),
      link: link,
    )
  );

  GraphqlClientService(client: client);



  runApp(App(client: client));
}



