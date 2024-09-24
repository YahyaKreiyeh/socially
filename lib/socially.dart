import 'package:flutter/material.dart';
import 'package:socially/core/theme/theme.dart';
import 'package:socially/routing/app_router.dart';

class Socially extends StatelessWidget {
  final AppRouter appRouter;
  final String? initialRoute;
  const Socially({
    super.key,
    required this.appRouter,
    this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Socially',
      theme: AppTheme.darkThemeMode,
      initialRoute: initialRoute,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
