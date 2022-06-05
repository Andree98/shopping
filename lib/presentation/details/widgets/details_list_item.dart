import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/details/list_details_bloc.dart';
import 'package:shopping/domain/common/entities/list_item.dart';
import 'package:shopping/presentation/common/widgets/delete_background.dart';

class DetailsListItem extends StatelessWidget {
  final ListItem item;
  final int index;

  const DetailsListItem({
    required this.item,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {
          context
              .read<ListDetailsBloc>()
              .add(ListDetailsEvent.deleteItem(item.id));
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      },
      background: const DeleteBackground(),
      secondaryBackground: Container(
        color: Colors.transparent,
      ),
      key: Key(item.id),
      child: Card(
        child: CheckboxListTile(
          title: Text(
            item.label,
            style: TextStyle(
              decoration: item.isChecked ? TextDecoration.lineThrough : null,
            ),
          ),
          value: item.isChecked,
          onChanged: (checked) => context
              .read<ListDetailsBloc>()
              .add(ListDetailsEvent.checkStatusChanged(index, checked!)),
        ),
      ),
    );
  }
}
