import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ms_market/src/models/borrow_request.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileFetch extends ProfileEvent {
  @override
  String toString() {
    return 'ProfileFetch {}';
  }
}

class ProfileFetchRecentReviews extends ProfileEvent {
  final int limit;
  final bool forceRefresh;

  ProfileFetchRecentReviews({this.limit, bool forceRefresh = false}) : forceRefresh = forceRefresh;

  @override
  List<Object> get props => [limit, forceRefresh];

  @override
  String toString() {
    return 'ProfileFetchRecentReviews { limit: $limit, forceRefresh: $forceRefresh }';
  }
}

class ProfileFetchIncomingBorrowRequests extends ProfileEvent {
  final int limit;
  final List<BorrowStatus> statuses;
  final bool forceRefresh;

  ProfileFetchIncomingBorrowRequests({@required this.limit, @required this.statuses, bool forceRefresh = false}): forceRefresh = forceRefresh;

  @override
  List<Object> get props => [limit, props, forceRefresh];

  @override
  String toString() {
    return 'ProfileFetchIncomingBorrowRequests { limit: $limit, statuses: $statuses, forceRefresh: $forceRefresh }';
  }
}

class ProfileUpdateBorrowRequestStatus extends ProfileEvent {
  final String borrowRequestId;
  final BorrowStatus borrowStatus;

  ProfileUpdateBorrowRequestStatus({@required this.borrowRequestId, @required this.borrowStatus});

  @override
  List<Object> get props => [borrowRequestId, borrowStatus];

  @override
  String toString() {
    return 'ProfileUpdateBorrowRequestStatus { borrowRequestId: $borrowRequestId, borrowStatus: $borrowStatus }';
  }
}

class ProfileFetchBorrowedItems extends ProfileEvent {
  final int limit;
  final List<BorrowStatus> statuses;
  final bool forceRefresh;

  ProfileFetchBorrowedItems({@required this.limit, @required this.statuses, bool forceRefresh = false}): forceRefresh = forceRefresh;

  @override
  List<Object> get props => [limit, statuses, forceRefresh];

  @override
  String toString() {
    return 'ProfileFetchBorrowedItems { limit: $limit, statuses: $statuses, forceRefresh: $forceRefresh }';
  }
}
