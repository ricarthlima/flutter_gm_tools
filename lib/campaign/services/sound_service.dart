import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gm_tools/campaign/helpers/sound_tags.dart';
import 'package:flutter_gm_tools/models/campaign.dart';

class SoundService {
  final Campaign campaign;
  SoundService({required this.campaign});

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  String _getBaseRef() {
    return "campaign/${campaign.id}/";
  }

  Future<String> addSound(Uint8List file, String fileName, SoundTag tag) async {
    TaskSnapshot snapshot =
        await _firebaseStorage.ref(_getBaseRef() + fileName).putData(
              file,
              SettableMetadata(
                contentType: "audio/mpeg",
                customMetadata: {"tag": tag.name},
              ),
            );

    String url = await snapshot.ref.getDownloadURL();

    return url;
  }
}
