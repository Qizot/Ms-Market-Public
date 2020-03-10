

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ms_market/src/bloc/search_items_bloc/bloc.dart';
import 'package:ms_market/src/models/dormitory.dart';
import 'package:ms_market/src/resources/services/dormitories.dart';


class DormitoriesMap extends StatefulWidget {
  final Stream<Dormitory> moveTo;
  
  DormitoriesMap({this.moveTo});

  State<DormitoriesMap> createState() => _DormitoriesMapState();
}

class _DormitoriesMapState extends State<DormitoriesMap> {
  GoogleMapController _controller;
  List<Dormitory> _dormitories = [];
  StreamSubscription<Dormitory> _movingCamera;

  static final CameraPosition _studentTown = CameraPosition(
    target: LatLng(50.068603, 19.906055),
    zoom: 16,
  );

  @override
  void initState() { 
    _movingCamera = widget.moveTo.listen((dormitory) {
      _controller?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(dormitory.latitude, dormitory.longitude),
            zoom: 17.5,
          )
        )
      );
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchItemsBloc, SearchItemsState>(
      listener: (context, state) {
        if (state is SearchItemsResult) {
          setState(() {
            _dormitories = state.results.map((v) => DormitoriesService.instance.findByName(v.dormitory)).toList();
          });
        }
      },
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _studentTown,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: _createMarkers()
      )
    );
  }

  Set<Marker> _createMarkers() {
    return _dormitories.map((dormitory) {
      return Marker(
        markerId: MarkerId(dormitory.fullname),
        position: LatLng(dormitory.latitude, dormitory.longitude),
      );
    }).toSet();
  }

  @override
  void dispose() {
    _movingCamera.cancel();
    super.dispose();
  }
}