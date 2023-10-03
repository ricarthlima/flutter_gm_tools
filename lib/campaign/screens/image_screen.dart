import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/models/campaign.dart';
import 'package:flutter_gm_tools/_core/show_snackbar.dart';
import 'package:flutter_gm_tools/campaign/models/image_model.dart';
import 'package:flutter_gm_tools/campaign/services/image_service.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../../home/widgets/create_campaign_dialog.dart';

class ImageScreen extends StatefulWidget {
  final Campaign campaign;
  const ImageScreen({super.key, required this.campaign});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  double heightVis = 56;

  bool isLoadingBackgrounds = false;
  List<ImageModel> _listBackgrounds = [];

  bool isLoadingCharacters = false;
  // ignore: unused_field
  final List<ImageModel> _listCharacters = [];

  @override
  void initState() {
    reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
            duration: const Duration(milliseconds: 750),
            height: heightVis,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Visualização",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        // const Icon(Icons.call_made_rounded),
                        InkWell(
                          onTap: () {
                            setState(() {
                              (heightVis) == 1080
                                  ? heightVis = 56
                                  : heightVis = 1080;
                            });
                          },
                          child: (heightVis) == 1080
                              ? const Icon(Icons.keyboard_arrow_up_rounded)
                              : const Icon(Icons.keyboard_arrow_down_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )),
        const SizedBox(height: 8),
        Row(
          children: [
            Flexible(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: (isLoadingBackgrounds)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Plano de Fundo",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  uploadImage();
                                },
                                child: const Text(
                                    "Subir plano de fundo (1920x1080)"),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            children: List.generate(
                              _listBackgrounds.length,
                              (index) {
                                ImageModel imageModel = _listBackgrounds[index];
                                return Image.network(
                                  imageModel.url,
                                  width: 200,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Personagens",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  uploadImage({bool isBackground = true}) {
    ImagePickerWeb.getImageAsBytes().then((Uint8List? loadedImage) {
      if (loadedImage != null) {
        bool isLoading = false;
        GlobalKey<FormState> key = GlobalKey<FormState>();
        TextEditingController controller = TextEditingController();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text(
                    "Qual o nome dessa imagem?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Form(
                    key: key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.memory(
                          loadedImage,
                          width:
                              min(MediaQuery.of(context).size.width * 0.8, 600),
                        ),
                        TextFormField(
                          controller: controller,
                          validator: (value) {
                            if (value == null || (value.length < 4)) {
                              return "Que nome pequeno, hein.";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (key.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          ImageService(campaign: widget.campaign)
                              .addImage(
                            file: loadedImage,
                            fileName: controller.text,
                            isBackground: isBackground,
                          )
                              .then(
                            (value) {
                              if (isBackground) {
                                reloadBackgrounds();
                              } else {
                                reloadCharacters();
                              }
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                      child: (!isLoading)
                          ? const Text("Enviar")
                          : const CircularProgressIndicatorElevatedButton(),
                    ),
                  ],
                );
              },
            );
          },
        );
      } else {
        showSnackBar(context: context, mensagem: "Nenhuma imagem selecionada.");
      }
    });
  }

  reload() {
    reloadBackgrounds();
    reloadCharacters();
  }

  reloadBackgrounds() async {
    setState(() {
      isLoadingBackgrounds = true;
    });

    _listBackgrounds = [];

    List<ImageModel> listAllBackgrounds =
        await ImageService(campaign: widget.campaign).getAllImages();

    for (ImageModel imageModel in listAllBackgrounds) {
      _listBackgrounds.add(imageModel);
    }

    setState(() {
      isLoadingBackgrounds = false;
    });
  }

  reloadCharacters() async {}
}
