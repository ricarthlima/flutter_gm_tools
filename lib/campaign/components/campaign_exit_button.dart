import 'package:flutter/material.dart';

import '../../_core/colors.dart';
import '../../roteador_telas.dart';

class CampaignExitButton extends StatelessWidget {
  const CampaignExitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      child: IconButton(
        icon: const Icon(
          Icons.close,
          color: MyColors.white,
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const RoteadorTelas(),
            ),
          );
        },
      ),
    );
  }
}
