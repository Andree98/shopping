import 'package:flutter/material.dart';
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
    );
  }
}
