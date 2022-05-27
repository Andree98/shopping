import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/home/home_cubit.dart';
import 'package:shopping/presentation/screens/create_list_screen.dart';

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
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.read<HomeCubit>().createListTest(),
            child: Text('Create post'),
          ),
          ElevatedButton(
            onPressed: () => context.read<HomeCubit>().getListsTest(),
            child: Text('Get posts'),
          ),
        ],
      ),
    );
  }
}
