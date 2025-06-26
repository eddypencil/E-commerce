import 'dart:convert';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:e_commerce/features/map/data/model/model.dart';


abstract class MarkersState {

}

class IsLoadingMarkers extends MarkersState {
  
}

class LoadMarkers extends MarkersState {
  final List<LocationMarker> markersList;

  LoadMarkers({required this.markersList});
 
}


class MarkersCubit extends HydratedCubit<MarkersState> {
  MarkersCubit() : super( LoadMarkers(markersList: []));

  List<LocationMarker> get _markers =>
      state is LoadMarkers ? (state as LoadMarkers).markersList : [];

 
  void addMarker(LatLng point, String title, String description) {
    final newMarker = LocationMarker(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      marker: point,
      description: description,
    );

    final updated = List<LocationMarker>.from(_markers)..add(newMarker);
    emit(LoadMarkers(markersList: updated));
  }


  void removeMarker(String id) {
    final updated = _markers.where((m) => m.id != id).toList();
    emit(LoadMarkers(markersList: updated));
  }


  void clearMarkers() {
    emit( LoadMarkers(markersList: []));
  }

  
  @override
  LoadMarkers? fromJson(Map<String, dynamic> json) {
    try {
      final list = (json['markers'] as List<dynamic>)
          .map((e) => LocationMarker.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return LoadMarkers(markersList: list);
    } catch (_) {
      return LoadMarkers(markersList: []);
    }
  }

  @override
  Map<String, dynamic>? toJson(MarkersState state) {
    if (state is LoadMarkers) {
      return {
        'markers': state.markersList.map((m) => m.toJson()).toList(),
      };
    }
    return null;
  }
}
