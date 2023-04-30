import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';

class MovableDialog extends StatefulWidget {
  const MovableDialog({super.key});

  @override
  State<MovableDialog> createState() => _MovableDialogState();
}

class _MovableDialogState extends State<MovableDialog> {
  Alignment alignment = Alignment.bottomLeft;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: alignment,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: MyColors.white,
            border: Border.all(
              color: MyColors.darkfgreen,
            ),
          ),
          child: IconButton(
            onPressed: () {
              setState(() {
                alignment = Alignment.topCenter;
              });
            },
            icon: const Icon(Icons.grid_view),
          ),
        ),
      ),
    );
  }
}
