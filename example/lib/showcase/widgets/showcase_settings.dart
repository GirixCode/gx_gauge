import 'package:flutter/material.dart';

/// App-wide showcase options: theme brightness and text direction.
class ShowcaseSettings extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _rtl = false;

  /// Light or dark theme.
  ThemeMode get themeMode => _themeMode;

  /// Whether the app runs right-to-left, to show gauges mirroring.
  bool get rtl => _rtl;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    notifyListeners();
  }

  void toggleRtl() {
    _rtl = !_rtl;
    notifyListeners();
  }
}

/// Makes [ShowcaseSettings] available below the app.
class ShowcaseScope extends InheritedNotifier<ShowcaseSettings> {
  const ShowcaseScope({
    super.key,
    required ShowcaseSettings settings,
    required super.child,
  }) : super(notifier: settings);

  static ShowcaseSettings of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShowcaseScope>()!.notifier!;
}

/// Theme and direction toggles for app bars.
List<Widget> settingsActions(BuildContext context) {
  final ShowcaseSettings settings = ShowcaseScope.of(context);
  final bool dark = settings.themeMode == ThemeMode.dark;
  return <Widget>[
    IconButton(
      tooltip: settings.rtl ? 'Left-to-right' : 'Right-to-left',
      icon: Icon(
        settings.rtl
            ? Icons.format_textdirection_l_to_r
            : Icons.format_textdirection_r_to_l,
      ),
      onPressed: settings.toggleRtl,
    ),
    IconButton(
      tooltip: dark ? 'Light theme' : 'Dark theme',
      icon: Icon(dark ? Icons.light_mode : Icons.dark_mode),
      onPressed: settings.toggleTheme,
    ),
  ];
}
