import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/create/create_list_bloc.dart';
import 'package:shopping/presentation/data/presentation_constants.dart';

class CreateListScreen extends StatefulWidget {
  static const String id = '/create';

  const CreateListScreen({super.key});

  @override
  State<CreateListScreen> createState() => _CreateListScreenState();
}

class _CreateListScreenState extends State<CreateListScreen> {
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New list'),
      ),
      body: BlocBuilder<CreateListBloc, CreateListState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 32),
                Form(
                  autovalidateMode: state.showError
                      ? AutovalidateMode.always
                      : AutovalidateMode.disabled,
                  child: TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.sentences,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLength: 40,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (_) => _validateTitle(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _titleController.addListener(() {
      context
          .read<CreateListBloc>()
          .add(CreateListEvent.titleChanged(_titleController.text));
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  String? _validateTitle() {
    return context.read<CreateListBloc>().state.title.value.when(
          (failure) => failure.map(
            empty: (_) => kEmptyTitleError,
            invalid: (_) => kInvalidTitleError,
          ),
          (success) => null,
        );
  }
}
