import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/factories/factories.dart';
import 'features/category/presentation/presentation.dart';
import 'features/expense/expense.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // final firestore = FirebaseFirestore.instance;

  final categoryController = categoryControllerFactory();
  final expenseController = expenseControllerFactory();

  runApp(
    MyApp(
      categoryController: categoryController,
      expenseController: expenseController,
    ),
  );
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
      home: makeDebtPage(),
      // initialRoute: CategoryPage.routeName,
      // routes: {
      //   ExpensePage.routeName: (context) =>
      //       ExpensePage(expenseController: expenseController),
      //   CategoryPage.routeName: (context) =>
      //       CategoryPage(categoryController: categoryController),
      // },
    );
  }
}
