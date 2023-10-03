import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';
import 'package:flutter_gm_tools/_core/enum_tabs.dart';
import 'package:flutter_gm_tools/_core/services/campaing_service.dart';
import 'package:flutter_gm_tools/auth/services/auth_service.dart';
import 'package:flutter_gm_tools/campaign/components/campaign_view_header.dart';
import 'package:flutter_gm_tools/campaign/helpers/sound_tags.dart';
import 'package:flutter_gm_tools/campaign/models/played_sound_model.dart';
import 'package:flutter_gm_tools/campaign/screens/image_screen.dart';
import 'package:flutter_gm_tools/campaign/screens/settings_screen.dart';
import 'package:flutter_gm_tools/campaign/screens/sound_screen.dart';
import 'package:flutter_gm_tools/_core/models/campaign.dart';
import 'package:just_audio/just_audio.dart';

import '../models/sound_model.dart';
import '../services/sound_service.dart';

class CampaignScreen extends StatefulWidget {
  final Campaign campaign;
  const CampaignScreen({super.key, required this.campaign});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  // Dados locais
  late Campaign campaign;

  // Serviços
  final CampaignService _campaignService = CampaignService();

  // Snapshots
  StreamSubscription? campaignSubscription;

  TabsEnum currentTab = TabsEnum.images;

  late Map<TabsEnum, Widget> innerScreens;

  Map<SoundTag, PlayerSoundModel> mapPlayers = {
    SoundTag.music: PlayerSoundModel(
      originalVolume: 100,
      soundModel: null,
      isLooping: false,
      audioPlayer: AudioPlayer(),
    ),
    SoundTag.ambience: PlayerSoundModel(
      originalVolume: 100,
      soundModel: null,
      isLooping: false,
      audioPlayer: AudioPlayer(),
    ),
    SoundTag.effect: PlayerSoundModel(
      originalVolume: 100,
      soundModel: null,
      isLooping: false,
      audioPlayer: AudioPlayer(),
    ),
    SoundTag.others: PlayerSoundModel(
      originalVolume: 100,
      soundModel: null,
      isLooping: false,
      audioPlayer: AudioPlayer(),
    ),
  };

  double myVolume = 100;

  @override
  void initState() {
    campaign = widget.campaign;

    setState(() {
      innerScreens = {
        TabsEnum.images: ImageScreen(campaign: campaign),
        TabsEnum.sounds: SoundScreen(campaign: campaign),
        TabsEnum.settings: SettingsScreen(campaign: campaign),
      };
    });

    setupAudioListeners();
    setupCampaignStream();

    super.initState();
  }

  @override
  void dispose() {
    mapPlayers.forEach((key, value) {
      value.audioPlayer.stop();
      value.audioPlayer.dispose();
    });
    closeAllStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.darkfgreen,
      body: Column(
        children: [
          CampaignViewHeader(
            campaign: campaign,
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

  setupAudioListeners() {
    // Meu volume
    AuthService().getVolume().listen((event) {
      Map<String, dynamic>? user = event.data();
      if (user != null && user["volume"] != null) {
        myVolume = user["volume"];
      } else {
        myVolume = 100;
      }
      _updatePlayers();
    });

    // Reprodutores
    for (SoundTag tag in SoundTag.values) {
      SoundService(campaign: campaign).listenActiveSounds(tag).listen(
        (DocumentSnapshot<Map<String, dynamic>> snapshot) async {
          if (snapshot.data() != null) {
            Map<String, dynamic> map = snapshot.data()!;

            // Loop
            bool isLooping = false;
            bool? loop = map["loop"];
            if (loop != null) {
              setState(() {
                isLooping = loop;
              });
            }
            mapPlayers[tag]!.isLooping = isLooping;

            // Volume
            double volume = 100;
            double? volumeValue = map["volume"];
            if (volumeValue != null) {
              setState(() {
                volume = volumeValue;
              });
            }
            mapPlayers[tag]!.originalVolume = volume;

            // Sound
            SoundModel? activeSound;
            String? fullPath = map["fullPath"];

            if (fullPath != null) {
              SoundModel soundModel = await SoundService(campaign: campaign)
                  .getSoundModelByFullPath(fullPath);
              activeSound = soundModel;
            } else {
              activeSound = null;
            }
            mapPlayers[tag]!.soundModel = activeSound;

            // Update Player
            _updatePlayers();
          }
        },
      );
    }
  }

  _updatePlayers() async {
    for (SoundTag tag in mapPlayers.keys) {
      // Loop
      if (mapPlayers[tag]!.isLooping &&
          mapPlayers[tag]!.audioPlayer.loopMode == LoopMode.off) {
        await mapPlayers[tag]!.audioPlayer.setLoopMode(LoopMode.one);
      }
      if (!mapPlayers[tag]!.isLooping &&
          mapPlayers[tag]!.audioPlayer.loopMode != LoopMode.off) {
        await mapPlayers[tag]!.audioPlayer.setLoopMode(LoopMode.off);
      }

      // Volumne
      double calculatedVolume =
          (mapPlayers[tag]!.originalVolume / 100) * (myVolume / 100);
      if (mapPlayers[tag]!.audioPlayer.volume != calculatedVolume) {
        await mapPlayers[tag]!.audioPlayer.setVolume(calculatedVolume);
      }

      // Track
      if (mapPlayers[tag]!.soundModel != null) {
        if (!mapPlayers[tag]!.audioPlayer.playing) {
          await mapPlayers[tag]!
              .audioPlayer
              .setUrl(mapPlayers[tag]!.soundModel!.url);
          await mapPlayers[tag]!.audioPlayer.play();
        }
      } else {
        await mapPlayers[tag]!.audioPlayer.stop();
      }
    }
  }

  void setupCampaignStream() {
    campaignSubscription =
        _campaignService.getCampaignStream(campaign.id).listen(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        Campaign updateCampaign = Campaign.fromMap(snapshot.docs[0].data());
        setState(() {
          campaign = updateCampaign;
        });
      },
    );
  }

  void closeAllStreams() {
    (campaignSubscription != null) ? campaignSubscription!.cancel() : null;
  }
}
