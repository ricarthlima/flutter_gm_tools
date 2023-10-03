import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';
import 'package:flutter_gm_tools/_core/services/campaing_service.dart';
import 'package:image_picker_web/image_picker_web.dart';

showCreateCampaignDialog({required BuildContext context}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      final formKey = GlobalKey<FormState>();

      Uint8List? image;
      TextEditingController nameController = TextEditingController();
      TextEditingController descController = TextEditingController();

      bool isLoading = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            scrollable: true,
            actionsPadding: const EdgeInsets.only(bottom: 32),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Criar nova campanha",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            content: SizedBox(
              width: 350,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    (image != null)
                        ? Image.memory(image!)
                        : Container(
                            height: 100,
                            color: MyColors.grey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    ImagePickerWeb.getImageAsBytes().then(
                                      (Uint8List? loadedImage) {
                                        if (loadedImage != null) {
                                          setState(
                                            () {
                                              image = loadedImage;
                                            },
                                          );
                                        }
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.upload),
                                ),
                                const Text("Insira um banner. (1920x540)"),
                              ],
                            ),
                          ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: nameController,
                      maxLength: 40,
                      decoration: const InputDecoration(
                        label: Text("Nome da campanha:"),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "O nome da campanha é obrigatório.";
                        }
                        if (value.length < 5) {
                          return "O nome da campanha deve ter pelo menos 5 caracteres.";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: descController,
                      maxLength: 200,
                      maxLines: null,
                      decoration: const InputDecoration(
                        label: Text("Breve descrição:"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: () {
                  String name = nameController.text;
                  String desc = descController.text;

                  if (formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    CampaignService()
                        .createCampaign(
                          image: image,
                          name: name,
                          desc: desc,
                        )
                        .then(
                          (value) => Navigator.pop(context),
                        );
                  }
                },
                child: (isLoading)
                    ? const CircularProgressIndicatorElevatedButton()
                    : const Text("Crie um novo mundo!"),
              )
            ],
          );
        },
      );
    },
  );
}

class CircularProgressIndicatorElevatedButton extends StatelessWidget {
  const CircularProgressIndicatorElevatedButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 16,
      width: 16,
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}
