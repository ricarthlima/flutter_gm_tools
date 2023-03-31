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
    String enterCode =
        "${Random().nextInt(8999) + 1000}-${Random().nextInt(8999) + 1000}";

    String? bannerUrl;

    if (image != null) {
      TaskSnapshot snapshot =
          await _firebaseStorage.ref("banners/$campaignId.png").putData(image);
      bannerUrl = await snapshot.ref.getDownloadURL();
    }

    Campaign campaign = Campaign(
      id: campaignId,
      ownerId: ownerId,
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
}
