import 'package:flutter/material.dart';
import 'package:portal_remoto/flavors/flavors.dart';
import 'package:portal_remoto/presentation/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(title: F.title, routerConfig: router);
  }
}
