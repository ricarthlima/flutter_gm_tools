import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';
import 'package:flutter_gm_tools/_core/enum_tabs.dart';
import 'package:flutter_gm_tools/gm_view/components/campaign_view_header.dart';
import 'package:flutter_gm_tools/models/campaign.dart';

class GMViewScreen extends StatefulWidget {
  final Campaign campaign;
  const GMViewScreen({super.key, required this.campaign});

  @override
  State<GMViewScreen> createState() => _GMViewScreenState();
}

class _GMViewScreenState extends State<GMViewScreen> {
  TabsEnum currentTab = TabsEnum.sounds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkgrey,
      body: Column(
        children: [
          CampaignViewHeader(
            campaign: widget.campaign,
            clickImages: () {
              clickTab(TabsEnum.images);
            },
            clickMaps: () {
              clickTab(TabsEnum.maps);
            },
            clickNotes: () {
              clickTab(TabsEnum.notes);
            },
            clickSettings: () {
              clickTab(TabsEnum.settings);
            },
            clickSound: () {
              clickTab(TabsEnum.sounds);
            },
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              currentTab.name,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  clickTab(TabsEnum tab) {
    setState(() {
      currentTab = tab;
    });
  }
}
