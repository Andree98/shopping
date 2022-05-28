import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/home/home_cubit.dart';
import 'package:shopping/presentation/screens/create_list_screen.dart';
import 'package:shopping/presentation/widgets/delete_dialog.dart';
import 'package:shopping/presentation/widgets/shopping_list_item.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/home';

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
          IconButton(
            tooltip: 'Delete all',
            splashRadius: 24,
            onPressed: () async => _openDeleteDialog(),
            icon: const Icon(
              Icons.delete,
              size: 20,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, CreateListScreen.id),
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
                return Column(
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
                      child: RefreshIndicator(
                        onRefresh: () {
                          context.read<HomeCubit>().refresh();

                          return context
                              .read<HomeCubit>()
                              .stream
                              .firstWhere((e) => !e.isRefreshing);
                        },
                        child: ListView.builder(
                          itemCount: state.shoppingLists.length,
                          itemBuilder: (context, index) {
                            return ShoppingListItem(
                              list: state.shoppingLists[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
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

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadShoppingLists();
  }

  Future<void> _openDeleteDialog() async {
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteDialog(),
    );

    if (isConfirmed ?? false) {
      if (!mounted) return;

      context.read<HomeCubit>().removeAllLists();
    }
  }
}
