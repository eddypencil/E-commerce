import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

class LocationMarker {
  String id;
  String title;
  LatLng marker;
  String description;

  /// Main constructor: if [id] is omitted, generate a new UUID.
  LocationMarker({
    String? id,
    required this.title,
    required this.marker,
    required this.description,
  }) : id = id ?? const Uuid().v4();

  /// Create a LocationMarker from a JSON map.
  factory LocationMarker.fromJson(Map<String, dynamic> json) {
    return LocationMarker(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      marker: LatLng(
        (json['lat'] as num).toDouble(),
        (json['lng'] as num).toDouble(),
      ),
    );
  }

  /// Convert this LocationMarker into a JSON-serializable map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'lat': marker.latitude,
        'lng': marker.longitude,
      };
}
