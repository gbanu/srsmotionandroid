import 'package:flutter/material.dart';
import '../../models/todo.dart';

class CategoryPicker extends StatelessWidget {
  const CategoryPicker({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
  }) : super(key: key);

  final List<ToDoCategory> categories;
  final ToDoCategory? selectedCategory;
  final void Function(ToDoCategory) onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: categories.map((e) {
        return Column(
          children: [
            FloatingActionButton(
              heroTag: null,
              backgroundColor:
                  selectedCategory != null && e.id == selectedCategory!.id ? null : Colors.grey,
              child: Icon(e.iconData),
              onPressed: () => onSelect(e),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(e.name),
            )
          ],
        );
      }).toList(),
    );
  }
}
