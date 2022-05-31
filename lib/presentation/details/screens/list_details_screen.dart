import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/details/list_details_bloc.dart';
import 'package:shopping/domain/entities/shopping_list.dart';

class ListDetailsScreen extends StatelessWidget {
  final ShoppingList shoppingList;

  const ListDetailsScreen({required this.shoppingList, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.title),
      ),
      body: BlocBuilder<ListDetailsBloc, ListDetailsState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return Card(
                child: CheckboxListTile(
                  title: Text(
                    item.label,
                    style: TextStyle(
                      decoration:
                          item.isChecked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  value: item.isChecked,
                  onChanged: (checked) => context.read<ListDetailsBloc>().add(
                        ListDetailsEvent.checkStatusChanged(
                          shoppingList.id,
                          index,
                          checked!,
                        ),
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
