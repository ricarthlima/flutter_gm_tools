import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';
import 'package:flutter_gm_tools/gm_view/components/campaign_view_header.dart';
import 'package:flutter_gm_tools/models/campaign.dart';

class GMViewScreen extends StatefulWidget {
  final Campaign campaign;
  const GMViewScreen({super.key, required this.campaign});

  @override
  State<GMViewScreen> createState() => _GMViewScreenState();
}

class _GMViewScreenState extends State<GMViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkgrey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CampaignViewHeader(campaign: widget.campaign),
          const Text(
            "Pesquisa 'dashboard' no pub.dev",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
