import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ms_market/src/bloc/auth_bloc/bloc.dart';
import 'package:ms_market/src/bloc/profile_bloc/bloc.dart';
import 'package:ms_market/src/models/review.dart';
import 'package:ms_market/src/models/user.dart';
import 'package:ms_market/src/resources/services/graphql_client.dart';
import 'package:ms_market/src/ui/common/alert_box.dart';
import 'package:ms_market/src/ui/common/no_results_placeholder.dart';
import 'package:ms_market/src/ui/common/review_card.dart';
import 'package:ms_market/src/ui/profile/profile_card.dart';
import 'package:ms_market/src/utils/colors.dart';

enum ProfileAction { delete }

class ProfilePage extends StatefulWidget {
  State<ProfilePage> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfilePage> {
  User _user;
  List<Review> _reviews = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(client: GraphqlClientService.client)
          ..add(ProfileFetch())
          ..add(ProfileFetchRecentReviews(limit: 10)),
        child: MultiBlocListener(
          listeners: [
            BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileFetched) {
                  setState(() {
                    _user = state.user;
                  });
                }
                if (state is ProfileRecentReviews) {
                  setState(() {
                    _reviews = state.reviews;
                  });
                }
              }
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAccountDeleted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
            )
          ],
          child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    title:
                        Text("Profil", style: TextStyle(color: Colors.grey[600])),
                    centerTitle: true,
                    actions: <Widget>[
                      Builder(builder: (context) => _actionButton(context))
                    ],
                  ),
                  backgroundColor: darkAccentColor,
                  body: Builder(builder: (context) => _body(context))),
        )
      );
  }

  Widget _body(context) {
    return Column(children: <Widget>[
      ProfileCard(user: _user),
      SizedBox(height: 15),
      Text("Ostatnie recenzje twoich przedmiotów", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      SizedBox(height: 5),
      Expanded(
          child: _reviewList(context)
      )
      ]
    );
  }

  _reviewList(context) {
    if (_reviews.isEmpty) {
      return NoResultsPlaceholderRefreshable(
        message: "Brak recenzji",
        onRefresh: () async {
          BlocProvider.of<ProfileBloc>(context).add(ProfileFetchRecentReviews(limit: 10, forceRefresh: true));
          return;
        },
      );
    }
    return 
      Container(
        padding: EdgeInsets.all(5),
        child: RefreshIndicator(
          child: Scrollbar(
            child: ListView.builder(
              itemCount: _reviews.length,
              itemBuilder: (context, idx) => ReviewCard(review: _reviews[idx]),
            ),
          ),
          onRefresh: () async {
            BlocProvider.of<ProfileBloc>(context).add(ProfileFetchRecentReviews(limit: 10, forceRefresh: true));
            return;
          },
        )
      );
  }

  _actionButton(context) {
    return PopupMenuButton<ProfileAction>(
      onSelected: (ProfileAction action) {
        switch (action) {
          case ProfileAction.delete: {
            showAlertDialog(
              context,
              alertText: "Czy na pewno chcesz usunąć swoje konto?",
              descriptionText: "Czynności tej nie da się cofnąć, stracisz wszystkie swoje informacjie o koncie i zarejestrowanych przedmiotach",
              confirmText: "Usuń",
              cancelText: "Anuluj",
              onConfirm: () {
                BlocProvider.of<AuthBloc>(context).add(AuthDeleteAccount());
              }
            );
            break;
          }
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ProfileAction>>[

        const PopupMenuItem<ProfileAction>(
          value: ProfileAction.delete,
          child: ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red),
            title: Text("Usuń konto", style: TextStyle(color: Colors.red)),
          ),
        ),
      ],
    );
  }
}
