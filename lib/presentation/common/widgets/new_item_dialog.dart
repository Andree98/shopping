import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewItemDialog extends StatefulWidget {
  const NewItemDialog({super.key});

  @override
  State<NewItemDialog> createState() => _NewItemDialogState();
}

class _NewItemDialogState extends State<NewItemDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New item'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.sentences,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        autofocus: true,
        maxLength: 30,
        decoration: const InputDecoration(labelText: 'Label'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
