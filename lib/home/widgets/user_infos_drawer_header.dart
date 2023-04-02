import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';
import 'package:flutter_gm_tools/auth/services/auth_service.dart';
import 'package:image_picker_web/image_picker_web.dart';

class UserInfosDrawerHeader extends StatefulWidget {
  final String? urlPhotoImage;
  final String name;
  final String creationDate;
  final String lastSignin;
  const UserInfosDrawerHeader({
    super.key,
    this.urlPhotoImage,
    this.name = "...",
    this.creationDate = "...",
    this.lastSignin = "...",
  });

  @override
  State<UserInfosDrawerHeader> createState() => _UserInfosDrawerHeaderState();
}

class _UserInfosDrawerHeaderState extends State<UserInfosDrawerHeader> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.darkfgreen,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 128,
            height: 128,
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 64,
                ),
                (widget.urlPhotoImage != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(64),
                        child: Image.network(
                          widget.urlPhotoImage!,
                          fit: BoxFit.fitWidth,
                          height: 128,
                          width: 128,
                        ),
                      )
                    : Container(),
                Visibility(
                  visible: isLoading,
                  child: const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: MyColors.white,
                    ),
                  ),
                ),
                Container(
                  alignment: (widget.urlPhotoImage != null)
                      ? Alignment.bottomRight
                      : Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      ImagePickerWeb.getImageAsBytes().then(
                        (Uint8List? loadedImage) {
                          if (loadedImage != null) {
                            setState(() {
                              isLoading = true;
                            });
                            AuthService()
                                .uploadUserImage(image: loadedImage)
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          }
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: MyColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.name,
            style: const TextStyle(
              color: MyColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Membro desde: ${widget.creationDate}",
            style: const TextStyle(
              color: MyColors.white,
              fontSize: 12,
            ),
          ),
          Text(
            "Último login: ${widget.lastSignin}",
            style: const TextStyle(
              color: MyColors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
