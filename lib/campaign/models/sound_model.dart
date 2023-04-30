import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gm_tools/campaign/helpers/sound_tags.dart';

class SoundModel {
  String name;
  FullMetadata metadata;
  SoundTag tag;
  Reference reference;

  SoundModel({
    required this.name,
    required this.metadata,
    required this.tag,
    required this.reference,
  });
}
