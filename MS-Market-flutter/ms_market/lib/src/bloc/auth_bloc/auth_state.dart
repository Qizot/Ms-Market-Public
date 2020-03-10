import 'package:equatable/equatable.dart';
import 'package:ms_market/src/models/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthUninitialized extends AuthState {
  @override
  String toString() {
    return 'AuthUninitialized {}';
  }
}

class AuthAuthenticated extends AuthState {
  final User currentUser;
  final DateTime created;

  AuthAuthenticated({this.currentUser, this.created});

  @override
  List<Object> get props => [currentUser, created];

  @override
  String toString() {
    return 'AuthAuthenticated { user: $currentUser }';
  }
}

class AuthUnauthenticated extends AuthState {
  @override
  String toString() {
    return 'AuthUnauthenticated { }';
  }
}

class AuthError extends AuthState {
  final String error;

  AuthError({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'AuthError { error: $error }';
  }
}

class AuthLoginRequired extends AuthState {
  @override
  String toString() {
    return 'AuthLoginRequired { }';
  }
}

class AuthLoading extends AuthState {
  @override
  String toString() {
    return 'AuthLoading { }';
  }
}

class AuthAccountDeleted extends AuthState {
  @override
  String toString() {
    return 'AuthAccountDeleted { }';
  }
}

