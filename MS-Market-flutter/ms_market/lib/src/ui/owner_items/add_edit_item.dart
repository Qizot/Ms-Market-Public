


import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ms_market/src/bloc/item_bloc/bloc.dart';
import 'package:ms_market/src/config/config.dart';
import 'package:ms_market/src/models/item/item.dart';
import 'package:ms_market/src/ui/common/mode.dart';
import 'package:ms_market/src/ui/common/snack_bar.dart';
import 'package:ms_market/src/ui/owner_items/validators.dart';
import 'package:ms_market/src/utils/colors.dart';
import 'package:transparent_image/transparent_image.dart';


class AddEditItem extends StatefulWidget {
  final ItemBloc bloc;
  final Mode mode;
  Item _item;

  AddEditItem({@required ItemBloc itemBloc, @required Mode mode, Item item}): bloc = itemBloc, mode = mode, _item = item {
    if (mode == Mode.edit) {
      assert(item != null);
    }
  }

  State<AddEditItem> createState() => _AddEditItemState();
}

class _AddEditItemState extends State<AddEditItem> {

  final _formKey = GlobalKey<FormState>();
  final Validators validators = Validators();

  File _image;

  Color _placeHolderColor = Colors.white;
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  ItemCategory _itemCategory;
  ContractCategory _contractCategory;

