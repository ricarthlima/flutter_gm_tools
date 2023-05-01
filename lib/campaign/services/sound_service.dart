import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gm_tools/campaign/helpers/sound_tags.dart';
import 'package:flutter_gm_tools/campaign/models/sound_model.dart';
import 'package:flutter_gm_tools/models/campaign.dart';

class SoundService {
  final Campaign campaign;
  SoundService({required this.campaign});

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String _getBaseRef() {
    return "campaign/${campaign.id}/";
  }

  Future<String> addSound(Uint8List file, String fileName, SoundTag tag) async {
    TaskSnapshot snapshot = await _firebaseStorage
        .ref("${_getBaseRef()}${tag.name}/$fileName")
        .putData(
          file,
          SettableMetadata(
            contentType: "audio/mpeg",
            customMetadata: {"tag": tag.name},
          ),
        );

    String url = await snapshot.ref.getDownloadURL();

    return url;
  }

  Future<List<SoundModel>> getAllSounds() async {
    ListResult result = await _firebaseStorage.ref(_getBaseRef()).listAll();

    List<SoundModel> listSoundModels = [];

    for (Reference reference in result.items) {
      String name = reference.name;
      FullMetadata metadata = await reference.getMetadata();
      String url = await reference.getDownloadURL();

      SoundTag tag = SoundTag.others;

      if (metadata.customMetadata != null) {
        if (metadata.customMetadata!["tag"] != null) {
          tag = soundTagFromString(metadata.customMetadata!["tag"]!)!;
        }
      }

      listSoundModels.add(SoundModel(
        name: name,
        metadata: metadata,
        tag: tag,
        reference: reference,
        url: url,
      ));
    }

    return listSoundModels;
  }

  Future<List<SoundModel>> getSoundsByTag(SoundTag tag) async {
    ListResult result =
        await _firebaseStorage.ref("${_getBaseRef()}${tag.name}/").listAll();

    List<SoundModel> listSoundModels = [];

    for (Reference reference in result.items) {
      String name = reference.name;
      FullMetadata metadata = await reference.getMetadata();
      String url = await reference.getDownloadURL();
      SoundTag tag = SoundTag.others;

      if (metadata.customMetadata != null) {
        if (metadata.customMetadata!["tag"] != null) {
          tag = soundTagFromString(metadata.customMetadata!["tag"]!)!;
        }
      }

      listSoundModels.add(SoundModel(
          name: name,
          metadata: metadata,
          tag: tag,
          reference: reference,
          url: url));
    }

    return listSoundModels;
  }

  Future<void> removeSound(Reference reference) {
    return reference.delete();
  }

  Future<void> playSound(SoundModel soundModel) async {
    Map<String, dynamic> map = await getMapByTag(soundModel.tag);
    map["fullPath"] = soundModel.reference.fullPath;
    return updateTag(tag: soundModel.tag, map: map);
  }

  Future<void> stopSound(SoundTag tag) async {
    Map<String, dynamic> map = await getMapByTag(tag);
    map["fullPath"] = null;
    return updateTag(tag: tag, map: map);
  }

  Future<void> setLoop({required SoundTag tag, required bool loop}) async {
    Map<String, dynamic> map = await getMapByTag(tag);
    map["loop"] = loop;
    return updateTag(tag: tag, map: map);
  }

  Future<Map<String, dynamic>> getMapByTag(SoundTag tag) async {
    Map<String, dynamic> map = {};

    var snapshot = await _firebaseFirestore
        .collection("campaigns")
        .doc(campaign.id)
        .collection("realtime")
        .doc("sounds_${tag.name}")
        .get();

    if (snapshot.data() != null) {
      map = snapshot.data()!;
    }

    return map;
  }

  Future<void> updateTag(
      {required SoundTag tag, required Map<String, dynamic> map}) async {
    return _firebaseFirestore
        .collection("campaigns")
        .doc(campaign.id)
        .collection("realtime")
        .doc("sounds_${tag.name}")
        .set(map);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenActiveSounds(
      SoundTag tag) {
    return _firebaseFirestore
        .collection("campaigns")
        .doc(campaign.id)
        .collection("realtime")
        .doc("sounds_${tag.name}")
        .snapshots();
  }

  Future<SoundModel> getSoundModelByFullPath(String fullPath) async {
    Reference reference = _firebaseStorage.ref(fullPath);
    String name = reference.name;
    FullMetadata metadata = await reference.getMetadata();
    String url = await reference.getDownloadURL();
    SoundTag tag = SoundTag.others;

    if (metadata.customMetadata != null) {
      if (metadata.customMetadata!["tag"] != null) {
        tag = soundTagFromString(metadata.customMetadata!["tag"]!)!;
      }
    }

    return SoundModel(
      name: name,
      metadata: metadata,
      tag: tag,
      reference: reference,
      url: url,
    );
  }
}
