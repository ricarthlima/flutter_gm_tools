// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';
import 'package:flutter_gm_tools/_core/show_snackbar.dart';
import 'package:flutter_gm_tools/campaign/helpers/sound_tags.dart';
import 'package:flutter_gm_tools/campaign/models/sound_model.dart';
import 'package:flutter_gm_tools/campaign/services/sound_service.dart';
import 'package:flutter_gm_tools/models/campaign.dart';

class SoundScreen extends StatefulWidget {
  final Campaign campaign;
  const SoundScreen({super.key, required this.campaign});

  @override
  State<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RowSoundTag(
          tag: SoundTag.music,
          campaign: widget.campaign,
        ),
        RowSoundTag(
          tag: SoundTag.ambience,
          campaign: widget.campaign,
        ),
        RowSoundTag(
          tag: SoundTag.effect,
          campaign: widget.campaign,
        ),
        RowSoundTag(
          tag: SoundTag.others,
          campaign: widget.campaign,
        ),
      ],
    );
  }
}

class RowSoundTag extends StatefulWidget {
  final SoundTag tag;
  final Campaign campaign;
  const RowSoundTag({
    super.key,
    required this.tag,
    required this.campaign,
  });

  @override
  State<RowSoundTag> createState() => _RowSoundTagState();
}

class _RowSoundTagState extends State<RowSoundTag> {
  List<SoundModel> listSounds = [];
  bool isLoading = false;
  bool isLooping = false;
  double volume = 100;

  SoundModel? activeSound;

  @override
  void initState() {
    reload();
    setupListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            getSoundTagName(widget.tag),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (!isLoading) {
                      addSound(context);
                    }
                  },
                  child: const Text("Adicionar"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(MyColors.darkRed),
                  ),
                  onPressed: () {
                    stopSound();
                  },
                  child: const Text("Parar"),
                ),
                const SizedBox(width: 16),
                Switch(
                  value: isLooping,
                  onChanged: (value) {
                    toogleLoop(value);
                  },
                ),
                const Text("Loop?"),
                const SizedBox(width: 16),
                const Text("Volume:"),
                const SizedBox(width: 8),
                Slider(
                  value: volume,
                  onChanged: (value) {
                    changeVolume(value);
                  },
                  onChangeEnd: (value) {
                    updateVolume(volume);
                  },
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: volume.toStringAsFixed(0),
                ),
                const SizedBox(width: 16),
                const Text("Tocando agora:   "),
                Text(
                  (activeSound != null) ? activeSound!.name : "------",
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 128,
            child: (isLoading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : (listSounds.isNotEmpty)
                    ? ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(listSounds.length, (index) {
                          SoundModel soundModel = listSounds[index];
                          return Container(
                            width: 100,
                            height: 128,
                            margin: const EdgeInsets.only(right: 16),
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    playSound(soundModel);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: MyColors.grey,
                                      border: Border.all(
                                          width: 3, color: MyColors.darkgrey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.music_note,
                                          size: 32,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          soundModel.name,
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: InkWell(
                                    onTap: () {
                                      removeSound(soundModel);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: MyColors.darkRed,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      )
                    : const Center(
                        child: Text("Ainda nenhum som aqui. Bora subir?"),
                      ),
          ),
        ],
      ),
    );
  }

  addSound(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["mp3"],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      if (fileBytes != null) {
        String fileName = result.files.first.name;
        setState(() {
          isLoading = true;
        });
        await SoundService(campaign: widget.campaign).addSound(
          fileBytes,
          fileName,
          widget.tag,
        );
        setState(() {
          isLoading = false;
        });
        reload();
        showSnackBar(
            context: context,
            mensagem: "Som armazenado com sucesso!",
            isErro: false);
      } else {
        showSnackBar(
            context: context,
            mensagem: "Houve um erro ao selecionar o arquivo.");
      }
    } else {
      showSnackBar(context: context, mensagem: "Nenhum arquivo selecionado.");
    }
  }

  removeSound(SoundModel soundModel) async {
    await soundModel.reference.delete();
    reload();
  }

  reload() async {
    setState(() {
      isLoading = true;
    });

    listSounds = [];

    List<SoundModel> listAllSounds =
        await SoundService(campaign: widget.campaign)
            .getSoundsByTag(widget.tag);

    for (SoundModel soundModel in listAllSounds) {
      listSounds.add(soundModel);
    }

    setState(() {
      isLoading = false;
    });
  }

  playSound(SoundModel soundModel) async {
    SoundService(campaign: widget.campaign).playSound(soundModel);
  }

  stopSound() {
    SoundService(campaign: widget.campaign).stopSound(widget.tag);
  }

  toogleLoop(bool loop) async {
    setState(() {
      isLooping = loop;
    });
    await SoundService(campaign: widget.campaign)
        .setLoop(tag: widget.tag, loop: loop);
  }

  changeVolume(double value) async {
    setState(() {
      volume = value;
    });
  }

  updateVolume(double value) async {
    await SoundService(campaign: widget.campaign).setVolume(
      tag: widget.tag,
      volume: value,
    );
  }

  setupListeners() {
    SoundService(campaign: widget.campaign)
        .listenActiveSounds(widget.tag)
        .listen(
      (DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.data() != null) {
          Map<String, dynamic> map = snapshot.data()!;
          String? fullPath = map["fullPath"];

          if (fullPath != null) {
            SoundService(campaign: widget.campaign)
                .getSoundModelByFullPath(fullPath)
                .then(
              (SoundModel soundModel) {
                setState(
                  () {
                    activeSound = soundModel;
                  },
                );
              },
            );
          } else {
            setState(() {
              activeSound = null;
            });
          }

          bool? loop = map["loop"];
          if (loop != null) {
            setState(() {
              isLooping = loop;
            });
          }

          double? volumeValue = map["volume"];
          if (volumeValue != null) {
            setState(() {
              volume = volumeValue;
            });
          }
        }
      },
    );
  }
}
