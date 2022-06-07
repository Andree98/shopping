import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/create/create_list_bloc.dart';
import 'package:shopping/application/home/home_cubit.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/injection.dart';
import 'package:shopping/presentation/common/widgets/delete_dialog.dart';
import 'package:shopping/presentation/create/screens/create_list_screen.dart';
import 'package:shopping/presentation/home/widgets/shopping_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping list'),
        actions: [
          if (context.watch<HomeCubit>().state.shoppingLists.isNotEmpty)
            IconButton(
              tooltip: 'Delete all',
              splashRadius: 24,
              onPressed: () async => _showDeleteDialog(),
              icon: const Icon(
                Icons.delete,
                size: 20,
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New list',
        onPressed: () => Navigator.push<ShoppingList>(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => getIt<CreateListBloc>(),
              child: const CreateListScreen(),
            ),
          ),
        ).then((list) {
          if (list != null) context.read<HomeCubit>().addShoppingList(list);
        }),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (state.getListsResult!.isSuccess()) {
              if (state.shoppingLists.isNotEmpty) {
                return RefreshIndicator(
                  onRefresh: () {
                    context.read<HomeCubit>().refresh();

                    return context
                        .read<HomeCubit>()
                        .stream
                        .firstWhere((e) => !e.isRefreshing);
                  },
                  child: Column(
                    children: [
                      Visibility(
                        visible: state.isDeleting,
                        replacement: const SizedBox(height: 5),
                        child: const LinearProgressIndicator(
                          color: Colors.pinkAccent,
                          minHeight: 5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.shoppingLists.length,
                          itemBuilder: (context, index) {
                            return ShoppingListItem(
                              list: state.shoppingLists[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text("You don't have any shopping lists"),
                );
              }
            } else {
              return const Center(
                child: Text('An error has occurred'),
              );
            }
          }
        },
        listenWhen: (_, current) => current.deleteListResult != null,
        listener: (context, state) {
          if (state.deleteListResult!.isFailure()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Row(
                  children: const [
                    Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 16),
                    Text('An error has occurred'),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _showDeleteDialog() async {
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteDialog(
        title: 'Delete All',
        body: 'Delete all lists? This action cannot be undone',
      ),
    );

    if (isConfirmed ?? false) {
      if (!mounted) return;

      context.read<HomeCubit>().removeAllLists();
    }
  }
}
