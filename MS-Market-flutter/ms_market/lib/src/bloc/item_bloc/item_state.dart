import 'package:equatable/equatable.dart';
import 'package:ms_market/src/models/item/item.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemUninitialized extends ItemState {
  @override
  String toString() {
    return 'ItemUninitialized {}';
  }
}

class ItemLoading extends ItemState {
  @override
  String toString() {
    return 'ItemLoading { }';
  }
}

class ItemDeleteLoading extends ItemState {
  @override
  String toString() {
    return 'ItemDeleteLoading { }';
  }
}

class ItemFetchedList extends ItemState {
  final List<Item> items;

  ItemFetchedList({this.items});

  @override
  List<Object> get props => [items];

  @override
  String toString() {
    return 'ItemFetchedList { items: ${items.length}}';
  }
}

class ItemFetchedOne extends ItemState {
  final Item item;

  ItemFetchedOne({this.item});

  @override
  List<Object> get props => [item];

  @override
  String toString() {
    return 'ItemFetchedOne { item: $item }';
  }
}

class ItemCreated extends ItemState {
  final Item item;

  ItemCreated({this.item});

  @override
  List<Object> get props => [item];

  @override
  String toString() {
    return 'ItemCreated { item: $item }';
  }
}

class ItemUpdated extends ItemState {
  final Item item;

  ItemUpdated({this.item});

  @override
  List<Object> get props => [item];

  @override
  String toString() {
    return 'ItemUpdated {}';
  }
}

class ItemDeleted extends ItemState {
  final String id;

  ItemDeleted({this.id});

  @override
  String toString() {
    return 'ItemDeleted { id: $id }';
  }
}

class ItemError extends ItemState {
  final String error;

  ItemError({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'ItemError { error: $error }';
  }
}



