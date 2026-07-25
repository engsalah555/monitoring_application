import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Error Boundary widget capturing runtime exception details cleanly without crashing the UI.
class ErrorBoundary extends StatefulWidget {
  final Widget child;

  const ErrorBoundary({super.key, required this.child});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  void initState() {
    super.initState();
  }

  static void _logError(FlutterErrorDetails details) {
    debugPrint('ErrorBoundary caught error: ${details.exceptionAsString()}');
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.bgVoid,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: AppColors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'حدث خطأ غير متوقع في النظام',
                  style: AppTypography.cairoBold(
                      fontSize: 16, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  _error.toString(),
                  textAlign: TextAlign.center,
                  style: AppTypography.monoRegular(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.panelRaised,
                    side: const BorderSide(color: AppColors.panelLine),
                  ),
                  onPressed: () => setState(() => _error = null),
                  child: Text(
                    'إعادة المحاولة',
                    style: AppTypography.cairoBold(
                        fontSize: 12, color: AppColors.cyan),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ErrorWidgetBuilder(
      onError: (details) {
        _logError(details);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _error = details.exception);
          }
        });
      },
      child: widget.child,
    );
  }
}

class ErrorWidgetBuilder extends StatelessWidget {
  final void Function(FlutterErrorDetails details) onError;
  final Widget child;

  const ErrorWidgetBuilder({
    super.key,
    required this.onError,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      onError(details);
      return const SizedBox.shrink();
    };
    return child;
  }
}
