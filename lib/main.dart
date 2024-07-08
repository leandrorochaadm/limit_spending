import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/factories/category_factory.dart';
import 'features/category/presentation/manager/category_controler.dart';
import 'features/category/presentation/pages/category_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firestore = FirebaseFirestore.instance;

  final categoryController = categoryControllerFactory(firestore);

  runApp(MyApp(categoryController: categoryController));
}

class MyApp extends StatelessWidget {
  final CategoryController categoryController;

  const MyApp({super.key, required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: CategoryPage(categoryController: categoryController),
    );
  }
}
