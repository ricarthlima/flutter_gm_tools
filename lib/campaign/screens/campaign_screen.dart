import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';
import 'package:flutter_gm_tools/_core/enum_tabs.dart';
import 'package:flutter_gm_tools/campaign/components/campaign_view_header.dart';
import 'package:flutter_gm_tools/campaign/screens/sound_screen.dart';
import 'package:flutter_gm_tools/models/campaign.dart';

class CampaignScreen extends StatefulWidget {
  final Campaign campaign;
  const CampaignScreen({super.key, required this.campaign});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  TabsEnum currentTab = TabsEnum.sounds;

  late Map<TabsEnum, Widget> innerScreens;

  @override
  void initState() {
    setState(() {
      innerScreens = {
        TabsEnum.sounds: SoundScreen(campaign: widget.campaign),
      };
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkfgreen,
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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: innerScreens[currentTab] != null
                    ? innerScreens[currentTab]!
                    : Container(
                        alignment: Alignment.center,
                        child: Text(
                          currentTab.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
              ),
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
