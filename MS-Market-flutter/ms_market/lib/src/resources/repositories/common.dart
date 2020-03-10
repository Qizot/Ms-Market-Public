
import 'package:equatable/equatable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlException extends Equatable implements Exception  {
  final String reason;
  final OperationException error;
  
  @override
  List get props => [reason, error];

  GraphqlException({this.reason, OperationException error}): error = error;

  GraphqlException.fromGraphqlError(OperationException error) :
    reason = "Wystąpił nieznany błąd!", error = error;

  @override
  String toString() {
    return reason;
  }

  String detailedReason() {
    return error?.toString();
  }
}

final connectionEror = GraphqlException(reason: "Wystąpił błąd przy próbie połączenia z serwerem, spróbuj ponownie później");
