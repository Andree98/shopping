import 'package:flutter/material.dart';

class DeleteBackground extends StatelessWidget {
  const DeleteBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.only(left: 16),
      color: Colors.red,
      child: Row(
        children: const [
          Icon(
            size: 20,
            Icons.delete,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
