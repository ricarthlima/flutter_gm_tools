import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';
import 'package:flutter_gm_tools/auth/services/auth_service.dart';
import 'package:flutter_gm_tools/_core/services/campaing_service.dart';
import 'package:flutter_gm_tools/home/widgets/campaign_wrap_widget.dart';
import 'package:flutter_gm_tools/home/widgets/create_campaign_dialog.dart';
import 'package:flutter_gm_tools/home/widgets/join_dialog.dart';
import 'package:flutter_gm_tools/home/widgets/user_infos_drawer_header.dart';
import 'package:flutter_gm_tools/_core/models/campaign.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  HomeScreen({super.key, required this.user});

  final CampaignService campaignService = CampaignService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GM Tools - Campanhas"),
      ),
      drawer: Drawer(
        width: min(512, MediaQuery.of(context).size.width),
        child: ListView(children: [
          UserInfosDrawerHeader(
            urlPhotoImage: user.photoURL,
            name: user.displayName!,
            creationDate:
                user.metadata.creationTime!.toString().substring(0, 10),
            lastSignin:
                user.metadata.lastSignInTime!.toString().substring(0, 10),
          ),
          const ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Minha conta"),
          ),
          ListTile(
            onTap: () {
              AuthService().deslogar();
            },
            leading: const Icon(Icons.logout),
            title: const Text("Sair"),
          ),
        ]),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              "assets/cleric.png",
              color: Colors.white.withOpacity(0.6),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: MyColors.grey,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      joinButtonClicked(context);
                    },
                    child: const Text("Juntar-se à campanha"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      createCampaignClicked(context);
                    },
                    child: const Text("Criar uma campanha"),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          '"Para qual maravilhoso mundo embarcaremos hoje?"',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "MINHAS CAMPANHAS",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder(
                    stream: campaignService.getMyCampaignsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (snapshot.data!.docs.isEmpty) {
                          return Container(
                            height: 200,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                                "Ainda nenhuma campanha! Vamos criar uma nova?"),
                          );
                        } else {
                          List<Campaign> listCampaing = [];

                          for (var doc in snapshot.data!.docs) {
                            listCampaing.add(Campaign.fromMap(doc.data()));
                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                listCampaing.length,
                                (index) => CampaignWrapWidget(
                                  campaign: listCampaing[index],
                                ),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    "OUTRAS CAMPANHAS",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder(
                    stream: campaignService.getOthersCampaignsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (snapshot.data!.docs.isEmpty) {
                          return Container(
                            alignment: Alignment.centerLeft,
                            height: 200,
                            child: const Text(
                                "Hey! Procure amigos para jogar com você!"),
                          );
                        } else {
                          List<Campaign> listCampaing = [];

                          for (var doc in snapshot.data!.docs) {
                            listCampaing.add(Campaign.fromMap(doc.data()));
                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                listCampaing.length,
                                (index) => CampaignWrapWidget(
                                  campaign: listCampaing[index],
                                ),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  joinButtonClicked(BuildContext context) {
    showJoinDialog(context: context);
  }

  createCampaignClicked(BuildContext context) {
    showCreateCampaignDialog(context: context);
  }
}
