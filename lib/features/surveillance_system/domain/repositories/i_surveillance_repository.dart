import '../entities/asset_category.dart';
import '../entities/branch.dart';
import '../entities/camera_node.dart';
import '../entities/nvr_device.dart';

/// Clean repository contract for surveillance data operations.
abstract class ISurveillanceRepository {
  Future<List<CameraNode>> getFavoriteCameras();
  Future<List<CameraNode>> getZoneCameras(String zoneId);
  Future<List<AssetCategory>> getAssetCategories();
  Future<List<Branch>> getBranches();
  Future<void> addBranch(Branch branch);
  Future<bool> testNvrConnection(NvrDevice nvr);
}
