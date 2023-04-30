// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/show_snackbar.dart';
import 'package:flutter_gm_tools/campaign/helpers/sound_tags.dart';
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
  SoundTag? tagLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                addSound(context, tag: SoundTag.music);
              },
              child: SizedBox(
                width: 150,
                child: Center(
                  child: (tagLoading == SoundTag.music)
                      ? const CircularProgressIndicatorElevatedButton()
                      : const Text(
                          "Adicionar Música",
                        ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addSound(context, tag: SoundTag.ambience);
              },
              child: const Text("Adicionar Ambientação"),
            ),
            ElevatedButton(
              onPressed: () {
                addSound(context, tag: SoundTag.effect);
              },
              child: const Text("Adicionar Efeito"),
            ),
            ElevatedButton(
              onPressed: () {
                addSound(context, tag: SoundTag.others);
              },
              child: const Text("Adicionar Outros"),
            ),
          ],
        ),
      ],
    );
  }

  addSound(BuildContext context, {required SoundTag tag}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["mp3"],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      if (fileBytes != null) {
        String fileName = result.files.first.name;
        setState(() {
          tagLoading = tag;
        });
        await SoundService(campaign: widget.campaign).addSound(
          fileBytes,
          fileName,
          tag,
        );
        setState(() {
          tagLoading = null;
        });
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
}
