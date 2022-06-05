import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/details/list_details_bloc.dart';
import 'package:shopping/domain/details/entities/details_action.dart';
import 'package:shopping/presentation/common/widgets/delete_dialog.dart';
import 'package:shopping/presentation/common/widgets/new_item_dialog.dart';
import 'package:shopping/presentation/details/widgets/details_list_item.dart';

class ListDetailsScreen extends StatefulWidget {
  const ListDetailsScreen({super.key});

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
          DetailsAction.updated(
              context.read<ListDetailsBloc>().state.shoppingList),
        );

        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.watch<ListDetailsBloc>().state.shoppingList?.title ?? '',
          ),
          actions: [
            IconButton(
              onPressed: () async => !_hasErrors() ? _showDeleteDialog() : null,
              icon: const Icon(Icons.delete),
              splashRadius: 24,
              tooltip: 'Delete List',
            )
          ],
        ),
        body: BlocBuilder<ListDetailsBloc, ListDetailsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (state.loadListResult!.isSuccess() &&
                  state.shoppingList != null) {
                if (state.shoppingList!.items.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.shoppingList!.items.length,
                    itemBuilder: (context, index) => DetailsListItem(
                      item: state.shoppingList!.items[index],
                      index: index,
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No items'),
                  );
                }
              } else {
                return const Center(
                  child: Text('An error has occurred'),
                );
              }
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'New item',
          onPressed: () async => !_hasErrors() ? _showNewItemDialog() : null,
          child: const Icon(Icons.create),
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

  Future<void> _showNewItemDialog() async {
    if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();

    final itemLabel = await showDialog<String>(
      context: context,
      builder: (_) => const NewItemDialog(),
    );

    if (itemLabel != null && itemLabel.isNotEmpty) {
      if (!mounted) return;

      context.read<ListDetailsBloc>().add(ListDetailsEvent.addItem(itemLabel));
    }
  }

  bool _hasErrors() {
    final state = context.read<ListDetailsBloc>().state;

    return (state.loadListResult?.isFailure() ?? true) ||
        state.shoppingList == null;
  }
}
