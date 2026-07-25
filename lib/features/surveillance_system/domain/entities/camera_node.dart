import 'camera_status.dart';

/// Immutable domain entity representing a camera node.
class CameraNode {
  final String id;
  final String name;
  final String resolution;
  final CameraStatus status;
  final String location;
  final bool isFavorite;

  const CameraNode({
    required this.id,
    required this.name,
    required this.resolution,
    required this.status,
    required this.location,
    this.isFavorite = false,
  });

  CameraNode copyWith({
    String? id,
    String? name,
    String? resolution,
    CameraStatus? status,
    String? location,
    bool? isFavorite,
  }) {
    return CameraNode(
      id: id ?? this.id,
      name: name ?? this.name,
      resolution: resolution ?? this.resolution,
      status: status ?? this.status,
      location: location ?? this.location,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
