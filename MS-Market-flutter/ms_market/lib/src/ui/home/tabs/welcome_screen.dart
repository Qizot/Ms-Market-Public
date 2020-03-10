import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ms_market/src/bloc/auth_bloc/bloc.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.currentUser;
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Witaj ${user.name} ${user.surname}!', textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  Text('Długo cie z nami nie było, czy powinniśmy pisać na ${user.email}?', textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  Text('Teraz mieszkasz w ${user.dormitory} in room ${user.room}, how do I know?', textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }
        return Container();
      }
    );
  }
}