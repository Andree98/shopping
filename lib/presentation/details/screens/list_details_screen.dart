import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/details/list_details_bloc.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/details/entities/details_action.dart';
import 'package:shopping/presentation/common/widgets/delete_dialog.dart';
import 'package:shopping/presentation/details/widgets/details_list_item.dart';

class ListDetailsScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  const ListDetailsScreen({required this.shoppingList, super.key});

  @override
  State<ListDetailsScreen> createState() => _ListDetailsScreenState();
}

class _ListDetailsScreenState extends State<ListDetailsScreen> {
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
          title: Text(widget.shoppingList.title),
          actions: [
            IconButton(
              onPressed: () async => _showDeleteDialog(),
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
                listId: widget.shoppingList.id,
                index: index,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog() async {
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteDialog(
        title: 'Delete List',
        body: 'Delete shopping list? This action cannot be undone',
      ),
    );

    if (isConfirmed ?? false) {
      if (!mounted) return;

      Navigator.pop(context, const DetailsAction.deleted());
    }
  }
}
