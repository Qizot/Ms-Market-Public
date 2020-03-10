import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ms_market/src/bloc/item_bloc/bloc.dart';
import 'package:ms_market/src/models/item/item.dart';
import 'package:ms_market/src/resources/services/graphql_client.dart';
import 'package:ms_market/src/ui/common/item_card.dart';
import 'package:ms_market/src/ui/common/no_results_placeholder.dart';
import 'package:ms_market/src/ui/common/snack_bar.dart';
import 'package:ms_market/src/ui/owner_items/create_item_floating_button.dart';
import 'package:ms_market/src/ui/owner_items/item_page.dart';

class OwnerItemsPage extends StatefulWidget {
  State<OwnerItemsPage> createState() => _OwnerItemsPageState();
}

class _OwnerItemsPageState extends State<OwnerItemsPage> {
  List<Item> _ownerItems = [];
  List<Item> _filteredItems = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchController = TextEditingController()..addListener(() => _filterItems(_searchController.text));
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _unfocusSearchBar() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemBloc>(
        create: (context) => ItemBloc(client: GraphqlClientService.client)
          ..add(ItemFetchOwnerItems()),
        child: Scaffold(
          backgroundColor: Theme.of(context).accentColor.withAlpha(60),
          appBar: AppBar(
            title: Text('Twoje przedmioty', style: TextStyle(color: Colors.grey[600])),
            centerTitle: true,
          ),
          body: BlocListener<ItemBloc, ItemState>(
            listener: (context, state) {
              if (state is ItemFetchedList) {
                setState(() {
                  _ownerItems = state.items;
                  _ownerItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                });
                _filterItems(_searchController.text);
              }
              if (state is ItemError) {
                showErrorSnackbar(context, state.error);
              }
              if (state is ItemDeleted) {
                showSuccessSnackbar(context, "Pomyślnie usunięto przedmiot");
              }
            },
            child: Builder(builder: (context) => _body(context))
          ),
          floatingActionButton: CreateItemFloatingButton()
      ),
    );
  }

  void _filterItems(String name) {
    name = name.toLowerCase();
    setState(() {
      if (name == "") {
        _filteredItems = _ownerItems;
      } else {
        _filteredItems = _ownerItems.where((Item item) => item.name.toLowerCase().contains(name)).toList();
      }
    });
  }

  Widget _body(context) {
    return GestureDetector(
      onTap: () => _unfocusSearchBar(),
      child: Column(
        children: <Widget>[
          _searchBar(),
          BlocBuilder<ItemBloc, ItemState>(
            bloc: BlocProvider.of<ItemBloc>(context),
            builder: (context, state) {
              if (state is ItemLoading) {
                return Center(child: CircularProgressIndicator());
              }
              return Expanded
              (child: _items(context));

            },
          )
        ],
      ),
    );
  }



  Widget _searchBar() {
    return Container(
      margin: EdgeInsets.all(8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
            hintText: "Wyszukaj przedmiot...",
            suffixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }

  Widget _items(context) {
    if (_filteredItems == null || _filteredItems.isEmpty) {
      return NoResultsPlaceholderRefreshable(
        message: "Brak przedmiotów",
        subMessage: "Jak masz czas, to dodaj nowe, na pewno się przydadzą :)",
        onRefresh: () async {
          BlocProvider.of<ItemBloc>(context).add(ItemFetchOwnerItems(forceRefresh: true));
          return;
        },
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<ItemBloc>(context).add(ItemFetchOwnerItems(forceRefresh: true));
        return;
      },
      child: Scrollbar(
        child: ListView.builder(
          itemCount: _filteredItems.length,
          itemBuilder: (context, idx) =>
              Container(
                margin: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    _unfocusSearchBar();

                    final bloc = BlocProvider.of<ItemBloc>(context);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ItemPage(bloc: bloc, itemId: _filteredItems[idx].id)
                    ));
                  },
                  child: ItemCard(item: _filteredItems[idx])
                )
              ),
        ),
      ),
    );
  }
}
