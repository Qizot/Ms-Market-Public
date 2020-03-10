

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';
import 'package:ms_market/src/bloc/foreign_item_bloc/bloc.dart';
import 'package:ms_market/src/resources/repositories/common.dart';
import 'package:ms_market/src/resources/repositories/foreign_item_repository.dart';

class ForeignItemBloc extends Bloc<ForeignItemEvent, ForeignItemState> {

  final ForeignItemRepository _repository;
  
  ForeignItemBloc({@required ValueNotifier<GraphQLClient> client}): _repository = ForeignItemRepository(client: client.value);

  @override
  ForeignItemState get initialState => ForeignItemUninitialized();

  @override
  Stream<ForeignItemState> mapEventToState(ForeignItemEvent event) async* {
    if (event is ForeignItemFetchById) {
      yield* _mapFetchItemById(event);
    }
    if (event is ForeignItemCreateRating) {
      yield* _mapCreateItemRating(event);
    }
    if (event is ForeignItemUpdateRating) {
      yield* _mapUpdateItemRating(event);
    }
    if (event is ForeignItemCreateBorrowRequest) {
      yield* _mapCreateBorrowRequest(event);
    }
  }

  Stream<ForeignItemState> _mapFetchItemById(ForeignItemFetchById event) async* {
    try {
      yield ForeignItemLoading();
      final item = await _repository.getItem(itemId: event.itemId, forceRefresh: event.forceRefresh);
      yield ForeignItemFetchedOne(item: item);
    } on GraphqlException catch (err) {
      yield ForeignItemError(error: err.toString());
    }
  }

  Stream<ForeignItemState> _mapCreateItemRating(ForeignItemCreateRating event) async* {
    try {
      yield ForeignItemLoading();
      await _repository.rateItem(itemId: event.itemId, description: event.description, value: event.value);
      yield ForeignItemRated();
    } on GraphqlException catch (err) {
      print(err.detailedReason());
      yield ForeignItemError(error: err.toString());
    }
  }

  Stream<ForeignItemState> _mapUpdateItemRating(ForeignItemUpdateRating event) async* {
    try {
      yield ForeignItemLoading();
      await _repository.updateRating(ratingId: event.ratingId, description: event.description, value: event.value);
      yield ForeignItemRated();
    } on GraphqlException catch (err) {
      print(err.detailedReason());
      yield ForeignItemError(error: err.toString());
    }
  }

  Stream<ForeignItemState> _mapCreateBorrowRequest(ForeignItemCreateBorrowRequest event) async* {
    try {
      yield ForeignItemBorrowRequestLoading();
      await _repository.createBorrowRequest(itemId: event.itemId);
      yield ForeignItemBorrowRequestCreated();
    } on GraphqlException catch (err) {
      yield ForeignItemError(error: err.toString());
    }
  }


}