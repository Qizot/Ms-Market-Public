

import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlClientService {
  ValueNotifier<GraphQLClient> _client;

  factory GraphqlClientService({ValueNotifier<GraphQLClient> client}){
    if (GraphqlClientService._instance == null) {
      GraphqlClientService._instance = GraphqlClientService._privateConstructor(client: client);
    }
    return _instance;
  }

  GraphqlClientService._privateConstructor({@required ValueNotifier<GraphQLClient> client}) : _client = client;

  static GraphqlClientService _instance;

  static ValueNotifier<GraphQLClient> get client { return _instance?._client;}
}