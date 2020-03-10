import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_market/src/bloc/item_bloc/bloc.dart';
import 'package:ms_market/src/config/config.dart';
import 'package:ms_market/src/resources/providers/image_upload_provider.dart';
import 'package:ms_market/src/resources/repositories/common.dart';
import 'package:ms_market/src/resources/repositories/item_repository.dart';
import 'package:ms_market/src/resources/repositories/user_repository.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository _repository;
  final ValueNotifier<GraphQLClient> _client;
  ItemBloc({@required ValueNotifier<GraphQLClient> client}) : _client = client, _repository = ItemRepository(client: client.value);

  @override
  ItemState get initialState => ItemUninitialized();

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    if (event is ItemFetchOwnerItems) {
      yield* _mapItemFetchList(event);
    }
    if (event is ItemFetchItemById) {
      yield* _mapItemFetchItemById(event);
    }
    if (event is ItemCreate) {
      yield* _mapItemCreate(event);
    }
    if (event is ItemUpdate) {
      yield* _mapItemUpdate(event);
    }
    if (event is ItemDelete) {
      yield* _mapItemDelete(event);
    }
  }

  Stream<ItemState> _mapItemFetchList(ItemFetchOwnerItems event) async* {
    try {
      yield ItemLoading();
      final items = await _repository.getOwnerItems(forceRefresh: event.forceRefresh);
      yield ItemFetchedList(items: items);
    } on GraphqlException catch (err) {
      yield ItemError(error: err.toString());
    }
  }

  Stream<ItemState> _mapItemFetchItemById(ItemFetchItemById event) async* {
    try {
      yield ItemLoading();
      final item = await _repository.getOwnerItem(itemId: event.id, forceRefresh: event.forceRefresh);
      yield ItemFetchedOne(item: item);
    } on GraphqlException catch (err) {
      print(err.detailedReason());
      yield ItemError(error: err.toString());
    }
  }

  Stream<ItemState> _mapItemCreate(ItemCreate event) async* {
    try {
      yield ItemLoading();
      final me = await UserRepository(client: _client.value).getMeInfo();
      final ownerId = me.id;
      event.createItem.ownerId = ownerId;

      final createdItem = await _repository.createItem(event.createItem);
      print("created item, now upload it");
      if (event.imageFile != null) {
        final token = createdItem.imageToken.token;
        final itemId = createdItem.id;
        final upload = await ItemUploadProvider().uploadImage(itemId, token, event.imageFile);
        if (upload.code != 200) {
          yield ItemError(error: "Stworzono przedmiot ale nie udało się dodać zdjęcia");
        } else {
          yield ItemCreated(item: createdItem);
        }
      } else {
        yield ItemCreated(item: createdItem);
      }
    } on GraphqlException catch (err) {
      print(err.detailedReason());
      yield ItemError(error: err.toString());
    } catch (err) {
      print("RANDOM ERROR");
      print(err.toString());
    }
  }

  Stream<ItemState> _mapItemUpdate(ItemUpdate event) async* {
    try {
      yield ItemLoading();
      final updatedItem = await _repository.updateItem(event.updateItem);
      if (event.imageFile != null) {
        final token = updatedItem.imageToken.token;
        final itemId = updatedItem.id;
        final upload = await ItemUploadProvider().uploadImage(itemId, token, event.imageFile);
        if (upload.code != 200) {
          yield ItemError(error: "Uaktualniono przedmiot ale nie udało się dodać zdjęcia");
        } else {
          await DefaultCacheManager().removeFile(AppConfig.instance.itemImageUrl + "/$itemId");
          imageCache.clear();
          yield ItemUpdated(item: updatedItem);
        }
      } else {
        yield ItemUpdated(item: updatedItem);
      }
    } on GraphqlException catch (err) {
      print(err.detailedReason());
      yield ItemError(error: err.toString());
    }
  }

  Stream<ItemState> _mapItemDelete(ItemDelete event) async* {
    try {
      yield ItemDeleteLoading();
      // TODO: there is no sensible way to delete this key from grapqhl cache
      final deletedId = await _repository.deleteItem(event.itemId);
      yield ItemDeleted(id: deletedId);
    } on GraphqlException catch (err) {
      yield ItemError(error: err.toString());
    }
  }


}