import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/factories/category_factory.dart';
import 'core/factories/expense_factory.dart';
import 'features/category/presentation/manager/category_controler.dart';
import 'features/category/presentation/pages/category_page.dart';
import 'features/expense/expense.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firestore = FirebaseFirestore.instance;

  final categoryController = categoryControllerFactory(firestore);
  final expenseController = expenseControllerFactory(firestore);

  runApp(MyApp(
    categoryController: categoryController,
    expenseController: expenseController,
  ));
}

class MyApp extends StatelessWidget {
  final CategoryController categoryController;
  final ExpenseController expenseController;

  const MyApp({
    super.key,
    required this.categoryController,
    required this.expenseController,
  });

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
      initialRoute: ExpensePage.routeName,
      routes: {
        ExpensePage.routeName: (context) =>
            ExpensePage(expenseController: expenseController),
        CategoryPage.routeName: (context) =>
            CategoryPage(categoryController: categoryController),
      },
    );
  }
}
