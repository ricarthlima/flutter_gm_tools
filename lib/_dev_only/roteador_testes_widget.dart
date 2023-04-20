import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_dev_only/screens_enum.dart';
import 'package:flutter_gm_tools/campaign/screens/campaign_screen.dart';
import 'package:flutter_gm_tools/models/campaign.dart';
import '../roteador_telas.dart';

class RoteadorTesteWidgets extends StatelessWidget {
  final ScreensEnum screen = ScreensEnum.gmview;
  RoteadorTesteWidgets({super.key});

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    switch (screen) {
      case ScreensEnum.roteador:
        return const RoteadorTelas();
      case ScreensEnum.gmview:
        return FutureBuilder(
          future: _firebaseFirestore
              .collection("campaigns")
              .doc("6916f920-d0d8-11ed-bcd6-4d6ed2511c5e")
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return CampaignScreen(
                    campaign: Campaign.fromMap(snapshot.data!.data()!));
              } else {
                return const Center(
                  child: Text("Camapnha não encontrada"),
                );
              }
            }
          },
        );
    }
  }
}
