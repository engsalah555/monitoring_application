import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monitoring_application/features/auth/presentation/controllers/user_management_provider.dart';
import 'package:monitoring_application/features/settings/presentation/screens/team_management_screen.dart';
import 'package:monitoring_application/features/surveillance_system/data/repositories/mock_surveillance_repository.dart';
import 'package:monitoring_application/features/surveillance_system/domain/repositories/i_surveillance_repository.dart';
import 'package:monitoring_application/features/surveillance_system/presentation/controllers/aegis_provider.dart';
import 'package:provider/provider.dart';

Widget createTestableWidget(Widget child) {
  return MultiProvider(
    providers: [
      Provider<ISurveillanceRepository>(
        create: (_) => const MockSurveillanceRepository(),
      ),
      ChangeNotifierProvider<AegisProvider>(
        create: (context) => AegisProvider(
          repository: context.read<ISurveillanceRepository>(),
        ),
      ),
      ChangeNotifierProvider<UserManagementProvider>(
        create: (_) => UserManagementProvider(),
      ),
    ],
    child: MaterialApp(
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    ),
  );
}

void main() {
  group('TeamManagementScreen Widget & Interaction Tests', () {
    testWidgets('Renders screen title and Owner active user banner correctly', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestableWidget(const TeamManagementScreen()));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('إدارة الفريق والصلاحيات (RBAC)'), findsOneWidget);
      expect(find.text('سلمان العتيبي'), findsOneWidget);
      expect(find.text('المالك / المدير التنفيذي'), findsOneWidget);
      expect(find.text('أعضاء الفريق والمدراء الفرعيون'), findsOneWidget);
    });

    testWidgets('Tapping "إضافة مدير جديد" opens invite dialog', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestableWidget(const TeamManagementScreen()));
      await tester.pumpAndSettle();

      // Act
      final addButton = find.text('إضافة مدير جديد');
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('إضافة مدير / عضو جديد'), findsOneWidget);
      expect(find.text('اسم الموظف / المدير'), findsOneWidget);
      expect(find.text('إضافة وتعيين الصلاحيات'), findsOneWidget);
    });
  });
}
