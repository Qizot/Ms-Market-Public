import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ms_market/src/models/borrow_request.dart';
import 'package:ms_market/src/models/review.dart';
import 'package:ms_market/src/models/user.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileUninitialized extends ProfileState {
  @override
  String toString() {
    return 'ProfileUninitialized { }';
  }
}

class ProfileLoading extends ProfileState {
  @override
  String toString() {
    return 'ProfileLoading { }';
  }
}

class ProfileUpdateBorrowRequestLoading extends ProfileState {
  @override
  String toString() {
    return 'ProfileUpdateBorrowRequestLoading { }';
  }
}

class ProfileFetched extends ProfileState {
  final User user;
  
  ProfileFetched({this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() {
    return 'ProfileFetched { user: $user }';
  }
}

class ProfileRecentReviews extends ProfileState {
  final List<Review> reviews;

  ProfileRecentReviews({this.reviews});

  @override
  List<Object> get props => [reviews];

  @override
  String toString() {
    return 'ProfileRecentReviews { reviews: $reviews }';
  } 
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'ProfileError { error: $error }';
  }
}

class ProfileFetchedIncomingBorrowRequests extends ProfileState {
  final List<BorrowRequest> requests;

  ProfileFetchedIncomingBorrowRequests({@required this.requests});

  @override
  List<Object> get props => [requests];

  @override
  String toString() {
    return 'ProfileFetchedIncomingBorrowRequests { requestsCount: ${requests.length} }';
  }
}

class ProfileUpdatedBorrowRequestStatus extends ProfileState {
  final BorrowRequest request;

  ProfileUpdatedBorrowRequestStatus({@required this.request});

  @override
  List<Object> get props => [request];

  @override
  String toString() {
    return 'ProfileUpdatedBorrowRequestStatus { request: $request }';
  }
}

class ProfileFetchedBorrowedItems extends ProfileState {
  final List<BorrowRequest> borrowed;

  ProfileFetchedBorrowedItems({@required this.borrowed});

  @override
  List<Object> get props => [borrowed];

  @override
  String toString() {
    return 'ProfileFetchedBorrowedItems { borrowedCount: ${borrowed.length} }';
  }
}