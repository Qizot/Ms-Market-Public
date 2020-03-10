import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ms_market/src/config/config.dart';
import 'package:ms_market/src/models/review.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  final _nameStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  final _descriptionStyle = TextStyle(fontSize: 12);
  final Color _cardBackground = Color(0xff1e212c);

  ReviewCard({this.review});

  @override
  Widget build(BuildContext context) {
    if (review == null) return Container();
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.3, 0.5, 0.7, 0.9],
          colors: [
            Color(0xff16181f),
            Color(0xff1c2030),
            Color(0xff262e4d),
            Color(0xff313d6e),
          ],
        ),
        color: _cardBackground,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(5, 5)
          )
        ]
      ),
      child: _body()
    );
  }

  _body() {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 100,
               width: 100,
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: AppConfig.instance.itemImageUrl + "/${review.item.id}",
                placeholder: (context, url) => Image.asset('assets/image_placeholder.png'),
                errorWidget: (context, url, error) => Image.asset('assets/image_placeholder.png'),
              ),
            ),
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _name(),
              SizedBox(height: 10),
              Text(review.rating.description, style: _descriptionStyle),
            ],
          ),
        )
      ],
    );
  }

  _name() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(review.item.name, style: _nameStyle),
        SizedBox(height: 5),
        _rating()
      ],
    );
  }

  _rating() {
    return RatingBarIndicator(
      rating: review?.rating?.value?.index?.toDouble() ?? 0 + 1.0,
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
