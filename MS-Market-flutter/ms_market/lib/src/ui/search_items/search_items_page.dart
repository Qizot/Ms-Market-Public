

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ms_market/src/bloc/search_items_bloc/bloc.dart';
import 'package:ms_market/src/models/dormitory.dart';
import 'package:ms_market/src/models/item_search/dormitory_search_result.dart';
import 'package:ms_market/src/resources/services/dormitories.dart';
import 'package:ms_market/src/resources/services/graphql_client.dart';
import 'package:ms_market/src/ui/common/snack_bar.dart';
import 'package:ms_market/src/ui/search_items/dormitories_map.dart';
import 'package:ms_market/src/ui/search_items/dormitory_card.dart';
import 'package:ms_market/src/ui/search_items/items_list_preview.dart';
import 'package:ms_market/src/ui/search_items/search_items_modal.dart';
import 'package:ms_market/src/utils/colors.dart';
import 'package:rxdart/rxdart.dart';

class SearchItemsPage extends StatefulWidget {

  State<SearchItemsPage> createState() => _SearchItemsPageState();
}

class _SearchItemsPageState extends State<SearchItemsPage> {

  List<DormitorySearchResult> _results;
  PublishSubject<Dormitory> _dormitoryTapped = PublishSubject<Dormitory>();

  @override
  void initState() { 
    super.initState();
    _results = [];  
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchItemsBloc>(
      create: (context) => SearchItemsBloc(client: GraphqlClientService.client),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Wyszukaj przedmioty", style: TextStyle(color: Colors.grey[600])),
          centerTitle: true,
          actions: <Widget>[
            Builder(builder: (context) => _actionButton(context)),
          ],
        ),
        body: BlocListener<SearchItemsBloc, SearchItemsState>(
          listener: (context, state) {
            if (state is SearchItemsResult) {
              if (state.results.length == 0) {
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Nie znaleziono żadnych przedmiotów", style: TextStyle(color: Colors.white)),
                    backgroundColor: darkAccentColor,
                    duration: Duration(seconds: 2),
                  )
                );
              }
              setState(() {
                _results = state.results;
                _results.sort((a, b) {
                  final aIdx = DormitoriesService.instance.findByName(a.dormitory).index;
                  final bIdx = DormitoriesService.instance.findByName(b.dormitory).index;
                  return aIdx.compareTo(bIdx);
                });
              });
            }
            if (state is SearchItemsError) {
              showErrorSnackbar(context, state.error);
            }
          },
          child: Builder(builder: (context) => _body(context))
        )
      ),
    );
  }

  Widget _actionButton(context1) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () async {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => SearchItemsModal(bloc: BlocProvider.of<SearchItemsBloc>(context1))
        );
      }
    );
  }


  Widget _body(BuildContext context) {


    return BlocBuilder<SearchItemsBloc, SearchItemsState>(
      builder: (context, state) =>
      Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DormitoriesMap(moveTo: _dormitoryTapped.stream),
          Positioned(
            bottom: 0,
            child: _dormitoriesCards(context)
          ),
          Align(
            alignment: Alignment.center,
            child: state is SearchItemsLoading ? CircularProgressIndicator() : Container()
          ),
        ],
      )
    );
  }

  Widget _dormitoriesCards(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _results.length,
        itemBuilder: (context, idx) {
          return GestureDetector(
            onDoubleTap: () {
              _dormitoryTapped.add(DormitoriesService.instance.findByName(_results[idx].dormitory));
            },
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ItemsListPreview(result: _results[idx])
              ));
            },
            child: Tooltip(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(12)
              ),
              verticalOffset: 50,
              textStyle: TextStyle(color: Colors.white),
              message: "Stuknij 2 razy by znaleźć na mapie",
              child: DormitoryCard(result: _results[idx])
            )
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _dormitoryTapped.close();
    super.dispose();
  }
}