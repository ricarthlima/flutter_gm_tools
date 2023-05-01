import 'package:flutter_gm_tools/campaign/models/sound_model.dart';
import 'package:just_audio/just_audio.dart';

class PlayerSoundModel {
  double originalVolume;
  bool isLooping;
  SoundModel? soundModel;
  AudioPlayer audioPlayer;

  PlayerSoundModel({
    required this.isLooping,
    required this.originalVolume,
    required this.soundModel,
    required this.audioPlayer,
  });
}
