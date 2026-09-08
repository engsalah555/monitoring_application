/// Enum representing the authority level of a user in the CCTV system.
enum UserRole {
  /// Owner / CEO: Full unrestricted access to all branches, cameras, and settings.
  owner,

  /// Manager (e.g. Warehouse Manager, Store Manager): Assigned specific branches or cameras.
  manager,

  /// Staff / Security Operator: Restricted view-only or custom access.
  staff,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.owner:
        return 'المالك / المدير التنفيذي';
      case UserRole.manager:
        return 'مدير فرع / قسم';
      case UserRole.staff:
        return 'موظف / أمن';
    }
  }
}
