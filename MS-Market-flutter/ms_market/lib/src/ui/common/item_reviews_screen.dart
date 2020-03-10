

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ms_market/src/models/item/rating.dart';

class ItemReviewsScreen extends StatelessWidget {
  final List<Rating> ratings;

  ItemReviewsScreen({this.ratings});


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _body()
    );
  }

  Widget _body() {
    if (ratings.length == 0) {
      return Center(
        child: Text("Brak recenzji", 
          style: TextStyle(
            fontWeight: FontWeight.w600, 
            fontSize: 30
          )
        )
      );
    }
    return ListView.builder(
      itemCount: ratings.length,
      itemBuilder: (context, idx) {
        return _ratingCard(ratings[idx]);
      }
    );
  }

  Widget _ratingCard(Rating rating) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(rating.description),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("${rating.user.name} ${rating.user.surname}", style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(width: 10),
                _ratingStars(rating)
              ],
            )
          )
        ],
      )
    );
  }

  Widget _ratingStars(Rating rating) {
    return RatingBarIndicator(
      rating: rating.value.value().toDouble(),
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 20.0,
      unratedColor: Colors.amber.withAlpha(50),
      direction: Axis.horizontal,
    );
  }
}