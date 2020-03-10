import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_market/src/bloc/profile_bloc/bloc.dart';
import 'package:ms_market/src/models/borrow_request_filter.dart';
import 'package:ms_market/src/resources/repositories/common.dart';
import 'package:ms_market/src/resources/repositories/user_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ValueNotifier<GraphQLClient> client;
  final UserRepository _repository;

  ProfileBloc({@required ValueNotifier<GraphQLClient> client}) : client = client,_repository = UserRepository(client: client.value);

  @override
  ProfileState get initialState => ProfileUninitialized();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileFetch) {
      yield* _mapFetchProfileEvent(event);
    }
    if (event is ProfileFetchRecentReviews) {
      yield* _mapFetchRecentReviews(event);
    }
    if (event is ProfileFetchIncomingBorrowRequests) {
      yield* _mapFetchIncomingBorrowRequsts(event);
    }
    if (event is ProfileUpdateBorrowRequestStatus) {
      yield* _mapUpdateBorrowRequestStatus(event);
    }
    if (event is ProfileFetchBorrowedItems) {
      yield* _mapFetchBorrowedItems(event);
    }
  }

  Stream<ProfileState> _mapFetchProfileEvent(ProfileFetch event) async* {
    try {
      yield ProfileLoading();
      final me = await _repository.getMeInfo();
      yield ProfileFetched(user: me);
    } on GraphqlException catch (err) {
      yield ProfileError(error: err.toString());
    }
  }

  Stream<ProfileState> _mapFetchRecentReviews(ProfileFetchRecentReviews event) async* {
    try {
      yield ProfileLoading();
      final reviews = await _repository.recentReviews(event.limit, event.forceRefresh);
      yield ProfileRecentReviews(reviews: reviews);
    } on GraphqlException catch (err) {
      yield ProfileError(error: err.toString());
    }
  }

  Stream<ProfileState> _mapFetchIncomingBorrowRequsts(ProfileFetchIncomingBorrowRequests event) async* {
    try {
      yield ProfileLoading();
      final requests = await _repository.getIncomingBorrowRequests(limit: event.limit, statuses: event.statuses, forceRefresh: event.forceRefresh);
      yield ProfileFetchedIncomingBorrowRequests(requests: requests);
    } on GraphqlException catch (err) {
      yield ProfileError(error: err.toString());
    }
  }

  Stream<ProfileState> _mapUpdateBorrowRequestStatus(ProfileUpdateBorrowRequestStatus event) async* {
    try {
      yield ProfileUpdateBorrowRequestLoading();
      final request = await _repository.updateBorrowRequestStatus(borrowRequestId: event.borrowRequestId, status: event.borrowStatus);
      yield ProfileUpdatedBorrowRequestStatus(request: request);
    } on GraphqlException catch (err) {
      yield ProfileError(error: err.toString());
    }
  }

  Stream<ProfileState> _mapFetchBorrowedItems(ProfileFetchBorrowedItems event) async* {
    try {
      yield ProfileLoading();
      final borrowed = await _repository.listActiveBorrowRequsts(filter: BorrowRequestFilter(limit: event.limit, statuses: event.statuses), forceRefresh: event.forceRefresh);
      yield ProfileFetchedBorrowedItems(borrowed: borrowed);
    } on GraphqlException catch (err) {
      yield ProfileError(error: err.toString());
    }
  }
}
