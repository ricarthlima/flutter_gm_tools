import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gm_tools/campaign/helpers/sound_tags.dart';
import 'package:flutter_gm_tools/campaign/models/sound_model.dart';
import 'package:flutter_gm_tools/models/campaign.dart';

class SoundService {
  final Campaign campaign;
  SoundService({required this.campaign});

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

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
      SoundTag tag = SoundTag.others;

      if (metadata.customMetadata != null) {
        if (metadata.customMetadata!["tag"] != null) {
          tag = soundTagFromString(metadata.customMetadata!["tag"]!);
        }
      }

      listSoundModels.add(SoundModel(
        name: name,
        metadata: metadata,
        tag: tag,
        reference: reference,
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
      SoundTag tag = SoundTag.others;

      if (metadata.customMetadata != null) {
        if (metadata.customMetadata!["tag"] != null) {
          tag = soundTagFromString(metadata.customMetadata!["tag"]!);
        }
      }

      listSoundModels.add(SoundModel(
        name: name,
        metadata: metadata,
        tag: tag,
        reference: reference,
      ));
    }

    return listSoundModels;
  }

  Future<void> removeSound(Reference reference) {
    return reference.delete();
  }
}
