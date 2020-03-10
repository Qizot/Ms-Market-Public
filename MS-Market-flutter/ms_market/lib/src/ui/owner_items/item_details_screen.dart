
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:ms_market/src/config/config.dart';
import 'package:ms_market/src/models/item/item.dart';

class ItemDetailsScreen extends StatelessWidget {
  final Item item;

  final _headerTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  final _normalText = TextStyle(fontSize: 15);

  ItemDetailsScreen({this.item});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ListView(
        children: <Widget>[
          _gradientImage(context),
          SizedBox(height: 30),
          _description(),
        ],
      ),
    );
  }

  Widget _gradientImage(context) {
    return Stack(children: <Widget>[
      CachedNetworkImage(
        height: 400.0,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
        imageUrl: AppConfig.instance.itemImageUrl + "/${item.id}",
        placeholder: (context, url) => Image.asset('assets/image_placeholder.png'),
        errorWidget: (context, url, error) => Image.asset('assets/image_placeholder.png'),
      ),
      Container(
        height: 400.0,
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.black12,
                  Colors.black,
                ],
                stops: [
                  0.0,
                  1.0
                ])),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          margin: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width - 40, // minus margin
          child: Text(item.name, style: _headerTextStyle)
        ),
      )
    ]);
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _itemSummaryRating(),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Text("Dodano:", style: _headerTextStyle, textAlign: TextAlign.left),
              SizedBox(width: 10),
              Text(DateFormat.yMMMMd("pl_PL").format(item.createdAt), style: _normalText)
            ],
          ),
          SizedBox(height: 10),
          Text("Opis:", style: _headerTextStyle, textAlign: TextAlign.left),
          SizedBox(height: 10),
          Text(item.description, style: _normalText, textAlign: TextAlign.justify),
          SizedBox(height: 10),
          Text("Kategoria:", style: _headerTextStyle, textAlign: TextAlign.left),
          SizedBox(height: 10),
          Text(item.itemCategory?.readableItemCategory()),
          SizedBox(height: 10),
          Text("Cel:", style: _headerTextStyle, textAlign: TextAlign.left),
          SizedBox(height: 10),
          Text(item.contractCategory?.readableContractCategory())
        ],
      ),
    );
  }

  Widget _itemSummaryRating() {
    return RatingBarIndicator(
      rating: item.summary.average,
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