  @override
  void initState() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    if (widget.mode == Mode.edit) {
      _nameController.text = widget._item.name;
      _descriptionController.text = widget._item.description;
      _itemCategory = widget._item.itemCategory;
      _contractCategory = widget._item.contractCategory;
    }
    super.initState();
  }

  _clear() {
    if (widget.mode == Mode.create) {
      setState(() {
        _image = null;
        _placeHolderColor = Colors.white;

        // _nameController.text = "";
        // _descriptionController.text = "";
        _itemCategory = null;
        _contractCategory = null;
        _formKey.currentState.reset();
      });
      _nameController.clear();
      _descriptionController.clear();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mode == Mode.create ? "Tworzenie przedmiotu" : "Edycja przedmiotu", style: TextStyle(color: Colors.grey[600])),
        centerTitle: true,
      ),
      backgroundColor: darkAccentColor,
      body: BlocListener<ItemBloc, ItemState>(
        bloc: widget.bloc,
        listener: (context, state) {
          if (state is ItemLoading) {
            showLoadingSnackbar(context, widget.mode == Mode.create ? "Trwa tworzenie przedmiotu..." : "Trwa edytowanie przedmiotu...");
          }
          if (state is ItemCreated) {
            showSuccessSnackbar(context, "Stworzono przedmiot!");
            _clear();
          }
          if (state is ItemUpdated) {
            Navigator.of(context).pop();
          }
          if (state is ItemError) {
            showErrorSnackbar(context, "Wystąpił błąd, spróbuj ponownie później!");
            print(state.error);
          }
        },
        child: Builder(builder: (context) => _body(context))
      ),
    );
  }


  _createItem() {
    widget.bloc.add(ItemCreate(
      createItem: CreateItem(
        name: _nameController.text,
        description: _descriptionController.text,
        itemCategory: _itemCategory,
        contractCategory: _contractCategory,
      ),
      imageFile: _image
    ));
  }

  _updateItem() {
    widget.bloc.add(ItemUpdate(
      updateItem: UpdateItem(
        id: widget._item.id,
        name: _nameController.text,
        description: _descriptionController.text,
        itemCategory: _itemCategory,
        contractCategory: _contractCategory
      ),
      imageFile: _image
    ));
  }

  _onSubmit() {

    if (widget.mode == Mode.create) {
      if (_formKey.currentState.validate() && _image != null) {
        _createItem();
      } else {
        setState(() {
          _placeHolderColor = Colors.red;
        });
      }
    } else {
      if (_formKey.currentState.validate()) {
        _updateItem();
      }
    }
  }
  
  Widget _body(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: ListView(
        children: <Widget>[
          _getImageText(),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.all(10),
            child: _displayImage(),
          ),
          
          Container(
            padding: EdgeInsets.all(8),
            child: _form(context),
          )


        ],
      ),
    );
  }

  Widget _displayImage() {
    if (widget.mode == Mode.create && _image == null) {
      return _imagePlaceholder();
    }
    return _previewImage();
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 800, maxWidth: 800);

    setState(() {
      _image = image;
    });
  }

  Widget _getImageText() {
    return Container(
      margin: EdgeInsets.all(10),
      alignment: Alignment.center,
      child: Text(_image != null ? "Zdjęcie" : "Dodaj zdjęcie", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600))
    );
  }



  Widget _imagePlaceholder({bool readonly = false}) {
    return GestureDetector(
      onTap: () async {
        if (!readonly) {
          await _getImage();
        }
      },
      child: DottedBorder(
        radius: Radius.circular(30),
        color: _placeHolderColor,
        strokeWidth: 1,
          child: Container(
            height: 250,
            width: 250,
            child: Icon(Icons.add_a_photo, size: 50, color: _placeHolderColor)
          ),
      ),
    );
  }

  Widget _previewImage() {
    return Stack(
      children: <Widget>[
        Container(
          width: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FadeInImage(
              image: _image != null ? FileImage(_image) : NetworkImage(AppConfig.instance.itemImageUrl + '/${widget._item.id}'), 
              placeholder: MemoryImage(kTransparentImage))
          )
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            onPressed: () async  {
              await _getImage();
            },
            icon: Icon(Icons.add_a_photo, size: 32),
          )
        )
      ],
    );
  }

  Widget _form(context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            maxLength: 50,
            controller: _nameController,
            validator: validators.validateItemName,
            decoration: InputDecoration(
              hintText: "Nazwa",
              labelText: "Nazwa",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          ),
          SizedBox(height: 8),
          TextFormField(
            maxLength: 200,
            minLines: 3,
            maxLines: 5,
            controller: _descriptionController,
            validator: validators.validateDescription,
            decoration: InputDecoration(
              hintText: "Opis",
              labelText: "Opis",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))
              )
            ),
          ),
          SizedBox(height: 10),
          _itemCategoryField(),
          SizedBox(height: 10),
          _contractCategoryField(),
          SizedBox(height: 10),
          _submitButton(context)
        ],
      ),
    );
  }

  Widget _itemCategoryField() {
    return FormField(
      initialValue: _itemCategory,
      validator: (value) {
        if (value == null) {
          return "Wybierz z listy";
        }
        return null;
      },
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: const Icon(Icons.assignment),
            labelText: 'Kategoria',
            errorText: state.hasError ? "Wybierz z listy" : null 
          ),
          isEmpty: _itemCategory == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ItemCategory>(
              value: _itemCategory,
              isDense: true,
              onChanged: (ItemCategory newValue) {
                setState(() {
                  _itemCategory = newValue;
                  state.didChange(newValue);
                });
              },
              items: ItemCategory.values.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.readableItemCategory())
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _contractCategoryField() {
     return FormField(
      initialValue: _contractCategory,
      validator: (value) {
        if (value == null) {
          return "Wybierz z listy";
        }
        return null;
      },
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: const Icon(Icons.assignment),
            labelText: 'Co chcesz zrobić?',
            errorText: state.hasError ? "Wybierz z listy" : null 
          ),
          isEmpty: _itemCategory == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ContractCategory>(
              value: _contractCategory,
              isDense: true,
              onChanged: (ContractCategory newValue) {
                setState(() {
                  _contractCategory = newValue;
                  state.didChange(newValue);
                });
              },
              items: ContractCategory.values.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.readableContractCategory())
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }


  Widget _submitButton(context) {
    return FlatButton(
      child: _submitButtonText(context),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Theme.of(context).primaryColor, width: 2)),
      // color: Theme.of(context).accentColor,
      onPressed: () async {
        _onSubmit();
      },
    );
  }

  Widget _submitButtonText(context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(widget.mode == Mode.create ? "Dodaj przedmiot" : "Edytuj przedmiot",
          style:
              TextStyle(fontSize: 18, color: Theme.of(context).primaryColor)),
    );
  }




}