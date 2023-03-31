import 'package:flutter/material.dart';

showSnackBar({
  required BuildContext context,
  required String mensagem,
  bool isErro = true,
  Function? actionFunction,
  String? actionName,
}) {
  SnackBar snackBar = SnackBar(
    content: Text(mensagem),
    backgroundColor: (isErro) ? Colors.red : Colors.green,
    action: (actionFunction != null && actionName != null)
        ? SnackBarAction(
            label: actionName,
            onPressed: () {
              actionFunction();
            })
        : null,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
