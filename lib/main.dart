import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dependency_injection.dart';
import 'flavors/flavors.dart';
import 'presentation/app.dart';

void main() async {
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
    orElse: () => Flavor.prod,
  );
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(UncontrolledProviderScope(container: di, child: const App()));
}
