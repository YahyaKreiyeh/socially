import 'package:flutter/material.dart';
import 'package:socially/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:socially/init_dependencies.dart';
import 'package:socially/routing/app_router.dart';
import 'package:socially/routing/routes.dart';
import 'package:socially/socially.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  final String initialRoute = determineInitialRoute();

  runApp(
    Socially(
      appRouter: AppRouter(),
      initialRoute: initialRoute,
    ),
  );
}

String determineInitialRoute() {
  final authRemoteDataSource = getIt<AuthRemoteDataSource>();
  final session = authRemoteDataSource.currentUserSession;
  if (session != null) {
    return Routes.navigationPage;
  } else {
    return Routes.signinPage;
  }
}
