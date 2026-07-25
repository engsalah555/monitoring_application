/// Immutable domain entity representing asset category distribution.
class AssetCategory {
  final String title;
  final String subtitle;
  final int branchesCount;
  final int camerasCount;

  const AssetCategory({
    required this.title,
    required this.subtitle,
    required this.branchesCount,
    required this.camerasCount,
  });
}
