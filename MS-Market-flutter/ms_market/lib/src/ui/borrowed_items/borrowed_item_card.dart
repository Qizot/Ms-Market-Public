

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:ms_market/src/config/config.dart';
import 'package:ms_market/src/models/borrow_request.dart';
import 'package:ms_market/src/ui/incoming_borrow_requests/helpers.dart';

class BorrowedItemCard extends StatelessWidget {
  final BorrowRequest borrowRequest;
  final Offset _imageSize = Offset(75, 75);
  final Color _cardBackground = Color(0xff1e212c);

  BorrowedItemCard({@required this.borrowRequest});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: _cardBackground,
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
      child: Row(
        children: <Widget>[
          _image(),
          _info()
        ],
      )
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
          imageUrl: AppConfig.instance.itemImageUrl + "/${borrowRequest.item.id}",
          placeholder: (context, url) => _imagePlaceholder(),
          errorWidget: (context, url, error) => _imagePlaceholder(),
        ),
      ),
    );
  }

  Widget _info() {
    return Expanded(
        child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(borrowRequest.item.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
            Divider(height: 5),
            _status(),
            SizedBox(height: 5),
            _statusChange(),
            SizedBox(height: 5),
            _dormitory(),
          ],
        ),
      ),
    );
  }

  Widget _status() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "Status:  ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          TextSpan(text: "${borrowRequest.status.readable()}", style: TextStyle(color: getBorrowStatusColor(borrowRequest.status))),
        ]
      )
    );
  }

  Widget _dormitory() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "Skąd:  ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          TextSpan(text: "${borrowRequest.item.owner.dormitory} ${borrowRequest.item.owner.room}", style: TextStyle(color: Colors.white.withOpacity(0.2))),
        ]
      )
    );
  }

  Widget _statusChange() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "Ostatnia zmiana:  ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          TextSpan(text: "${DateFormat.yMMMMd("pl_PL").format(borrowRequest.updatedStatusAt)}", style: TextStyle(color: Colors.white.withOpacity(0.2))),
        ]
      )
    );
  }
}