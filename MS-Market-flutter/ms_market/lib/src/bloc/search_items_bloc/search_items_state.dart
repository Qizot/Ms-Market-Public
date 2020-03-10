
import 'package:equatable/equatable.dart';
import 'package:ms_market/src/models/item_search/dormitory_search_result.dart';

abstract class SearchItemsState extends Equatable {
  const SearchItemsState();

  @override
  List<Object> get props => [];
}


class SearchItemsUninitialized extends SearchItemsState {
  @override
  String toString() {
    return 'SearchItemsUninitialized { }';
  }
}

class SearchItemsLoading extends SearchItemsState {
  @override
  String toString() {
    return 'SearchItemsLoading { }';
  }
}

class SearchItemsResult extends SearchItemsState {
  final List<DormitorySearchResult> results;

  SearchItemsResult({this.results});

  @override
  List<Object> get props => [results];

  @override
  String toString() {
    final dormitories = results.length;
    int items = 0;
    results.forEach((v) => items += v.results.length);
    return 'SerchItemsResult { dormitories: $dormitories, items: $items }';
  }
}

class SearchItemsError extends SearchItemsState {
  final String error;

  SearchItemsError({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'SearchItemsError { error: $error }';
   }
}