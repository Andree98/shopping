import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping/application/create/create_list_bloc.dart';
import 'package:shopping/domain/common/entities/list_item.dart';
import 'package:shopping/presentation/common/widgets/new_item_dialog.dart';
import 'package:shopping/presentation/create/widgets/create_list_item.dart';
import 'package:uuid/uuid.dart';

class CreateListScreen extends StatefulWidget {
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
            onPressed: () => context
                .read<CreateListBloc>()
                .add(const CreateListEvent.saveList()),
            tooltip: 'Save',
            splashRadius: 24.0,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: BlocConsumer<CreateListBloc, CreateListState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Visibility(
                  visible: state.isSaving,
                  replacement: const SizedBox(height: 5),
                  child: const LinearProgressIndicator(
                    color: Colors.pinkAccent,
                    minHeight: 5,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
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
                ),
              ),
              if (state.items.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => CreateListItem(
                      item: state.items[index],
                      index: index,
                    ),
                    childCount: state.items.length,
                  ),
                )
              else
                const SliverFillRemaining(
                  child: Center(
                    child: Text('List is empty'),
                  ),
                ),
            ],
          );
        },
        listenWhen: (_, current) => current.saveListResult != null,
        listener: (context, state) {
          if (state.saveListResult!.isFailure()) {
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
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.pop(context, state.createdList);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New item',
        onPressed: () async => _showNewItemDialog(),
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
            empty: (e) => e.message,
            invalid: (e) => e.message,
          ),
          (success) => null,
        );
  }

  Future<void> _showNewItemDialog() async {
    if (FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();

    final itemLabel = await showDialog<String>(
      context: context,
      builder: (_) => const NewItemDialog(),
    );

    if (itemLabel != null && itemLabel.isNotEmpty) {
      if (!mounted) return;

      final listItem = ListItem(
        id: const Uuid().v1(),
        label: itemLabel,
        isChecked: false,
      );

      context.read<CreateListBloc>().add(CreateListEvent.addItem(listItem));
    }
  }
}
