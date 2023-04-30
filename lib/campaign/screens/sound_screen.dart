// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';
import 'package:flutter_gm_tools/_core/show_snackbar.dart';
import 'package:flutter_gm_tools/campaign/helpers/sound_tags.dart';
import 'package:flutter_gm_tools/campaign/models/sound_model.dart';
import 'package:flutter_gm_tools/campaign/services/sound_service.dart';
import 'package:flutter_gm_tools/home/widgets/create_campaign_dialog.dart';
import 'package:flutter_gm_tools/models/campaign.dart';

class SoundScreen extends StatefulWidget {
  final Campaign campaign;
  const SoundScreen({super.key, required this.campaign});

  @override
  State<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {
  bool isLoading = true;
  Map<SoundTag, List<SoundModel>> dbSounds = {};

  @override
  void initState() {
    reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? const Center(
            child: CircularProgressIndicatorElevatedButton(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RowSoundTag(
                tag: SoundTag.music,
                campaign: widget.campaign,
                listSounds: dbSounds[SoundTag.music],
                reload: reload,
              ),
              RowSoundTag(
                tag: SoundTag.ambience,
                campaign: widget.campaign,
                listSounds: dbSounds[SoundTag.ambience],
                reload: reload,
              ),
              RowSoundTag(
                tag: SoundTag.effect,
                campaign: widget.campaign,
                listSounds: dbSounds[SoundTag.effect],
                reload: reload,
              ),
              RowSoundTag(
                tag: SoundTag.others,
                campaign: widget.campaign,
                listSounds: dbSounds[SoundTag.others],
                reload: reload,
              ),
            ],
          );
  }

  reload() async {
    setState(() {
      isLoading = true;
    });

    dbSounds = {};

    List<SoundModel> listAllSounds =
        await SoundService(campaign: widget.campaign).getAllSounds();

    for (SoundModel soundModel in listAllSounds) {
      if (dbSounds[soundModel.tag] == null) {
        dbSounds[soundModel.tag] = [];
      }

      dbSounds[soundModel.tag]!.add(soundModel);
    }

    setState(() {
      isLoading = false;
    });
  }
}

class RowSoundTag extends StatefulWidget {
  final SoundTag tag;
  final Campaign campaign;
  final List<SoundModel>? listSounds;
  final Function reload;
  const RowSoundTag(
      {super.key,
      required this.tag,
      required this.campaign,
      required this.listSounds,
      required this.reload});

  @override
  State<RowSoundTag> createState() => _RowSoundTagState();
}

class _RowSoundTagState extends State<RowSoundTag> {
  bool isLoading = false;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getSoundTagName(widget.tag),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FloatingActionButton(
                elevation: 0,
                onPressed: () {
                  if (!isLoading) {
                    addSound(context);
                  }
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 128,
            child: (isLoading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : (widget.listSounds != null)
                    ? ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            List.generate(widget.listSounds!.length, (index) {
                          SoundModel soundModel = widget.listSounds![index];
                          return Container(
                            width: 100,
                            height: 128,
                            margin: const EdgeInsets.only(right: 16),
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {},
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
        widget.reload();
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
    widget.reload();
  }
}
