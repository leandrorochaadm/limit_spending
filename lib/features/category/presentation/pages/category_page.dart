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
      appBar: AppBar(title: const Text('Categorias'), elevation: 7),
      body: Stack(
        children: [
          StreamBuilder<List<CategoryEntity>>(
            stream: categoryController.categoriesStream,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No categories found.'));
              }

              final categories = snapshot.data!;

              return ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return ListTile(
                    title: Text(
                      '${category.name} (limite: ${category.limitMonthly.toStringAsFixed(2)})',
                    ),
                    subtitle: Text(
                      'Disponível: ${(category.balance).toStringAsFixed(2)}',
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () =>
                        modalCreateCategory(context, category: category),
                  );
                },
              );
            },
          ),
          ValueListenableBuilder<CategoryState>(
            valueListenable: categoryController.state,
            builder: (context, state, __) {
              if (state.status == CategoryStatus.error) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? 'Erro desconhecido'),
                    ),
                  );
                });
              }
              if (state.status == CategoryStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => modalCreateCategory(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> modalCreateCategory(
    BuildContext context, {
    CategoryEntity? category,
  }) {
    final bool isEdit = category != null;
    final TextEditingController nameEC =
        TextEditingController(text: category?.name);
    final FocusNode nameFN = FocusNode();

    final TextEditingController limitEC =
        TextEditingController(text: category?.limitMonthly.toStringAsFixed(2));
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
                  if (isEdit) {
                    CategoryEntity categoryUpdate = category.toModel().copyWith(
                          name: nameEC.text,
                          limitMonthly: limitEC.text.isEmpty
                              ? 0
                              : double.parse(limitEC.text),
                        );
                    categoryController.updateCategory(categoryUpdate);
                  } else {
                    categoryController.createCategory(
                      CategoryEntity(
                        name: nameEC.text,
                        created: DateTime.now(),
                        limitMonthly: limitEC.text.isEmpty
                            ? 0
                            : double.parse(limitEC.text),
                        consumed: 0,
                      ),
                    );
                  }
                  Navigator.of(contextModal).pop();
                },
                child: isEdit
                    ? const Text('Editar categoria')
                    : const Text('Criar categoria'),
              ),
            ],
          ),
        );
      },
    );
  }
}
