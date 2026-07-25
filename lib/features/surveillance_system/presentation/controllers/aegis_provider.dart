import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/app_tab.dart';
import '../../domain/entities/asset_category.dart';
import '../../domain/entities/branch.dart';
import '../../domain/entities/camera_node.dart';
import '../../domain/entities/nvr_device.dart';
import '../../domain/repositories/i_surveillance_repository.dart';

/// Central macro state controller for AEGIS Command Center.
class AegisProvider extends ChangeNotifier {
  final ISurveillanceRepository _repository;

  bool _isEmergency = false;
  AppTab _selectedTab = AppTab.command;
  int _gridCount = 4;

  List<CameraNode> _favoriteCameras = const [];
  List<CameraNode> _zoneCameras = const [];
  List<AssetCategory> _assetCategories = const [];
  List<Branch> _branches = const [];
  bool _isLoading = false;

  // ── Getters ──────────────────────────────────────────────────────────────
  bool get isEmergency => _isEmergency;
  AppTab get selectedTab => _selectedTab;
  int get selectedTabIndex => _selectedTab.index;
  int get gridCount => _gridCount;
  bool get isLoading => _isLoading;

  List<CameraNode> get favoriteCameras => _favoriteCameras;
  List<CameraNode> get zoneCameras => _zoneCameras;
  List<AssetCategory> get assetCategories => _assetCategories;
  List<Branch> get branches => _branches;

  int get alertCount => _isEmergency ? 14 : 2;

  String get systemStatusText => _isEmergency
      ? AppStrings.systemStatusEmergency
      : AppStrings.systemStatusNormal;

  // ── Constructor with DI ───────────────────────────────────────────────────
  AegisProvider({required ISurveillanceRepository repository})
      : _repository = repository {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _favoriteCameras = await _repository.getFavoriteCameras();
      _zoneCameras = await _repository.getZoneCameras('ZONE-B');
      _assetCategories = await _repository.getAssetCategories();
      _branches = await _repository.getBranches();
    } catch (e) {
      debugPrint('Failed to load surveillance data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Mutators ──────────────────────────────────────────────────────────────

  void toggleEmergencyMode() {
    _isEmergency = !_isEmergency;
    notifyListeners();
  }

  void setSelectedTab(AppTab tab) {
    if (_selectedTab != tab) {
      _selectedTab = tab;
      notifyListeners();
    }
  }

  void setSelectedTabIndex(int index) {
    if (index >= 0 && index < AppTab.values.length) {
      final newTab = AppTab.values[index];
      if (_selectedTab != newTab) {
        _selectedTab = newTab;
        notifyListeners();
      }
    }
  }

  void setGridCount(int count) {
    if (_gridCount != count) {
      _gridCount = count;
      notifyListeners();
    }
  }

  Future<bool> addBranch(Branch branch) async {
    try {
      await _repository.addBranch(branch);
      _branches = await _repository.getBranches();
      _assetCategories = await _repository.getAssetCategories();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Failed to add branch: $e');
      return false;
    }
  }

  Future<bool> testNvrConnection(NvrDevice nvr) async {
    return await _repository.testNvrConnection(nvr);
  }
}
