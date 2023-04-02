import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';

showSnackBar({
  required BuildContext context,
  required String mensagem,
  bool isErro = true,
  Function? actionFunction,
  String? actionName,
}) {
  SnackBar snackBar = SnackBar(
    content: Text(mensagem),
    backgroundColor: (isErro) ? MyColors.darkRed : MyColors.happyGreen,
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
