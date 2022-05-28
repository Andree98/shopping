import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/home/home_cubit.dart';
import 'package:shopping/presentation/screens/create_list_screen.dart';
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
        onPressed: () => Navigator.pushNamed(context, CreateListScreen.id),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
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
      ),
    );
  }
}
