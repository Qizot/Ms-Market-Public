import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ms_market/src/bloc/auth_bloc/bloc.dart';
import 'package:ms_market/src/ui/common/snack_bar.dart';

class SplashScreen extends StatelessWidget {
  // @override
  // Widget build(BuildContext context) {
  //   return _loadingScreen(context);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthLoginRequired) {
        Navigator.of(context).pushReplacementNamed("/login");
      }
      if (state is AuthAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
      if (state is AuthError) {
        showErrorSnackbar(context, state.error);
      }
    }, child: BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthError) {
          return RefreshIndicator(
            child: ListView(
              children: <Widget>[
                _errorScreen(context, state.error),
              ]
            ),
            onRefresh: () async  {
              BlocProvider.of<AuthBloc>(context).add(AuthAuthenticate());
              return;
            },
          );
        }
        return _loadingScreen(context);
      },
    )
            // child: Builder(builder: (context) => _body(context))
            ));
  }

  Widget _loadingScreen(context) {
    return Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Center(child: CircularProgressIndicator()));
  }

  Widget _errorScreen(context, error) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
              child: Text(error,
                  style: TextStyle(fontSize: 20), textAlign: TextAlign.center)),
        ));
  }
}
