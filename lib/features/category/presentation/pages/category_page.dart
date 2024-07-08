import 'package:flutter/material.dart';

import '../../../../text_field_custom_widget.dart';
import '../../domain/entities/category_entity.dart';
import '../manager/category_controler.dart';
import '../manager/category_state.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, required this.categoryController});

  final CategoryController categoryController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: ValueListenableBuilder<CategoryState>(
        valueListenable: categoryController.state,
        builder: (context, state, child) {
          if (state.status == CategoryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == CategoryStatus.error) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state.status == CategoryStatus.success) {
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return ListTile(
                  title: Text(category.name),
                );
              },
            );
          }
          return Center(
            child: ElevatedButton(
              onPressed: categoryController.fetchCategories,
              child: Text('Press the button to fetch categories.'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => modalCreateCategory(context),
        // onPressed: categoryController.fetchCategories,
        child: const Icon(Icons.refresh),
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
        return Padding(
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
                  categoryController.createCategory(
                    CategoryEntity(
                      name: nameEC.text,
                      created: DateTime.now(),
                      limitMonthly:
                          limitEC.text.isEmpty ? 0 : double.parse(limitEC.text),
                      consumed: 0,
                    ),
                  );
                  Navigator.of(contextModal).pop();
                },
                child: const Text('Criar categoria'),
              ),
            ],
          ),
        );
      },
    );
  }
}
