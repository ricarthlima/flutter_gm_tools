import 'package:flutter/material.dart';

showJoinDialog({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Insira o código da sala"),
        content: TextFormField(
          decoration: const InputDecoration(
            label: Text("Código"),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Entrar"),
          ),
        ],
      );
    },
  );
}
