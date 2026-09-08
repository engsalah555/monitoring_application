import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:monitoring_application/core/constants/app_strings.dart';
import 'package:monitoring_application/main.dart';
import 'package:monitoring_application/features/surveillance_system/data/repositories/mock_surveillance_repository.dart';
import 'package:monitoring_application/features/surveillance_system/domain/repositories/i_surveillance_repository.dart';
import 'package:monitoring_application/features/surveillance_system/presentation/controllers/aegis_provider.dart';
import 'package:monitoring_application/features/surveillance_system/presentation/controllers/telemetry_notifier.dart';

void main() {
  testWidgets('AegisCommandApp initializes and renders brand title', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ISurveillanceRepository>(
            create: (_) => const MockSurveillanceRepository(),
          ),
          ChangeNotifierProvider<AegisProvider>(
            create: (context) => AegisProvider(
              repository: context.read<ISurveillanceRepository>(),
            ),
          ),
          ChangeNotifierProvider<TelemetryNotifier>(
            create: (_) => TelemetryNotifier(),
          ),
        ],
        child: const AegisCommandApp(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text(AppStrings.brandTitle), findsOneWidget);
    expect(find.text(AppStrings.brandSubtitle), findsOneWidget);
  });
}
