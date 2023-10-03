import 'package:flutter/material.dart';

import '../../_core/services/campaing_service.dart';

showJoinDialog({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (context) {
      final formKey = GlobalKey<FormState>();
      TextEditingController joinController = TextEditingController();

      String? error;
      bool isLoading = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Insira o código da sala"),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: joinController,
                decoration: const InputDecoration(
                  label: Text("Código"),
                ),
                validator: (value) {
                  if (error != null) {
                    return error;
                  }
                  if (value == null || value.length < 9) {
                    return "O código tem sempre 9 caracteres.";
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    CampaignService()
                        .joinCampaignByCode(code: joinController.text)
                        .then(
                      (String? joinError) {
                        if (joinError != null) {
                          setState(
                            () {
                              error = joinError;
                              isLoading = false;
                            },
                          );
                          formKey.currentState!.validate();
                          error = null;
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    );
                  }
                },
                child: (isLoading)
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      )
                    : const Text("Entrar"),
              ),
            ],
          );
        },
      );
    },
  );
}
