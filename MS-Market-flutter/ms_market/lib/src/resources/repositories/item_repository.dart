
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_market/src/graphql/mutations.dart' as mutation;
import 'package:ms_market/src/graphql/queries.dart' as query;
import 'package:ms_market/src/models/item/item.dart';
import 'package:ms_market/src/resources/repositories/common.dart';

class ItemRepository {
  GraphQLClient _client;

  ItemRepository({@required GraphQLClient client}) : _client = client;

  Future<List<Item>> getOwnerItems({bool forceRefresh = false}) async {

    final WatchQueryOptions options = WatchQueryOptions(
      documentNode: gql(query.ownerItemList),
      fetchResults: true,
      fetchPolicy: forceRefresh ? FetchPolicy.networkOnly : FetchPolicy.cacheFirst
    );

    final queryResult =  await _client.query(options);

    if (queryResult.hasException) {
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }

    final List items = queryResult.data['me']['items'];
    return items.map((v) => Item.fromJson(v)).toList();

  }

  // getOwnerItem is different from getting simple item 
  // as it requires different authorization level than getting somebody's
  // else item
  Future<Item> getOwnerItem({@required String itemId, bool forceRefresh = false}) async {
    final WatchQueryOptions options = WatchQueryOptions(
      documentNode: gql(query.ownerItemDetailed),
      variables: <String, String>{
        "itemId": itemId,
      },
      fetchResults: true,
      fetchPolicy: forceRefresh ? FetchPolicy.networkOnly : FetchPolicy.cacheFirst
    );

    final queryResult = await _client.query(options);

    if (queryResult.hasException) {
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }

    final item = queryResult.data['item'];
    return Item.fromJson(item);
  }

  Future<Item> createItem(CreateItem item) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutation.createItem),
      variables: <String, dynamic>{
        "ownerId": item.ownerId,
        "name": item.name,
        "description": item.description,
        "contractCategory": formatContractCategory(item.contractCategory),
        "itemCategory": formatItemCategory(item.itemCategory),
        "expiresAt": item.expiresAt?.toIso8601String()
      },
    );

    final queryResult =  await _client.mutate(options);

    if (queryResult.hasException) {
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }
    final createdItem = queryResult.data['createItem'];
    return Item.fromJson(createdItem);

  }


  Future<Item> updateItem(UpdateItem item) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutation.updateItem),
      variables: <String, dynamic>{
        "id": item.id,
        "name": item.name,
        "description": item.description,
        "contractCategory": formatContractCategory(item.contractCategory),
        "itemCategory": formatItemCategory(item.itemCategory),
        "expiresAt": item.expiresAt?.toIso8601String()
      },
    );

    final queryResult =  await _client.mutate(options);

    if (queryResult.hasException) {
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }
    final updatedItem = queryResult.data['updateItem'];
    return Item.fromJson(updatedItem);
  }

  Future<String> deleteItem(String itemId) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutation.deleteItem),
      variables: <String, String> {
        "itemId": itemId
      }
    );

    final queryResult =  await _client.mutate(options);

    if (queryResult.hasException) {
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }
    final deletedId = queryResult.data['deleteItem']['id'];
    return deletedId;
  }

}