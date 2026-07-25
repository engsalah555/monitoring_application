import 'package:flutter_test/flutter_test.dart';
import 'package:monitoring_application/features/surveillance_system/data/repositories/mock_surveillance_repository.dart';
import 'package:monitoring_application/features/surveillance_system/domain/entities/app_tab.dart';
import 'package:monitoring_application/features/surveillance_system/presentation/controllers/aegis_provider.dart';

void main() {
  group('AegisProvider Unit Tests', () {
    late AegisProvider provider;

    setUp(() {
      provider = AegisProvider(repository: const MockSurveillanceRepository());
    });

    test('Initial emergency state is false', () {
      expect(provider.isEmergency, isFalse);
      expect(provider.alertCount, equals(2));
      expect(provider.selectedTab, equals(AppTab.command));
      expect(provider.gridCount, equals(4));
    });

    test('toggleEmergencyMode updates emergency mode and alert count', () {
      provider.toggleEmergencyMode();
      expect(provider.isEmergency, isTrue);
      expect(provider.alertCount, equals(14));

      provider.toggleEmergencyMode();
      expect(provider.isEmergency, isFalse);
      expect(provider.alertCount, equals(2));
    });

    test('setSelectedTab updates current active tab including settings', () {
      provider.setSelectedTab(AppTab.liveSingle);
      expect(provider.selectedTab, equals(AppTab.liveSingle));
      expect(provider.selectedTabIndex, equals(AppTab.liveSingle.index));

      provider.setSelectedTab(AppTab.settings);
      expect(provider.selectedTab, equals(AppTab.settings));
      expect(provider.selectedTabIndex, equals(AppTab.settings.index));
    });

    test('setGridCount updates layout grid count', () {
      provider.setGridCount(8);
      expect(provider.gridCount, equals(8));
    });
  });
}
