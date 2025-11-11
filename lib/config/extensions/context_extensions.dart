import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // MediaQuery shortcuts
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomSafeArea => MediaQuery.of(this).padding.bottom;

  // Navigation shortcuts
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  void popUntil(bool Function(Route<dynamic>) predicate) => Navigator.of(this).popUntil(predicate);

  Future<T?> push<T>(Widget page) => Navigator.of(this).push<T>(
        MaterialPageRoute(builder: (context) => page),
      );

  Future<T?> pushReplacement<T>(Widget page) => Navigator.of(this).pushReplacement<T, T>(
        MaterialPageRoute(builder: (context) => page),
      );

  Future<T?> pushAndRemoveUntil<T>(Widget page, bool Function(Route<dynamic>) predicate) =>
      Navigator.of(this).pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (context) => page),
        predicate,
      );

  // Show dialogs and snackbars
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showErrorSnackBar(String message) {
    showSnackBar(message, isError: true);
  }

  Future<T?> showAppDialog<T>(Widget dialog) => showDialog<T>(
        context: this,
        builder: (context) => dialog,
      );

  Future<T?> showAppBottomSheet<T>(Widget sheet, {bool isDismissible = true}) =>
      showModalBottomSheet<T>(
        context: this,
        builder: (context) => sheet,
        isScrollControlled: true,
        isDismissible: isDismissible,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      );

  // Responsive helpers
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;

  double responsiveValue({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}