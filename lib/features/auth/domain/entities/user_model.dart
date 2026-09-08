import 'camera_permission_model.dart';
import 'user_role.dart';

/// Represents a user account (Owner or Manager/Staff).
class UserModel {
  final String id;
  final String name;
  final String emailOrPhone;
  final String avatarUrl;
  final UserRole role;
  final String jobTitle;
  final CameraPermissionModel permissions;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.name,
    required this.emailOrPhone,
    required this.avatarUrl,
    required this.role,
    required this.jobTitle,
    required this.permissions,
    this.isActive = true,
  });

  UserModel copyWith({
    String? name,
    String? emailOrPhone,
    String? avatarUrl,
    UserRole? role,
    String? jobTitle,
    CameraPermissionModel? permissions,
    bool? isActive,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      emailOrPhone: emailOrPhone ?? this.emailOrPhone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      jobTitle: jobTitle ?? this.jobTitle,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
    );
  }
}
