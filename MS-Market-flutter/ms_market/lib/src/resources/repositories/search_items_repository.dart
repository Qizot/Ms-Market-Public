import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';
import 'package:ms_market/src/models/item_search/dormitory_search_result.dart';
import 'package:ms_market/src/graphql/queries.dart' as query;
import 'package:ms_market/src/resources/repositories/common.dart';

class SearchItemsRepository {
  GraphQLClient _client;

  SearchItemsRepository({@required GraphQLClient client}) : _client = client;

  Future<List<DormitorySearchResult>> searchItemsByDormitories({@required List<String> dormitories, @required int limit, @required String queryString}) async {

    final WatchQueryOptions options = WatchQueryOptions(
      documentNode: gql(query.dormitoryItemSearch),
      fetchResults: true,
      variables: <String, dynamic>{
        "limit": limit,
        "query": queryString,
        "dormitories": dormitories
      }
    );

    final queryResult =  await _client.query(options);

    if (queryResult.hasException) {
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }

    final List dormitoryItemSearchResults = queryResult.data['dormitoryItemsSearch'];
    final results = dormitoryItemSearchResults.map((v) => DormitorySearchResult.fromJson(v)).toList();
    
    // filter out results where searching score happened to be zero
    for (var result in results) {
      result.results = result.results.where((r) => r.score > 0).toList();
    }

    return results.where((r) => r.results.length > 0).toList();
  }
}