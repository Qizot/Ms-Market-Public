import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ms_market/src/models/borrow_request.dart';

abstract class ForeignItemEvent extends Equatable {
  const ForeignItemEvent();

  @override
  List<Object> get props => [];
}

class ForeignItemFetchById extends ForeignItemEvent {
  final String itemId;
  final bool forceRefresh;

  ForeignItemFetchById({this.itemId, bool forceRefresh = false}): forceRefresh = forceRefresh;

  @override
  List<Object> get props => [itemId, forceRefresh];

  @override
  String toString() {
    return 'ForeignItemFetchById { itemId: $itemId, forceRefresh: $forceRefresh }';
  }
}

class ForeignItemCreateRating extends ForeignItemEvent {
  final String itemId;
  final String description;
  final int value;

  ForeignItemCreateRating({@required this.itemId, @required this.description, @required this.value});

  @override
  List<Object> get props => [itemId, value, description];

  @override
  String toString() {
    return 'ForeignItemCreateRating { itemId: $itemId, description: $description, value: $value }';
  }
}

class ForeignItemUpdateRating extends ForeignItemEvent {
  final String ratingId;
  final String description;
  final int value;

  ForeignItemUpdateRating({@required this.ratingId, this.description, this.value});

  @override
  List<Object> get props => [ratingId, value, description];

  @override
  String toString() {
    return 'ForeignItemUpdateRating { ratingId: $ratingId, description: $description, value: $value }';
  }
}

class ForeignItemDeleteRating extends ForeignItemEvent {
  final String ratingId;

  ForeignItemDeleteRating({@required this.ratingId});

  @override
  List<Object> get props => [ratingId];

  @override
  String toString() {
    return 'ForeignItemDeleteRating { ratingId: $ratingId }';
  }
}

class ForeignItemCreateBorrowRequest extends ForeignItemEvent {
  final String itemId;

  ForeignItemCreateBorrowRequest({@required this.itemId});

  @override
  List<Object> get props => [itemId];

  @override
  String toString() {
    return 'ForeignItemCreateBorrowRequest { itemId: $itemId }';
  }
}

class ForeignItemUpdateBorrowRequest extends ForeignItemEvent {
  final String itemId;
  final BorrowStatus status;

  ForeignItemUpdateBorrowRequest({@required this.itemId, @required this.status});

  @override
  List<Object> get props => [itemId, status];

  @override
  String toString() {
    return 'ForeignItemUpdateBorrowRequest { itemId: $itemId, status: $status }';
  }
}

