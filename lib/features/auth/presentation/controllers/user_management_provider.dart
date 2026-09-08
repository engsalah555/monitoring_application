import 'package:flutter/foundation.dart';
import '../../domain/entities/camera_permission_model.dart';
import '../../domain/entities/user_model.dart';
import '../../domain/entities/user_role.dart';

/// Provider for managing logged-in user session and Team Members (RBAC).
class UserManagementProvider extends ChangeNotifier {
  late UserModel _currentUser;
  final List<UserModel> _teamMembers = [];

  UserManagementProvider() {
    _initMockUsers();
  }

  UserModel get currentUser => _currentUser;
  List<UserModel> get teamMembers => List.unmodifiable(_teamMembers);
  bool get isOwner => _currentUser.role == UserRole.owner;

  void _initMockUsers() {
    _currentUser = const UserModel(
      id: 'USR-OWNER-01',
      name: 'سلمان العتيبي',
      emailOrPhone: 'ceo@company.com',
      avatarUrl: '',
      role: UserRole.owner,
      jobTitle: 'المدير التنفيذي / المالك',
      permissions: CameraPermissionModel.fullAccess,
    );

    _teamMembers.addAll([
      const UserModel(
        id: 'USR-MGR-01',
        name: 'أحمد سعيد',
        emailOrPhone: 'ahmed.wh@company.com',
        avatarUrl: '',
        role: UserRole.manager,
        jobTitle: 'مدير المستودعات والمخازن',
        permissions: CameraPermissionModel(
          canLiveView: true,
          canPlayback: true,
          canPtzControl: false,
          canReceiveAlerts: true,
          canManageSettings: false,
          allowedBranchIds: ['BR-WH-01'],
          allowedCameraIds: ['CAM-14', 'CAM-17'],
        ),
      ),
      const UserModel(
        id: 'USR-MGR-02',
        name: 'سارة خالد',
        emailOrPhone: 'sara.store@company.com',
        avatarUrl: '',
        role: UserRole.manager,
        jobTitle: 'مديرة متجر جدة',
        permissions: CameraPermissionModel(
          canLiveView: true,
          canPlayback: false,
          canPtzControl: true,
          canReceiveAlerts: true,
          canManageSettings: false,
          allowedBranchIds: ['BR-STORE-01'],
          allowedCameraIds: ['CAM-01', 'CAM-08'],
        ),
      ),
    ]);
  }

  /// Switch active user profile (for demo & multi-user testing).
  void switchUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Add a new team member (e.g. inviting a warehouse manager).
  void inviteTeamMember({
    required String name,
    required String emailOrPhone,
    required String jobTitle,
    required List<String> allowedBranchIds,
    required CameraPermissionModel permissions,
  }) {
    final newMember = UserModel(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      emailOrPhone: emailOrPhone,
      avatarUrl: '',
      role: UserRole.manager,
      jobTitle: jobTitle,
      permissions: permissions.copyWith(allowedBranchIds: allowedBranchIds),
    );

    _teamMembers.add(newMember);
    notifyListeners();
  }

  /// Update permissions for an existing member.
  void updateMemberPermissions(String memberId, CameraPermissionModel newPermissions) {
    final index = _teamMembers.indexWhere((m) => m.id == memberId);
    if (index != -1) {
      _teamMembers[index] = _teamMembers[index].copyWith(permissions: newPermissions);
      notifyListeners();
    }
  }

  /// Toggle active state of a team member.
  void toggleMemberStatus(String memberId) {
    final index = _teamMembers.indexWhere((m) => m.id == memberId);
    if (index != -1) {
      final current = _teamMembers[index];
      _teamMembers[index] = current.copyWith(isActive: !current.isActive);
      notifyListeners();
    }
  }
}
