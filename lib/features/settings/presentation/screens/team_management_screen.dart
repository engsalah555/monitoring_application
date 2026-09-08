import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/domain/entities/camera_permission_model.dart';
import '../../../auth/domain/entities/user_model.dart';
import '../../../auth/domain/entities/user_role.dart';
import '../../../auth/presentation/controllers/user_management_provider.dart';

/// Screen for Managing Team Members & Granular Camera Permissions (RBAC).
class TeamManagementScreen extends StatelessWidget {
  const TeamManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserManagementProvider>();
    final isOwner = userProvider.isOwner;

    return Scaffold(
      backgroundColor: AppColors.clayBg,
      appBar: AppBar(
        title: Text(
          'إدارة الفريق والصلاحيات (RBAC)',
          style: AppTypography.cairoBold(fontSize: 16, color: AppColors.textDarkPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded, color: AppColors.primaryBlue),
            tooltip: 'تبديل المستخدم للتجربة',
            onPressed: () => _showUserSwitchDialog(context, userProvider),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current User Banner & Profile Switcher
            _buildActiveUserBanner(context, userProvider),
            const SizedBox(height: 20),

            // Section Header: Team Members List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'أعضاء الفريق والمدراء الفرعيون',
                  style: AppTypography.cairoBold(
                    fontSize: 15,
                    color: AppColors.textDarkPrimary,
                  ),
                ),
                if (isOwner)
                  ElevatedButton.icon(
                    onPressed: () => _showInviteMemberDialog(context, userProvider),
                    icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
                    label: Text(
                      'إضافة مدير جديد',
                      style: AppTypography.cairoBold(fontSize: 12, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Team Members List
            ...userProvider.teamMembers.map(
              (member) => _buildMemberCard(context, member, userProvider, isOwner),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveUserBanner(BuildContext context, UserManagementProvider provider) {
    final user = provider.currentUser;
    final isOwner = provider.isOwner;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOwner ? AppColors.darkIndigo : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primaryBlue,
            child: Text(
              user.name.substring(0, 1),
              style: AppTypography.cairoBold(fontSize: 18, color: Colors.white),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.name,
                      style: AppTypography.cairoBold(
                        fontSize: 15,
                        color: isOwner ? Colors.white : AppColors.textDarkPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isOwner
                            ? AppColors.primaryBlue.withValues(alpha: 0.3)
                            : AppColors.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        user.role.displayName,
                        style: AppTypography.cairoBold(
                          fontSize: 10,
                          color: isOwner ? Colors.white : AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  user.jobTitle,
                  style: AppTypography.cairoRegular(
                    fontSize: 12,
                    color: isOwner ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => _showUserSwitchDialog(context, provider),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isOwner ? Colors.white38 : AppColors.primaryBlue,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'تبديل الحساب',
              style: AppTypography.cairoBold(
                fontSize: 11,
                color: isOwner ? Colors.white : AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    UserModel member,
    UserManagementProvider provider,
    bool isOwner,
  ) {
    final perms = member.permissions;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.15),
                child: Text(
                  member.name.substring(0, 1),
                  style: AppTypography.cairoBold(fontSize: 14, color: AppColors.primaryBlue),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: AppTypography.cairoBold(
                        fontSize: 14,
                        color: AppColors.textDarkPrimary,
                      ),
                    ),
                    Text(
                      '${member.jobTitle} • ${member.emailOrPhone}',
                      style: AppTypography.cairoRegular(
                        fontSize: 11,
                        color: AppColors.textDarkSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: member.isActive,
                onChanged: isOwner ? (_) => provider.toggleMemberStatus(member.id) : null,
                activeThumbColor: AppColors.green,
              ),
            ],
          ),
          const Divider(height: 24),

          Text(
            'صلاحيات التحكم بالكاميرات الممنوحة:',
            style: AppTypography.cairoBold(fontSize: 12, color: AppColors.textDarkSecondary),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _permissionChip(
                label: 'البث المباشر',
                icon: Icons.videocam_rounded,
                isAllowed: perms.canLiveView,
                onToggle: isOwner
                    ? (val) => provider.updateMemberPermissions(
                        member.id, perms.copyWith(canLiveView: val))
                    : null,
              ),
              _permissionChip(
                label: 'التسجيلات',
                icon: Icons.history_rounded,
                isAllowed: perms.canPlayback,
                onToggle: isOwner
                    ? (val) => provider.updateMemberPermissions(
                        member.id, perms.copyWith(canPlayback: val))
                    : null,
              ),
              _permissionChip(
                label: 'التحكم بالتحريك PTZ',
                icon: Icons.open_with_rounded,
                isAllowed: perms.canPtzControl,
                onToggle: isOwner
                    ? (val) => provider.updateMemberPermissions(
                        member.id, perms.copyWith(canPtzControl: val))
                    : null,
              ),
              _permissionChip(
                label: 'التنبيهات',
                icon: Icons.notifications_active_rounded,
                isAllowed: perms.canReceiveAlerts,
                onToggle: isOwner
                    ? (val) => provider.updateMemberPermissions(
                        member.id, perms.copyWith(canReceiveAlerts: val))
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _permissionChip({
    required String label,
    required IconData icon,
    required bool isAllowed,
    required ValueChanged<bool>? onToggle,
  }) {
    return InkWell(
      onTap: onToggle != null ? () => onToggle(!isAllowed) : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isAllowed
              ? AppColors.green.withValues(alpha: 0.12)
              : Colors.grey.shade100,
          border: Border.all(
            color: isAllowed ? AppColors.green : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isAllowed ? AppColors.green : Colors.grey.shade500,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.cairoBold(
                fontSize: 11,
                color: isAllowed ? AppColors.green : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserSwitchDialog(BuildContext context, UserManagementProvider provider) {
    final allUsers = [
      provider.currentUser,
      ...provider.teamMembers,
    ].fold<List<UserModel>>([], (list, user) {
      if (!list.any((u) => u.id == user.id)) list.add(user);
      return list;
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'تبديل المستخدم (اختبار تجربة المستخدم)',
          style: AppTypography.cairoBold(fontSize: 14, color: AppColors.textDarkPrimary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: allUsers.map((u) {
            final isSelected = u.id == provider.currentUser.id;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
                child: Text(
                  u.name.substring(0, 1),
                  style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                ),
              ),
              title: Text(u.name, style: AppTypography.cairoBold(fontSize: 13, color: AppColors.textDarkPrimary)),
              subtitle: Text(u.jobTitle, style: AppTypography.cairoRegular(fontSize: 11, color: AppColors.textDarkSecondary)),
              trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryBlue) : null,
              onTap: () {
                provider.switchUser(u);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showInviteMemberDialog(BuildContext context, UserManagementProvider provider) {
    final nameCtrl = TextEditingController();
    final titleCtrl = TextEditingController(text: 'مدير المستودعات والمخازن');
    final contactCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'إضافة مدير / عضو جديد',
          style: AppTypography.cairoBold(fontSize: 14, color: AppColors.textDarkPrimary),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'اسم الموظف / المدير',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'المسمى الوظيفي (مثل: مدير المستودع)',
                  prefixIcon: Icon(Icons.work),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contactCtrl,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني أو الجوال',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                provider.inviteTeamMember(
                  name: nameCtrl.text,
                  emailOrPhone: contactCtrl.text.isEmpty ? 'manager@company.com' : contactCtrl.text,
                  jobTitle: titleCtrl.text,
                  allowedBranchIds: ['BR-WH-01'],
                  permissions: const CameraPermissionModel(
                    canLiveView: true,
                    canPlayback: true,
                    canPtzControl: false,
                    canReceiveAlerts: true,
                  ),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تمت إضافة ${nameCtrl.text} بنجاح وترخيص الصلاحيات له')),
                );
              }
            },
            child: const Text('إضافة وتعيين الصلاحيات'),
          ),
        ],
      ),
    );
  }
}
