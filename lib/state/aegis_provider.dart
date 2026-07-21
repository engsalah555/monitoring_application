import 'dart:async';
import 'package:flutter/material.dart';
import '../models/camera_model.dart';

/// Central state management for AEGIS Command Center.
class AegisProvider extends ChangeNotifier {
  bool _isEmergency = false;
  bool _isLiveSim = true;
  AppTab _selectedTab = AppTab.command;
  int _gridCount = 4;

  double _pan = 124.5;
  double _tilt = -12.4;
  double _zoom = 3.4;

  bool _isTimelinePlaying = false;
  double _timelinePlayhead = 58.0;
  String _playbackSpeed = '1x';

  late final Timer _simTimer;
  DateTime _now = DateTime.now();

  // ── Getters ──────────────────────────────────────────────────────────────
  bool get isEmergency => _isEmergency;
  bool get isLiveSim => _isLiveSim;
  AppTab get selectedTab => _selectedTab;
  int get selectedTabIndex => _selectedTab.index;
  int get gridCount => _gridCount;

  double get pan => _pan;
  double get tilt => _tilt;
  double get zoom => _zoom;

  bool get isTimelinePlaying => _isTimelinePlaying;
  double get timelinePlayhead => _timelinePlayhead;
  String get playbackSpeed => _playbackSpeed;

  String get timeFormatted {
    final h = _now.hour.toString().padLeft(2, '0');
    final m = _now.minute.toString().padLeft(2, '0');
    final s = _now.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  int get alertCount => _isEmergency ? 14 : 2;

  String get systemStatusText => _isEmergency
      ? 'حالة طوارئ نشطة · تنبيه أمني بمستودع ٣'
      : '٢٤٧ كاميرا متصلة · النظام مستقر';

  // ── Constructor ───────────────────────────────────────────────────────────
  AegisProvider() {
    _simTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _now = DateTime.now();
      if (_isLiveSim) {
        _pan += (0.5 - (_now.millisecond % 100) / 100.0) * 0.4;
        _tilt += (0.5 - (_now.millisecond % 100) / 100.0) * 0.2;
      }
      if (_isTimelinePlaying) {
        _timelinePlayhead = (_timelinePlayhead + 1.2) % 98.0;
        if (_timelinePlayhead < 2) _timelinePlayhead = 2;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _simTimer.cancel();
    super.dispose();
  }

  // ── Mutators ──────────────────────────────────────────────────────────────

  void toggleEmergencyMode() {
    _isEmergency = !_isEmergency;
    notifyListeners();
  }

  void toggleLiveSim() {
    _isLiveSim = !_isLiveSim;
    notifyListeners();
  }

  /// Navigate to a tab using the [AppTab] enum value.
  void setSelectedTab(AppTab tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  /// Navigate to a tab by integer index (for BottomNavigationBar.onTap).
  void setSelectedTabIndex(int index) {
    if (index >= 0 && index < AppTab.values.length) {
      _selectedTab = AppTab.values[index];
      notifyListeners();
    }
  }

  void setGridCount(int count) {
    _gridCount = count;
    notifyListeners();
  }

  void updatePtz({double? panDelta, double? tiltDelta, double? zoomDelta}) {
    if (panDelta != null) _pan += panDelta;
    if (tiltDelta != null) _tilt += tiltDelta;
    if (zoomDelta != null) _zoom = (_zoom + zoomDelta).clamp(1.0, 10.0);
    notifyListeners();
  }

  void toggleTimelinePlay() {
    _isTimelinePlaying = !_isTimelinePlaying;
    notifyListeners();
  }

  void setTimelinePlayhead(double pos) {
    _timelinePlayhead = pos.clamp(2.0, 98.0);
    notifyListeners();
  }

  void adjustTimeline(double delta) {
    _timelinePlayhead = (_timelinePlayhead + delta).clamp(2.0, 98.0);
    notifyListeners();
  }

  void setPlaybackSpeed(String speed) {
    _playbackSpeed = speed;
    notifyListeners();
  }
}
