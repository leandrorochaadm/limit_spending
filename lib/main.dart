import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'category_model.dart';
import 'controller.dart';
import 'firebase_options.dart';
import 'text_field_custom_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Controller controller = Controller(firestore: firestore);

  runApp(
    MaterialApp(
      title: 'Limit Spending',
      home: CategoryPage(controller: controller),
    ),
  );
}

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, required this.controller});

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
                  .map(
                    (Category category) => ListTile(
                      title: Text(category.name),
                      subtitle: Text(
                        'Limite R\$ ${category.balance.toStringAsFixed(2)}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => controller.deleteCategory(category.id),
                      ),
                    ),
                  )
                  .toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modalCreateCategory(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> modalCreateCategory(BuildContext context) {
    final TextEditingController nameEC = TextEditingController();
    final FocusNode nameFN = FocusNode();

    final TextEditingController limitEC = TextEditingController();
    final FocusNode limitFN = FocusNode();

    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext contextModal) {
        return Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: <Widget>[
                  TextFieldCustomWidget(
                    controller: nameEC,
                    focusNode: nameFN,
                    hintText: 'Nome da categoria',
                  ),
                  const SizedBox(height: 24),
                  TextFieldCustomWidget(
                    controller: limitEC,
                    focusNode: limitFN,
                    hintText: 'Limite mensal',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      shape: const StadiumBorder(),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onPressed: () {
                      controller.createCategory(
                        Category(
                          name: nameEC.text,
                          created: DateTime.now(),
                          limitMonthly: limitEC.text.isEmpty
                              ? 0
                              : double.parse(limitEC.text),
                          consumed: 0,
                        ),
                      );
                      Navigator.of(contextModal).pop();
                    },
                    child: const Text('Criar categoria'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
