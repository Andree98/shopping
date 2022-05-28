import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping/domain/entities/shopping_list.dart';

class ShoppingListItem extends StatelessWidget {
  final ShoppingList list;

  const ShoppingListItem({required this.list, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(list.title),
        trailing: Text(_formatDate()),
        subtitle: Text(_getCompletionStatus()),
      ),
    );
  }

  String _formatDate() {
    final now = DateTime.now();
    final createdDate = DateTime.fromMillisecondsSinceEpoch(list.created);

    if (createdDate.day == now.day) {
      // if the list was created on the same day, show the hours and minutes
      return DateFormat.Hm().format(createdDate);
    } else {
      // if not, show the month and the day
      return DateFormat.MMMd().format(createdDate);
    }
  }

  String _getCompletionStatus() {
    final total = list.items.entries.length;
    final completed = list.items.entries.where((e) => e.value).length;

    return 'Completed: $completed / $total';
  }
}
