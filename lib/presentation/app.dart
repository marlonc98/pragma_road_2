import 'package:flutter/material.dart';
import 'package:portal_remoto/flavors/flavors.dart';
import 'package:portal_remoto/presentation/router.dart';
import 'package:portal_remoto/presentation/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: F.title,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
