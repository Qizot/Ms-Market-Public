


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:meta/meta.dart';
import 'package:ms_market/src/bloc/foreign_item_bloc/bloc.dart';
import 'package:ms_market/src/models/item/rating.dart';
import 'package:ms_market/src/ui/common/mode.dart';
import 'package:ms_market/src/ui/common/snack_bar.dart';

class RateItemPage extends StatefulWidget {
  final ForeignItemBloc bloc;
  final String itemId;
  final Mode mode;
  final Rating rating;

  RateItemPage({@required this.bloc, @required this.itemId, @required this.mode, this.rating}) {
    if (mode == Mode.edit) {
      assert(rating != null);
    }
  }

  State<RateItemPage> createState() => _RateItemPageState();
}

class _RateItemPageState extends State<RateItemPage> {

  int _value;
  TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    if (widget.mode == Mode.edit) {
      _value = widget.rating.value.value();
      _descriptionController = TextEditingController();
      _descriptionController.text = widget.rating.description;
    } else {
      _value = 3;
      _descriptionController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text("Wystawianie opinii", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        brightness: Brightness.dark,
      ),
      backgroundColor: Colors.black,
      body: BlocListener<ForeignItemBloc, ForeignItemState>(
        bloc: widget.bloc,
        listener: (context, state) {
          if (state is ForeignItemRated) {
            Navigator.of(context).pop();
          }
          if (state is ForeignItemError) {
            showErrorSnackbar(context, state.error);
          }
        },
        child: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Center(child: _rating()),
              SizedBox(height: 30),
              _descriptionField(),
              SizedBox(height: 30),
              Center(child: _submitButton())
            ],
          )
        ),
      )
    );
  }

  Widget _rating() {
    return RatingBar(
      initialRating: _value.toDouble(),
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        _value = rating.toInt();
      },
    );
  }

  Widget _descriptionField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        maxLength: 200,
        maxLines: 10,
        controller: _descriptionController,
        validator: (value) {
          if (value.length < 10) {
            return "Opis powinien mieć conajmniej 10 znaków";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Opis",
          labelText: "Opis",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      )
    );
  }

  _onSubmit() {
    if (_formKey.currentState.validate()) {
      if (widget.mode == Mode.create) {
        widget.bloc.add(ForeignItemCreateRating(
          itemId: widget.itemId,
          description: _descriptionController.text,
          value: _value
        ));
      } else {
        widget.bloc.add(ForeignItemUpdateRating(
          ratingId: widget.rating.id,
          description: _descriptionController.text,
          value: _value
        ));
      }
    }
  }

  Widget _submitButton() {
    return FlatButton(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text("Oceń przedmiot", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 30)),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Theme.of(context).primaryColor, width: 2)),
      // color: Theme.of(context).accentColor,
      onPressed: () async {
        _onSubmit();
      },
    );
  }
}