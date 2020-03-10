import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SearchItemsEvent extends Equatable {
  const SearchItemsEvent();

  @override
  List<Object> get props => [];
}

class SearchItemsQuery extends SearchItemsEvent {
  final List<String> dormitories;
  final int limit;
  final String query;

  SearchItemsQuery({@required this.dormitories, @required this.limit, @required this.query});

  @override
  List<Object> get props => [query, limit, dormitories];

  @override
  String toString() {
    return 'SearchItemsQuery { query: $query, limit: $limit, dormitories: $dormitories }';
  }
}