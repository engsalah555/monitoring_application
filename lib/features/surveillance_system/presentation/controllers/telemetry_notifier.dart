import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/extensions/datetime_x.dart';

/// Fine-grained controller for high-frequency telemetry state (PTZ & clock timer).
class TelemetryNotifier extends ChangeNotifier {
  double _pan = 124.5;
  double _tilt = -12.4;
  double _zoom = 3.4;

  bool _isTimelinePlaying = false;
  double _timelinePlayhead = 58.0;
  String _playbackSpeed = '1x';

  bool _isLiveSim = true;
  late final Timer _simTimer;
  DateTime _now = DateTime.now();

  double get pan => _pan;
  double get tilt => _tilt;
  double get zoom => _zoom;

  bool get isTimelinePlaying => _isTimelinePlaying;
  double get timelinePlayhead => _timelinePlayhead;
  String get playbackSpeed => _playbackSpeed;
  bool get isLiveSim => _isLiveSim;

  String get timeFormatted => _now.toTimeString;
  String get telemetryFormatted =>
      'PAN: ${_pan.toStringAsFixed(1)}° | TILT: ${_tilt.toStringAsFixed(1)}° | ZM: ${_zoom.toStringAsFixed(1)}x';

  TelemetryNotifier() {
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

  void updatePtz({double? panDelta, double? tiltDelta, double? zoomDelta}) {
    if (panDelta != null) _pan += panDelta;
    if (tiltDelta != null) _tilt += tiltDelta;
    if (zoomDelta != null) _zoom = (_zoom + zoomDelta).clamp(1.0, 10.0);
    notifyListeners();
  }

  void toggleLiveSim() {
    _isLiveSim = !_isLiveSim;
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
