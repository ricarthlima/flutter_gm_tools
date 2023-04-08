import 'package:flutter/material.dart';

class CampaignDraggableGrid extends StatefulWidget {
  const CampaignDraggableGrid({super.key});

  @override
  State<CampaignDraggableGrid> createState() => _CampaignDraggableGridState();
}

class _CampaignDraggableGridState extends State<CampaignDraggableGrid> {
  List<Widget> listWidget = List.generate(
    3,
    (index) => Container(
      height: 100,
      margin: const EdgeInsets.all(8),
      color: Colors.white,
      child: Center(child: Text(index.toString())),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Draggable<Widget>(
                feedback: Container(),
                child: listWidget[0],
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [],
          ),
        ),
      ],
    );
  }
}
