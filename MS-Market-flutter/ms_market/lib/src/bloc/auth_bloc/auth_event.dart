import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthAuthenticate extends AuthEvent {
  @override
  String toString() {
    return "AuthAuthenticate { }";
  }
}

class AuthLogin extends AuthEvent {
  final String code;

  AuthLogin({this.code});

  @override
  List<Object> get props => [code];

  @override
  String toString() {
    return 'AuthLogin { code: $code }';
  }
}

class AuthLogout extends AuthEvent {
  @override
  String toString() {
    return 'AuthLogout { }';
  }
}

class AuthDeleteAccount extends AuthEvent {
  @override
  String toString() {
    return 'AuthDeleteAccount { }';
  }
}