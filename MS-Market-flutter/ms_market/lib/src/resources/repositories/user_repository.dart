

import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_market/src/graphql/mutations.dart' as mutation;
import 'package:ms_market/src/graphql/queries.dart' as query;
import 'package:ms_market/src/models/authorization_token.dart';
import 'package:ms_market/src/models/borrow_request.dart';
import 'package:ms_market/src/models/borrow_request_filter.dart';
import 'package:ms_market/src/models/review.dart';
import 'package:ms_market/src/models/user.dart';
import 'package:ms_market/src/resources/repositories/common.dart';

class UserRepository {
  GraphQLClient _client;

  UserRepository({@required GraphQLClient client}) : _client = client;

  Future<User> getMeInfo() async {
    final WatchQueryOptions options = WatchQueryOptions(
      documentNode: gql(query.meInfo),
      fetchResults: true
    );
    final queryResult = await _client.query(options);

    if (queryResult.hasException) {
      if (queryResult.exception.toString().contains('Failed to connect')) {
        throw connectionEror;
      }
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }

    return User.fromJson(queryResult.data['me']);
  }

  Future<AuthorizationToken> login(String code) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutation.login),
      variables: <String, String>{
        "code": code
      },
      fetchPolicy: FetchPolicy.networkOnly
    );

    final queryResult = await _client.mutate(options);

    if (queryResult.hasException) {
      print(queryResult.exception.toString());
      if (queryResult.exception.toString().contains('Failed to connect')) {
        throw connectionEror;
      }
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }

    return AuthorizationToken.fromJson(queryResult.data["login"]);
  }

  Future<List<Review>> recentReviews(int limit, bool forceRefresh) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(query.meRecentReviews),
      variables: <String, int>{
        "limit": limit
      },
      fetchPolicy: forceRefresh ? FetchPolicy.networkOnly : FetchPolicy.cacheFirst
    );
    
    final queryResult = await _client.query(options);

    if (queryResult.hasException) {
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }
    final List reviews = queryResult.data['me']['recentReviews'];
    return reviews.map((v) => Review.fromJson(v)).toList();
  }

  Future<List<BorrowRequest>> getIncomingBorrowRequests({@required int limit, @required List<BorrowStatus> statuses, bool forceRefresh = false}) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(query.incomingBorrowRequests),
      variables: <String, dynamic>{
        "limit": limit,
        "statuses": statuses.map((v) => formatBorrowStatus(v)).toList()
      },
      fetchPolicy: forceRefresh ? FetchPolicy.networkOnly : FetchPolicy.cacheFirst
    );

    final queryResult = await _client.query(options);

    if (queryResult.hasException) {
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }

    final List requests = queryResult.data['incomingBorrowRequests'];
    return requests.map((v) => BorrowRequest.fromJson(v)).toList();
  }

  Future<BorrowRequest> updateBorrowRequestStatus({@required String borrowRequestId, @required BorrowStatus status}) async {
    final MutationOptions options = MutationOptions(
      documentNode: gql(mutation.updateBorrowRequest),
      variables: <String, String>{
        "borrowRequestId": borrowRequestId,
        "status": formatBorrowStatus(status)
      }
    );

    final queryResult = await _client.mutate(options);

    if (queryResult.hasException) {
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }

    return BorrowRequest.fromJson(queryResult.data['updateBorrowRequest']);
  }

  Future<List<BorrowRequest>> listActiveBorrowRequsts({@required BorrowRequestFilter filter, bool forceRefresh}) async {
    final QueryOptions options = QueryOptions(
      documentNode: gql(query.meBorrowedItems),
      variables: <String, dynamic>{
        "limit": filter.limit,
        "statuses": filter.statuses.map((v) => formatBorrowStatus(v)).toList()
      },
      fetchPolicy: forceRefresh ? FetchPolicy.networkOnly : FetchPolicy.cacheFirst
    );

    final queryResult = await _client.query(options);

    if (queryResult.hasException) {
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }

    final List requests = queryResult.data['me']['borrowRequests'];
    return requests.map((v) => BorrowRequest.fromJson(v)).toList();
  }

  Future<String> deleteAccount() async {
    final currentUser = await getMeInfo();

    final MutationOptions options = MutationOptions(
      documentNode: gql(mutation.deleteAccount),
      variables: <String, String>{
        "userId": currentUser.id
      }
    );

    final queryResult = await _client.mutate(options);

    if (queryResult.hasException) {
      throw GraphqlException.fromGraphqlError(queryResult.exception);
    }

    return queryResult.data['deleteUser']['deletedUserId'];

  }

  set client(GraphQLClient client) => _client = client;
}