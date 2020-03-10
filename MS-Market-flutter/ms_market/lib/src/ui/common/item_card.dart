
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ms_market/src/config/config.dart';
import 'package:ms_market/src/models/item/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final Offset _imageSize = Offset(75, 75);
  final Color _cardBackground = Color(0xff1e212c);

  final _nameStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  // final _descriptionStyle = TextStyle(fontSize: 12);

  ItemCard({this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(5, 5)
          ),
          BoxShadow(
            color: Colors.black,
            offset: Offset(-3, 5)
          )
        ]
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        _image(),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            child: _info(),
          ), 
          flex: 8
        )
      ]),
    );
  }

  Widget _imagePlaceholder() {
    return Image.asset('assets/image_placeholder.png', 
      height: _imageSize.dy, 
      width: _imageSize.dx,
      fit: BoxFit.contain,
    );
  }

  Widget _image() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        height: _imageSize.dy,
        width: _imageSize.dx,
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          imageUrl: AppConfig.instance.itemImageUrl + "/${item.id}",
          placeholder: (context, url) => _imagePlaceholder(),
          errorWidget: (context, url, error) => _imagePlaceholder(),
        ),
      ),
    );
  }

  _info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.name, style: _nameStyle),
        Divider(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Kategoria: ", 
                style: TextStyle(fontWeight: FontWeight.w600)
              ),
              TextSpan(
                text: item.itemCategory.readableItemCategory()
              )
            ]
          )
        ),
        SizedBox(height: 5),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Cel: ", 
                style: TextStyle(fontWeight: FontWeight.w600)
              ),
              TextSpan(
                text: item.contractCategory.readableContractCategory()
              )
            ]
          )
        )
      ]
    );
  }
}
