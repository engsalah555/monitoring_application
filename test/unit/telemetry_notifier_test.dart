import 'package:flutter_test/flutter_test.dart';
import 'package:monitoring_application/features/surveillance_system/presentation/controllers/telemetry_notifier.dart';

void main() {
  group('TelemetryNotifier Unit Tests', () {
    late TelemetryNotifier notifier;

    setUp(() {
      notifier = TelemetryNotifier();
    });

    tearDown(() {
      notifier.dispose();
    });

    test('Initial telemetry values are populated correctly', () {
      expect(notifier.pan, equals(124.5));
      expect(notifier.tilt, equals(-12.4));
      expect(notifier.zoom, equals(3.4));
      expect(notifier.playbackSpeed, equals('1x'));
      expect(notifier.isTimelinePlaying, isFalse);
    });

    test('updatePtz clamps zoom between 1.0 and 10.0', () {
      notifier.updatePtz(panDelta: 1.0, tiltDelta: -0.5, zoomDelta: 10.0);
      expect(notifier.zoom, equals(10.0));

      notifier.updatePtz(zoomDelta: -15.0);
      expect(notifier.zoom, equals(1.0));
    });

    test('setTimelinePlayhead clamps position within limits', () {
      notifier.setTimelinePlayhead(150.0);
      expect(notifier.timelinePlayhead, equals(98.0));

      notifier.setTimelinePlayhead(-10.0);
      expect(notifier.timelinePlayhead, equals(2.0));
    });

    test('toggleTimelinePlay toggles playing state', () {
      expect(notifier.isTimelinePlaying, isFalse);
      notifier.toggleTimelinePlay();
      expect(notifier.isTimelinePlaying, isTrue);
    });

    test('setPlaybackSpeed updates speed string', () {
      notifier.setPlaybackSpeed('4x');
      expect(notifier.playbackSpeed, equals('4x'));
    });
  });
}
