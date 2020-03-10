


import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';
import 'package:ms_market/src/bloc/search_items_bloc/bloc.dart';
import 'package:ms_market/src/resources/repositories/common.dart';
import 'package:ms_market/src/resources/repositories/search_items_repository.dart';

class SearchItemsBloc extends Bloc<SearchItemsEvent, SearchItemsState> {

  final SearchItemsRepository _repository;
  
  SearchItemsBloc({@required ValueNotifier<GraphQLClient> client}): _repository = SearchItemsRepository(client: client.value);

  @override
  SearchItemsState get initialState => SearchItemsUninitialized();

  @override
  Stream<SearchItemsState> mapEventToState(SearchItemsEvent event) async* {
    if (event is SearchItemsQuery) {
      try {
        yield SearchItemsLoading();
        final results = await _repository.searchItemsByDormitories(dormitories: event.dormitories, limit: event.limit, queryString: event.query);
        yield SearchItemsResult(results: results);
      } on GraphqlException catch (err) {
        print(err.detailedReason());
        yield SearchItemsError(error: "Wystąpił nieznany błąd");
      }
    }
  }
}