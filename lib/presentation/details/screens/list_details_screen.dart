import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/details/list_details_bloc.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/details/entities/details_action.dart';
import 'package:shopping/presentation/common/delete_background.dart';

class ListDetailsScreen extends StatelessWidget {
  final ShoppingList shoppingList;

  const ListDetailsScreen({required this.shoppingList, super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(
          context,
          DetailsAction.updated(context.read<ListDetailsBloc>().state.items),
        );

        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(shoppingList.title),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(
                context,
                const DetailsAction.deleted(),
              ),
              icon: const Icon(Icons.delete),
              splashRadius: 24,
              tooltip: 'Delete List',
            )
          ],
        ),
        body: BlocBuilder<ListDetailsBloc, ListDetailsState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return Dismissible(
                  confirmDismiss: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      context.read<ListDetailsBloc>().add(
                            ListDetailsEvent.deleteItem(
                              shoppingList.id,
                              item.id,
                            ),
                          );
                      return Future.value(true); // TODO change this
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
                          decoration: item.isChecked
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      value: item.isChecked,
                      onChanged: (checked) =>
                          context.read<ListDetailsBloc>().add(
                                ListDetailsEvent.checkStatusChanged(
                                  shoppingList.id,
                                  index,
                                  checked!,
                                ),
                              ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
