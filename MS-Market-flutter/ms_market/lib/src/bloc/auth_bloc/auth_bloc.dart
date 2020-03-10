import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_market/src/resources/providers/auth_provider.dart';
import 'package:ms_market/src/resources/repositories/common.dart';
import 'package:ms_market/src/resources/repositories/user_repository.dart';
import 'bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ValueNotifier<GraphQLClient> client;
  UserRepository _repository;

  AuthBloc({@required ValueNotifier<GraphQLClient> client}) : client = client,_repository = UserRepository(client: client.value);

  @override
  AuthState get initialState => AuthUninitialized();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthAuthenticate) {
      yield* _mapAuthenticateEvent(event);
    }
    if (event is AuthLogin) {
      yield* _mapLoginEvent(event);
    }
    if (event is AuthLogout) {
      await AuthProvider().deleteToken();
      client.value.cache.reset();
      yield AuthUninitialized();
    }
    if (event is AuthDeleteAccount) {
      yield* _mapDeleteAccountEvent(event);
    }
  }

  Stream<AuthState> _mapAuthenticateEvent(AuthAuthenticate event) async* {
    final token = await AuthProvider().getToken();
      
    if (token == null) {
      yield AuthLoginRequired();
    } else {
      yield AuthLoading();

      try {
        final me = await _repository.getMeInfo();
        yield AuthAuthenticated(currentUser: me, created: DateTime.now());
      } on GraphqlException catch (err) {
        // TODO: temporal solution to expired token
        if (err != connectionEror) {
          await AuthProvider().deleteToken();
          yield AuthLoginRequired();
        } else {
          yield AuthError(error: err.toString());
        }
      }
    }
  }

  Stream<AuthState> _mapLoginEvent(AuthLogin event) async* {
    String code = event.code;

    yield AuthLoading();
    try {
      final token = await _repository.login(code);
      await AuthProvider().persistToken(token);
      add(AuthAuthenticate());
    } on GraphqlException catch (err) {
      yield AuthError(error: err.toString());
    }
  }

  Stream<AuthState> _mapDeleteAccountEvent(AuthDeleteAccount event) async* {
    try {
      await _repository.deleteAccount();
      await AuthProvider().deleteToken();
      client.value.cache.reset();
      yield AuthAccountDeleted();
    } on GraphqlException catch (err) {
      yield AuthError(error: err.toString());
    }
  }
}
