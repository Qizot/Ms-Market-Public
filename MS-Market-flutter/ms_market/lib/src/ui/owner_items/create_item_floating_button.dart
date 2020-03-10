

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ms_market/src/bloc/item_bloc/item_bloc.dart';
import 'package:ms_market/src/ui/common/mode.dart';
import 'package:ms_market/src/ui/owner_items/add_edit_item.dart';

class CreateItemFloatingButton extends StatelessWidget {

  static const _fabDimension = 56.0;

  @override
  Widget build(BuildContext context1) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return AddEditItem(
          itemBloc: BlocProvider.of<ItemBloc>(context1),
          mode: Mode.create
        );
      },
      closedElevation: 6.0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(_fabDimension / 2),
        ),
      ),
      closedColor: Theme.of(context1).colorScheme.secondary,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return SizedBox(
          height: _fabDimension,
          width: _fabDimension,
          child: Center(
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        );
      },
    );
  }
}