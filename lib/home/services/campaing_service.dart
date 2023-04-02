import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gm_tools/models/campaign.dart';
import 'package:uuid/uuid.dart';

class CampaignService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> createCampaign({
    required Uint8List? image,
    required String name,
    required String desc,
  }) async {
    String campaignId = const Uuid().v1();
    String ownerId = _firebaseAuth.currentUser!.uid;
    String ownerName = _firebaseAuth.currentUser!.displayName!;
    String enterCode =
        "${Random().nextInt(8999) + 1000}-${Random().nextInt(8999) + 1000}";

    String? bannerUrl;

    if (image != null) {
      TaskSnapshot snapshot =
          await _firebaseStorage.ref("banners/$campaignId.png").putData(
                image,
                SettableMetadata(contentType: 'image/png'),
              );
      bannerUrl = await snapshot.ref.getDownloadURL();
    }

    Campaign campaign = Campaign(
      id: campaignId,
      ownerId: ownerId,
      ownerName: ownerName,
      enterCode: enterCode,
      guestsId: [],
      name: name,
      description: desc,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      urlBanner: bannerUrl,
    );

    await _firebaseFirestore
        .collection("campaigns")
        .doc(campaignId)
        .set(campaign.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMyCampaignsStream() {
    return _firebaseFirestore
        .collection("campaigns")
        .where("ownerId", isEqualTo: _firebaseAuth.currentUser!.uid)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getOthersCampaignsStream() {
    return _firebaseFirestore
        .collection("campaigns")
        .where("guestsId", arrayContains: _firebaseAuth.currentUser!.uid)
        .snapshots();
  }

  Future<String?> joinCampaignByCode({required String code}) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
        .collection("campaigns")
        .where("enterCode", isEqualTo: code)
        .get();

    if (snapshot.docs.isEmpty) {
      return "O código não é válido.";
    } else {
      Campaign campaign = Campaign.fromMap(snapshot.docs[0].data());
      if (campaign.ownerId == _firebaseAuth.currentUser!.uid) {
        return "Essa campanha é pertence a você.";
      }
      if (campaign.guestsId.contains(_firebaseAuth.currentUser!.uid)) {
        return "Você já faz parte desta campanha.";
      }
      campaign.guestsId.add(_firebaseAuth.currentUser!.uid);
      await _firebaseFirestore
          .collection("campaigns")
          .doc(campaign.id)
          .set(campaign.toMap());
    }

    return null;
  }
}
