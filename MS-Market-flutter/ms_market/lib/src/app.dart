import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ms_market/src/bloc/auth_bloc/bloc.dart';
import 'package:ms_market/src/resources/services/graphql_client.dart';
import 'package:ms_market/src/ui/borrowed_items/borrowed_items_page.dart';
import 'package:ms_market/src/ui/home/home_screen.dart';
import 'package:ms_market/src/ui/incoming_borrow_requests/borrow_requests_page.dart';
import 'package:ms_market/src/ui/login/login_screen.dart';
import 'package:ms_market/src/ui/owner_items/owner_items_page.dart';
import 'package:ms_market/src/ui/profile/profile_page.dart';
import 'package:ms_market/src/ui/search_items/search_items_page.dart';
import 'package:ms_market/src/ui/splash/splash_screen.dart';
import 'package:ms_market/src/utils/colors.dart';

class App extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  App({Key key, this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(client: GraphqlClientService.client)
        ..add(AuthAuthenticate()),
      child: MaterialApp(
        supportedLocales: [const Locale('pl', 'PL')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: appPrimaryColor,
            primaryColor: appPrimaryColor.shade500,
            accentColor: appAccentColor,
        ),
        routes: {
          "/": (context) => SplashScreen(),
          "/login": (context) => LoginScreen(),
          "/home": (context) => HomeScreen(),
          "/profile": (context) => ProfilePage(),
          "/owner-items": (context) => OwnerItemsPage(),
          "/search-items": (context) => SearchItemsPage(),
          "/borrow-requests": (context) => BorrowRequestsPage(),
          "/borrowed-items": (context) => BorrowedItemsPage(),
        },
        initialRoute: "/",
      ),
    );
  }
}
