import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/create/create_list_bloc.dart';
import 'package:shopping/presentation/create/widgets/new_item_dialog.dart';
import 'package:shopping/presentation/home/data/presentation_constants.dart';

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
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'Save',
            splashRadius: 24.0,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: BlocBuilder<CreateListBloc, CreateListState>(
        builder: (context, state) {
          return Column(
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
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];

                    return Dismissible(
                      key: Key(item.hashCode.toString()),
                      onDismissed: (_) => context
                          .read<CreateListBloc>()
                          .add(CreateListEvent.removeItem(index)),
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          item.label,
                          style: TextStyle(
                            decoration: item.isChecked
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        value: item.isChecked,
                        onChanged: (checked) => context
                            .read<CreateListBloc>()
                            .add(CreateListEvent.checkStateChanged(
                              index,
                              checked!,
                            )),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _openNewItemDialog(),
        child: const Icon(Icons.create),
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

  Future<void> _openNewItemDialog() async {
    final itemLabel = await showDialog<String>(
      context: context,
      builder: (_) => const NewItemDialog(),
    );

    if (itemLabel != null && itemLabel.isNotEmpty) {
      if (!mounted) return;

      context.read<CreateListBloc>().add(CreateListEvent.addItem(itemLabel));
    }
  }
}
