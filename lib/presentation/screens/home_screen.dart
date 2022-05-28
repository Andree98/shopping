import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/home/home_cubit.dart';
import 'package:shopping/presentation/widgets/shopping_list_item.dart';

class HomeScreen extends StatelessWidget {
  static const String id = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping list'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<HomeCubit>().test(),
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
                return ListView.builder(
                  itemCount: state.shoppingLists.length,
                  itemBuilder: (context, index) => ShoppingListItem(
                    list: state.shoppingLists[index],
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
        listenWhen: (previous, current) =>
            previous.isDeleting != current.isDeleting,
        listener: (context, state) {
          if (state.isDeleting) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(hours: 1),
                content: Row(
                  children: const [
                    SizedBox.square(
                      dimension: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text('Deleting shopping list'),
                  ],
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            if (state.deleteListResult?.isFailure() ?? false) {
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
          }
        },
      ),
    );
  }
}
