import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ms_market/src/models/item/item.dart';

abstract class ForeignItemState extends Equatable {
  const ForeignItemState();

  @override
  List<Object> get props => [];
}

class ForeignItemUninitialized extends ForeignItemState {
  @override
  String toString() {
    return 'ForeignItemUninitialized { }';
  }
}

class ForeignItemLoading extends ForeignItemState {
  @override
  String toString() {
    return 'ForeignItemLoading { }';
  }
}

class ForeignItemFetchedOne extends ForeignItemState {
  final Item item;

  ForeignItemFetchedOne({@required this.item});

  @override
  List<Object> get props => [item];

  @override
  String toString() {
    return 'ForeignItemFetchedOne { item: $item }';
  }
}

class ForeignItemError extends ForeignItemState {
  final String error;

  ForeignItemError({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'ForeignItemError { error: $error }';
  }
}

class ForeignItemRated extends ForeignItemState {
  @override
  String toString() {
    return 'ForeignItemRated { }';
  }
}

class ForeignItemBorrowRequestLoading extends ForeignItemState {
  @override
  String toString() {
    return 'ForeignItemBorrowRequestLoading { }';
  }
}

class ForeignItemBorrowRequestCreated extends ForeignItemState {
  @override
  String toString() {
    return 'ForeignItemBorrowRequestCreated { }';
  }
}