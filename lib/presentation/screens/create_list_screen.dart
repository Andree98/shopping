import 'package:flutter/material.dart';

class CreateListScreen extends StatelessWidget {
  static const String id = '/create';

  const CreateListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New list'),
      ),
    );
  }
}
