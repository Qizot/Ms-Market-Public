import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ms_market/src/bloc/search_items_bloc/bloc.dart';
import 'package:ms_market/src/resources/services/dormitories.dart';
import 'package:ms_market/src/utils/colors.dart';

class SearchItemsModal extends StatefulWidget {
  final SearchItemsBloc bloc;

  SearchItemsModal({@required this.bloc});

  State<SearchItemsModal> createState() => _SearchItemsModalState();
}

class _SearchItemsModalState extends State<SearchItemsModal> {
  static const DEFAULT_LIMIT = 50;
  TextEditingController _nameController;
  // TODO: implement limit items field
  TextEditingController _limitController;
  FocusNode _nameFocusNode;
  List<String> _allowedDormitories;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _limitController = TextEditingController();
    _nameFocusNode = FocusNode();
    _allowedDormitories = [];
  }

  void _search(context) {
    // server has a bug where you cannot query with empty string
    if (_nameController.text != "") {
      widget.bloc.add(SearchItemsQuery(
          query: _nameController.text,
          limit: _limitController.text != "" ? int.parse(_limitController.text) : DEFAULT_LIMIT,
          dormitories: _allowedDormitories));
    }
  }

  void _clear() {
    setState(() {
      _nameController.clear();
      _limitController.clear();
      _allowedDormitories.clear();
    });
  }

  final topBarTextStyle = TextStyle(color: Colors.white.withOpacity(0.7));

  Widget build(BuildContext context) {
    return Container(
      color: darkAccentColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _filterHeader(context),
            Divider(),
            _searchField(context),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _pickDormitory(),
                _pickAllDormitories()
              ],
            ),
            Divider(),
            _pickedDormitories(),
          ],
        ),
      ),
    );
  }

  Widget _filterHeader(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          onPressed: _clear,
          child: Text(
            "Wyczyść",
            style: TextStyle(
              color: Colors.red.withOpacity(0.7),
            ),
          ),
        ),
        Text(
          "Wyszukiwanie",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        FlatButton(
          onPressed: () {
            _search(context);
            Navigator.of(context).pop();
          },
          child: Text(
            "Szukaj",
            style: TextStyle(
              color: Colors.amber,
            ),
          ),
        )
      ],
    );
  }

  Widget _searchField(context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom / 2
      ),
      child: TextField(
        focusNode: _nameFocusNode,
        maxLength: 50,
        controller: _nameController,
        decoration: InputDecoration(
            hintText: "Nazwa",
            labelText: "Nazwa",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }

  _unselectDormitory(String name) {
    setState(() {
      _allowedDormitories.remove(name);
    });
  }

  Widget _pickedDormitories() {
    return Container(
      height: 100,
      child: SingleChildScrollView(
        child: Wrap(
          direction: Axis.horizontal,
          children: _allowedDormitories.map((String name) {
            return Container(
              margin: EdgeInsets.only(right: 2),
              child: Chip(
                label: Text(name),
                onDeleted: () {
                  _unselectDormitory(name);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  _loseTextInputFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget _pickAllDormitories() {
    return ActionChip(
      label: Text("Wybierz wszystkie"),
      onPressed: () {
        setState(() {
          _allowedDormitories = DormitoriesService.instance.dormitoryNames;
        });
      },
    );
  }

  Widget _pickDormitory() {
    return PopupMenuButton<String>(
      child: Chip(
        label: Text("Wybierz akademik"),
      ),
      onCanceled: () {
        _loseTextInputFocus();
      },
      onSelected: (String newDormitory) {
        _loseTextInputFocus();
        setState(() {
          _allowedDormitories.add(newDormitory);
        });
      },
      itemBuilder: (BuildContext context) =>
          _getPickableDormitories().map<PopupMenuItem<String>>((String value) {
        return PopupMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }



  List<String> _getPickableDormitories() {
    return DormitoriesService.instance.dormitoryNames
        .toSet()
        .difference(_allowedDormitories.toSet())
        .toList();
  }
}
