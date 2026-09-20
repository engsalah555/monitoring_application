import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/feedback/cctv_state_view.dart';
import '../../../../core/widgets/inputs/executive_text_field.dart';
import '../../../../core/widgets/royal/royal_button.dart';
import '../../../auth/domain/entities/camera_permission_model.dart';
import '../../../auth/domain/entities/user_model.dart';
import '../../../auth/domain/entities/user_role.dart';
import '../../../auth/presentation/controllers/user_management_provider.dart';

/// Screen for Managing Team Members & Granular Camera Permissions (RBAC) in Matte Obsidian theme.
class TeamManagementScreen extends StatelessWidget {
  const TeamManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserManagementProvider>();
    final isOwner = userProvider.isOwner;

    return Scaffold(
      backgroundColor: AppPalette.bgDarkObsidian,
      appBar: AppBar(
        title: Text(
          'إدارة الفريق والصلاحيات (RBAC)',
          style: AppTypography.cairoBold(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: AppPalette.bgDarkObsidian,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded, color: AppPalette.cyanLight),
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
                    color: Colors.white,
                  ),
                ),
                if (isOwner)
                  RoyalButton(
                    label: 'إضافة مدير جديد',
                    icon: Icons.person_add_alt_1_rounded,
                    variant: RoyalButtonVariant.primary,
                    height: 38,
                    borderRadius: 12,
                    onPressed: () => _showInviteMemberDialog(context, userProvider),
                  ),
              ],
            ),
            const SizedBox(height: 14),

            // Team Members List
            if (userProvider.teamMembers.isEmpty)
              const CctvStateView(
                type: CctvStateType.empty,
                title: 'لا يوجد أعضاء في الفريق حالياً',
                message: 'يمكنك إضافة مدراء فروع وتخصيص الكاميرات المصرح لهم بمراقبتها.',
              )
            else
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
        color: AppPalette.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isOwner
              ? AppPalette.primary.withValues(alpha: 0.5)
              : AppPalette.borderDark,
        ),
        boxShadow: AppPalette.softCardShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppPalette.primary,
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppPalette.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppPalette.primary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        user.role.displayName,
                        style: AppTypography.cairoBold(
                          fontSize: 10,
                          color: AppPalette.primaryLight,
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
                    color: AppPalette.textLightMuted,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => _showUserSwitchDialog(context, provider),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppPalette.borderDark),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              foregroundColor: AppPalette.cyanLight,
            ),
            child: Text(
              'تبديل الحساب',
              style: AppTypography.cairoBold(
                fontSize: 11,
                color: AppPalette.cyanLight,
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
        color: AppPalette.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.borderDark),
        boxShadow: AppPalette.softCardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppPalette.primary.withValues(alpha: 0.15),
                child: Text(
                  member.name.substring(0, 1),
                  style: AppTypography.cairoBold(fontSize: 14, color: AppPalette.primary),
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
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${member.jobTitle} • ${member.emailOrPhone}',
                      style: AppTypography.cairoRegular(
                        fontSize: 11,
                        color: AppPalette.textLightMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: member.isActive,
                onChanged: isOwner ? (_) => provider.toggleMemberStatus(member.id) : null,
                activeThumbColor: AppPalette.emeraldLive,
                activeTrackColor: AppPalette.emeraldGlow,
              ),
            ],
          ),
          const Divider(height: 24, color: AppPalette.borderDark),

          Text(
            'صلاحيات التحكم بالكاميرات الممنوحة:',
            style: AppTypography.cairoBold(fontSize: 12, color: AppPalette.textLightSecondary),
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
              ? AppPalette.emeraldLive.withValues(alpha: 0.12)
              : AppPalette.surfaceDark,
          border: Border.all(
            color: isAllowed
                ? AppPalette.emeraldLive.withValues(alpha: 0.5)
                : AppPalette.borderDark,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isAllowed ? AppPalette.emeraldLive : AppPalette.textLightMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.cairoBold(
                fontSize: 11,
                color: isAllowed ? AppPalette.emeraldLive : AppPalette.textLightMuted,
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
        backgroundColor: AppPalette.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppPalette.borderDark),
        ),
        title: Text(
          'تبديل المستخدم (اختبار تجربة المستخدم)',
          style: AppTypography.cairoBold(fontSize: 14, color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: allUsers.map((u) {
            final isSelected = u.id == provider.currentUser.id;
            return Material(
              color: Colors.transparent,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isSelected ? AppPalette.primary : AppPalette.surfaceDark,
                  child: Text(
                    u.name.substring(0, 1),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(u.name, style: AppTypography.cairoBold(fontSize: 13, color: Colors.white)),
                subtitle: Text(u.jobTitle, style: AppTypography.cairoRegular(fontSize: 11, color: AppPalette.textLightMuted)),
                trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppPalette.primary) : null,
                onTap: () {
                  provider.switchUser(u);
                  Navigator.pop(ctx);
                },
              ),
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
        backgroundColor: AppPalette.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppPalette.borderDark),
        ),
        title: Text(
          'إضافة مدير / عضو جديد',
          style: AppTypography.cairoBold(fontSize: 14, color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExecutiveTextField(
                controller: nameCtrl,
                label: 'اسم الموظف / المدير',
                hint: 'مثال: محمد السبيعي',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              ExecutiveTextField(
                controller: titleCtrl,
                label: 'المسمى الوظيفي',
                hint: 'مثال: مدير المستودع',
                prefixIcon: Icons.work_outline,
              ),
              const SizedBox(height: 12),
              ExecutiveTextField(
                controller: contactCtrl,
                label: 'البريد الإلكتروني أو الجوال',
                hint: '05xxxxxxxx أو user@company.com',
                prefixIcon: Icons.email_outlined,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('إلغاء', style: AppTypography.cairoRegular(fontSize: 12, color: AppPalette.textLightMuted)),
          ),
          RoyalButton(
            label: 'إضافة وتعيين الصلاحيات',
            variant: RoyalButtonVariant.primary,
            height: 38,
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
                  SnackBar(
                    content: Text('تمت إضافة ${nameCtrl.text} بنجاح وترخيص الصلاحيات له'),
                    backgroundColor: AppPalette.surfaceDark,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
