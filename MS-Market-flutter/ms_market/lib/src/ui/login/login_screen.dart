import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ms_market/src/bloc/auth_bloc/bloc.dart';
import 'package:ms_market/src/resources/providers/dsnet_provider.dart';
import 'package:ms_market/src/ui/common/snack_bar.dart';
import 'package:ms_market/src/ui/login/berzier_top.dart';
import 'package:ms_market/src/ui/login/terms_of_use.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
        if (state is AuthError) {
          showErrorSnackbar(context, state.error);
        }
        if (state is AuthLoading) {
          Scaffold.of(context).showSnackBar(_loadingSnackBar(context));
        }
      },
      child: Builder(builder: (context) => _body(context)),
    ));
  }

  Widget _loadingSnackBar(context) {
    return SnackBar(
      content: Row(
        children: <Widget>[
          Text("Trwa logowanie...", style: TextStyle(color: Colors.white)),
          SizedBox(width: 15),
          SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]),
              )),
        ],
      ),
      backgroundColor: Theme.of(context).accentColor,
      duration: Duration(seconds: 60),
    );
  }

  Widget _body(context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        BerzierTop(color: Theme.of(context).primaryColor),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Image(
              height: 200,
              image: AssetImage("assets/logo_transparent_small.png")),
        ),
        Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: <Widget>[
                _loginButton(context),
                SizedBox(height: 20),
                _termsOfUseButton(context),
              ],
            )),
      ],
    );
  }

  Widget _loginButton(context) {
    return FlatButton(
      child: _loginText(context),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Theme.of(context).primaryColor, width: 2)),
      // color: Theme.of(context).accentColor,
      onPressed: () async {
        final code = await DSNetProvider().getAuthorizationCode();
        BlocProvider.of<AuthBloc>(context).add(AuthLogin(code: code));
      },
    );
  }

  Widget _loginText(context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text("Zaloguj się przy pomocy DSNET",
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).primaryColor)),
    );
  }

  Widget _termsOfUseButton(context) {
    return FlatButton(
      child: _termsText(context),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.grey[600], width: 2)),
      // color: Theme.of(context).accentColor,
      onPressed: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TermsOfUse()));
      },
    );
  }

  Widget _termsText(context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text("Regulamin",
          style: TextStyle(fontSize: 18, color: Colors.grey[600])),
    );
  }
}
