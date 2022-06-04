import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shopping/application/details/list_details_bloc.dart';
import 'package:shopping/application/home/home_cubit.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/details/entities/details_action.dart';
import 'package:shopping/injection.dart';
import 'package:shopping/presentation/common/widgets/delete_background.dart';
import 'package:shopping/presentation/details/screens/list_details_screen.dart';

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
      background: const DeleteBackground(),
      secondaryBackground: Container(
        color: Colors.transparent,
      ),
      key: Key(list.id),
      child: Card(
        child: ListTile(
          title: Text(list.title),
          trailing: Text(_formatDate()),
          subtitle: Text(_getCompletionStatus()),
          onTap: () => Navigator.push<DetailsAction>(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => getIt<ListDetailsBloc>()
                  ..add(ListDetailsEvent.setItems(list.items)),
                child: ListDetailsScreen(shoppingList: list),
              ),
            ),
          ).then(
            (value) {
              if (value != null) {
                value.when(
                    updated: (e) => context
                        .read<HomeCubit>()
                        .updateShoppingList(list.copyWith(items: e)),
                    deleted: () =>
                        context.read<HomeCubit>().removeShoppingList(list.id));
              }
            },
          ),
        ),
      ),
    );
  }

  String _formatDate() {
    final createdDate = DateTime.fromMillisecondsSinceEpoch(list.created);

    return DateFormat.MMMd().format(createdDate);
  }

  String _getCompletionStatus() {
    final total = list.items.length;
    final completed = list.items.where((e) => e.isChecked).length;

    return 'Completed: $completed / $total';
  }
}
