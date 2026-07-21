import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:monitoring_application/main.dart';
import 'package:monitoring_application/state/aegis_provider.dart';

void main() {
  testWidgets('AegisCommandApp smoke test', (WidgetTester tester) async {
    // Build our app wrapped with AegisProvider and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AegisProvider(),
        child: const AegisCommandApp(),
      ),
    );

    // Verify that executive brand title is displayed.
    expect(find.text('AEGIS COMMAND'), findsOneWidget);
  });
}
