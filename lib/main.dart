import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'screens/welcome_screen.dart';
import 'state/quiz_controller.dart';
import 'state/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NalarNusantaraApp());
}

class NalarNusantaraApp extends StatelessWidget {
  const NalarNusantaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => QuizController()),
      ],
      child: const _AppShell(),
    );
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell();

  SystemUiOverlayStyle _overlayStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDark
          ? const Color(0xFF101109)
          : const Color(0xFFF4F0E6),
      systemNavigationBarIconBrightness: isDark
          ? Brightness.light
          : Brightness.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      title: 'Nalar Nusantara',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.mode,
      themeAnimationDuration: const Duration(milliseconds: 500),
      themeAnimationCurve: Curves.easeOutCubic,
      home: const WelcomeScreen(),
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        // Batasi skala teks agar tampilan tetap proporsional (adaptive/responsive).
        final scale = mq.textScaler.scale(1).clamp(0.9, 1.3);
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: _overlayStyle(context),
          child: MediaQuery(
            data: mq.copyWith(textScaler: TextScaler.linear(scale)),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
