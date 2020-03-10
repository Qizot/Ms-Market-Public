

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_market/src/graphql/mutations.dart' as mutation;
import 'package:ms_market/src/graphql/queries.dart' as query;
import 'package:meta/meta.dart';
import 'package:ms_market/src/models/borrow_request.dart';
import 'package:ms_market/src/models/item/item.dart';
import 'package:ms_market/src/models/item/rating.dart';
import 'package:ms_market/src/resources/repositories/common.dart';

class ForeignItemRepository {
  GraphQLClient _client;

  ForeignItemRepository({@required GraphQLClient client}) : _client = client;

  Future<Item> getItem({@required String itemId, bool forceRefresh = false}) async {

    final WatchQueryOptions options = WatchQueryOptions(
      documentNode: gql(query.getForeignItem),
      fetchResults: true,
      fetchPolicy: forceRefresh ? FetchPolicy.networkOnly : FetchPolicy.cacheFirst,
      variables: <String, String>{
        "itemId": itemId
      }
    );

    final queryResult =  await _client.query(options);

    if (queryResult.hasException) {
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }

    return Item.fromJson(queryResult.data['item']);
  }

  Future<Rating> rateItem({@required String itemId, @required String description, @required int value}) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutation.createItemRating),
      variables: <String, dynamic>{
        "itemId": itemId,
        "description": description,
        "value": formatRatingValue(convertToRatingValue(value))
      }
    );

    final queryResult = await _client.mutate(options);

    if (queryResult.hasException) {
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }

    return Rating.fromJson(queryResult.data['rateItem']);
  }

  Future<Rating> updateRating({@required String ratingId, @required String description, @required int value}) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutation.updateItemRating),
      variables: <String, dynamic>{
        "ratingId": ratingId,
        "description": description,
        "value": formatRatingValue(convertToRatingValue(value))
      }
    );

    final queryResult = await _client.mutate(options);

    if (queryResult.hasException) {
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }

    return Rating.fromJson(queryResult.data['updateItemRating']);
  }

  Future<BorrowRequest> createBorrowRequest({@required String itemId}) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutation.createBorrowRequets),
      variables: <String, String>{
        "itemId": itemId
      }
    );

    final queryResult = await _client.mutate(options);

    if (queryResult.hasException) {
      // a nasty way to obtain error but flutter_graphql does not seem to do it well
      // a shit way as any server change will fuck it up for sure
      bool hasUserAlreadyRequestedItem = false;
      try {
        hasUserAlreadyRequestedItem = 
          (queryResult.exception.graphqlErrors[0].raw['message'][1][0] as String) == ("user has already an active request for given item");

      } catch (err) {
        hasUserAlreadyRequestedItem = false;
      }

      if (hasUserAlreadyRequestedItem) {
        throw GraphqlException(reason: "Masz już aktywną prośbę o wypożyczenie tego przedmiotu", error: queryResult.exception);
      }

      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }

    return BorrowRequest.fromJson(queryResult.data['createBorrowRequest']);
  }
}