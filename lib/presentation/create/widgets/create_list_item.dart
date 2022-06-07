import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/create/create_list_bloc.dart';
import 'package:shopping/domain/common/entities/list_item.dart';
import 'package:shopping/presentation/common/widgets/delete_background.dart';

class CreateListItem extends StatelessWidget {
  final ListItem item;
  final int index;

  const CreateListItem({
    required this.item,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.hashCode.toString()),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {
          context.read<CreateListBloc>().add(CreateListEvent.removeItem(index));
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      },
      background: const DeleteBackground(),
      secondaryBackground: Container(
        color: Colors.transparent,
      ),
      child: Card(
        child: CheckboxListTile(
          title: Text(
            item.label,
            style: TextStyle(
              decoration: item.isChecked ? TextDecoration.lineThrough : null,
            ),
          ),
          value: item.isChecked,
          onChanged: (checked) => context.read<CreateListBloc>().add(
                CreateListEvent.checkStateChanged(
                  index,
                  checked!,
                ),
              ),
        ),
      ),
    );
  }
}
