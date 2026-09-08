import 'package:flutter_test/flutter_test.dart';
import 'package:monitoring_application/features/auth/domain/entities/camera_permission_model.dart';
import 'package:monitoring_application/features/auth/domain/entities/user_role.dart';
import 'package:monitoring_application/features/auth/presentation/controllers/user_management_provider.dart';

void main() {
  group('UserManagementProvider Unit Tests (RBAC & Clean Code Craftsmanship)', () {
    late UserManagementProvider provider;

    setUp(() {
      // Arrange: Initialize clean provider instance before each test
      provider = UserManagementProvider();
    });

    test('Initial user session should default to Owner with full access', () {
      // Assert
      expect(provider.isOwner, isTrue);
      expect(provider.currentUser.role, equals(UserRole.owner));
      expect(provider.currentUser.permissions.canLiveView, isTrue);
      expect(provider.currentUser.permissions.canManageSettings, isTrue);
      expect(provider.teamMembers, isNotEmpty);
    });

    test('Switching profile to Manager should restrict Owner privileges', () {
      // Arrange
      final warehouseManager = provider.teamMembers.firstWhere(
        (m) => m.role == UserRole.manager,
      );

      // Act
      provider.switchUser(warehouseManager);

      // Assert
      expect(provider.isOwner, isFalse);
      expect(provider.currentUser.id, equals(warehouseManager.id));
      expect(provider.currentUser.role, equals(UserRole.manager));
      expect(provider.currentUser.permissions.canManageSettings, isFalse);
    });

    test('Owner inviting new team member should add member with granted permissions', () {
      // Arrange
      const newMemberName = 'خالد العمري';
      const newMemberTitle = 'مدير فرع جدة';
      const contact = 'khaled@store.com';
      final initialCount = provider.teamMembers.length;

      // Act
      provider.inviteTeamMember(
        name: newMemberName,
        emailOrPhone: contact,
        jobTitle: newMemberTitle,
        allowedBranchIds: ['BR-STORE-01'],
        permissions: const CameraPermissionModel(
          canLiveView: true,
          canPlayback: false,
          canPtzControl: true,
          canReceiveAlerts: true,
        ),
      );

      // Assert
      expect(provider.teamMembers.length, equals(initialCount + 1));
      final addedMember = provider.teamMembers.last;
      expect(addedMember.name, equals(newMemberName));
      expect(addedMember.jobTitle, equals(newMemberTitle));
      expect(addedMember.permissions.canLiveView, isTrue);
      expect(addedMember.permissions.canPlayback, isFalse);
      expect(addedMember.permissions.canPtzControl, isTrue);
    });

    test('Owner updating team member permissions should immutably update model', () {
      // Arrange
      final targetMember = provider.teamMembers.first;
      const updatedPermissions = CameraPermissionModel(
        canLiveView: true,
        canPlayback: true,
        canPtzControl: true,
        canReceiveAlerts: false,
      );

      // Act
      provider.updateMemberPermissions(targetMember.id, updatedPermissions);

      // Assert
      final updatedMember = provider.teamMembers.firstWhere((m) => m.id == targetMember.id);
      expect(updatedMember.permissions.canPtzControl, isTrue);
      expect(updatedMember.permissions.canReceiveAlerts, isFalse);
    });

    test('Toggling member status should toggle active flag', () {
      // Arrange
      final targetMember = provider.teamMembers.first;
      final initialActive = targetMember.isActive;

      // Act
      provider.toggleMemberStatus(targetMember.id);

      // Assert
      final updatedMember = provider.teamMembers.firstWhere((m) => m.id == targetMember.id);
      expect(updatedMember.isActive, equals(!initialActive));
    });
  });
}
