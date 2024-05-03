import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'category_model.dart';
import 'controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Controller controller = Controller(firestore: firestore);

  runApp(
    MaterialApp(
      title: 'Flutter Database Example',
      home: MyHomePage(controller: controller),
    ),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.controller});

  final Controller controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Category Manager')),
      body: StreamBuilder<List<Category>>(
        stream: controller.readCategories(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData) {
            final List<Category> categories = snapshot.data!;
            return ListView(
              children: categories
                  .map((Category category) => ListTile(
                        title: Text(category.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              controller.deleteCategory(category.id),
                        ),
                      ))
                  .toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.createCategory(
            Category(
              name: 'mercado',
              created: DateTime.now(),
              limitMonthly: 400,
              id: '1',
              consumed: 84,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
