import 'package:flutter/material.dart';

class GMViewNavigationBar extends StatelessWidget {
  final Function clickAudioTab;
  const GMViewNavigationBar({
    super.key,
    required this.clickAudioTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.audiotrack_rounded),
          ),
        ],
      ),
    );
  }
}
