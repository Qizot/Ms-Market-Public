import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:ms_market/src/models/item/item.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object> get props => [];
}

class ItemFetchOwnerItems extends ItemEvent {
  final bool forceRefresh;

  ItemFetchOwnerItems({bool forceRefresh = false}) : forceRefresh = forceRefresh;

  @override
  String toString() {
    return 'ItemFetchOwnerItems {}';
  }
}

class ItemFetchItemById extends ItemEvent {
  final String id;
  final bool forceRefresh;

  ItemFetchItemById({this.id, bool forceRefresh = false}): forceRefresh = forceRefresh;

  @override
  List<Object> get props => [id, forceRefresh];

  @override
  String toString() {
    return 'ItemFetchItemById { id: $id, forceRefresh: $forceRefresh }';
  }
}

class ItemCreate extends ItemEvent {
  final CreateItem createItem;
  final File imageFile;

  ItemCreate({this.createItem, this.imageFile});

  @override
  List<Object> get props => [createItem];

  @override
  String toString() {
    return 'ItemCreate { item: $createItem }';
  }
}

class ItemUpdate extends ItemEvent {
  final UpdateItem updateItem;
  final File imageFile;

  ItemUpdate({this.updateItem, this.imageFile});

  @override
  List<Object> get props => [updateItem];

  @override
  String toString() {
  return 'ItemUpdate { updateItem: $updateItem }';
   }
}

class ItemDelete extends ItemEvent {
  final String itemId;

  ItemDelete({this.itemId});

  @override
  List<Object> get props => [itemId];

  @override
  String toString() {
    return 'ItemDelete { itemId: $itemId }';
  }

}