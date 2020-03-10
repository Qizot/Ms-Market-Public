

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class NoResultsPlaceholder extends StatelessWidget {
  final String message;
  final String subMessage;

  NoResultsPlaceholder({@required this.message, this.subMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(message, style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            _subMessage()
          ],
        )
      ),
    );
  }

  Widget _subMessage() {
    if (subMessage == null || subMessage == "") return Container();
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(subMessage, style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 18, fontWeight: FontWeight.w500), textAlign: TextAlign.center,)
    );
  }
}

class NoResultsPlaceholderRefreshable extends StatelessWidget {
  final String message;
  final String subMessage;
  final Future<void> Function() onRefresh;

  NoResultsPlaceholderRefreshable({@required this.message, this.subMessage, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (onRefresh != null) {
          await this.onRefresh();
        }
        return;
      },
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   NoResultsPlaceholder(message: message, subMessage: subMessage)
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }
}