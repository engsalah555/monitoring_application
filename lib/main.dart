import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/error_boundary.dart';
import 'features/shell/presentation/screens/main_shell_screen.dart';
import 'features/surveillance_system/data/repositories/mock_surveillance_repository.dart';
import 'features/surveillance_system/domain/repositories/i_surveillance_repository.dart';
import 'features/surveillance_system/presentation/controllers/aegis_provider.dart';
import 'features/surveillance_system/presentation/controllers/telemetry_notifier.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
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
      child: const ErrorBoundary(
        child: AegisCommandApp(),
      ),
    ),
  );
}

/// Root application widget for AEGIS Command Center.
class AegisCommandApp extends StatelessWidget {
  const AegisCommandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      home: const MainShellScreen(),
    );
  }
}
