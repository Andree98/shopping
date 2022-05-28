import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shopping/application/home/home_cubit.dart';
import 'package:shopping/domain/entities/shopping_list.dart';

class ShoppingListItem extends StatelessWidget {
  final ShoppingList list;

  const ShoppingListItem({required this.list, super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {
          return context.read<HomeCubit>().removeShoppingList(list.id);
        } else {
          return Future.value(false);
        }
      },
      background: Container(
        padding: const EdgeInsets.only(left: 16),
        color: Colors.red,
        child: Row(
          children: const [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Delete',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            )
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.transparent,
      ),
      key: Key(list.id),
      child: Card(
        child: ListTile(
          title: Text(list.title),
          trailing: Text(_formatDate()),
          subtitle: Text(_getCompletionStatus()),
        ),
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
