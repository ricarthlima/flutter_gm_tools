import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';

class GridBaseItem extends StatefulWidget {
  final String title;
  final Widget widget;
  const GridBaseItem({
    super.key,
    required this.widget,
    required this.title,
  });

  @override
  State<GridBaseItem> createState() => _GridBaseItemState();
}

class _GridBaseItemState extends State<GridBaseItem> {
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MyColors.darkgrey,
          width: 4,
          style: BorderStyle.solid,
        ),
      ),
      height: (!isOpen) ? 100 : null,
      child: Column(
        children: [
          Row(
            children: [
              Text(widget.title),
              IconButton(
                onPressed: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
                icon: Icon(
                  (isOpen)
                      ? Icons.arrow_drop_down_sharp
                      : Icons.arrow_drop_up_sharp,
                ),
              ),
            ],
          ),
          (isOpen) ? widget : Container()
        ],
      ),
    );
  }
}
