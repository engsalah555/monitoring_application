/// Granular permissions granted to a user for specific cameras and branches.
class CameraPermissionModel {
  final bool canLiveView;
  final bool canPlayback;
  final bool canPtzControl;
  final bool canReceiveAlerts;
  final bool canManageSettings;
  final List<String> allowedBranchIds;
  final List<String> allowedCameraIds;

  const CameraPermissionModel({
    this.canLiveView = true,
    this.canPlayback = true,
    this.canPtzControl = false,
    this.canReceiveAlerts = true,
    this.canManageSettings = false,
    this.allowedBranchIds = const [],
    this.allowedCameraIds = const [],
  });

  CameraPermissionModel copyWith({
    bool? canLiveView,
    bool? canPlayback,
    bool? canPtzControl,
    bool? canReceiveAlerts,
    bool? canManageSettings,
    List<String>? allowedBranchIds,
    List<String>? allowedCameraIds,
  }) {
    return CameraPermissionModel(
      canLiveView: canLiveView ?? this.canLiveView,
      canPlayback: canPlayback ?? this.canPlayback,
      canPtzControl: canPtzControl ?? this.canPtzControl,
      canReceiveAlerts: canReceiveAlerts ?? this.canReceiveAlerts,
      canManageSettings: canManageSettings ?? this.canManageSettings,
      allowedBranchIds: allowedBranchIds ?? this.allowedBranchIds,
      allowedCameraIds: allowedCameraIds ?? this.allowedCameraIds,
    );
  }

  /// Full access preset for Owners.
  static const CameraPermissionModel fullAccess = CameraPermissionModel(
    canLiveView: true,
    canPlayback: true,
    canPtzControl: true,
    canReceiveAlerts: true,
    canManageSettings: true,
    allowedBranchIds: ['*'],
    allowedCameraIds: ['*'],
  );
}
