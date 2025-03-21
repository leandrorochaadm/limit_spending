import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/factories/factories.dart';
import 'core/theme_custom/theme_data_custom.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeDataCustom.darkTheme,
      // home: makeDebtPage(),
      home: supermarketPageFactory(),
    );
  }
}
