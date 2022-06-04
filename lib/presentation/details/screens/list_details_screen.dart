import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/details/list_details_bloc.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/details/entities/details_action.dart';
import 'package:shopping/presentation/details/screens/widgets/details_list_item.dart';

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
              itemBuilder: (context, index) => DetailsListItem(
                item: state.items[index],
                listId: shoppingList.id,
                index: index,
              ),
            );
          },
        ),
      ),
    );
  }
}
