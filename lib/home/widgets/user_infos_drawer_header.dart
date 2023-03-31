import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';

class UserInfosDrawerHeader extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.darkfgreen,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (urlPhotoImage != null)
              ? Image.network(
                  urlPhotoImage!,
                  height: 64,
                )
              : CircleAvatar(
                  radius: 64,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  ),
                ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              color: MyColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Membro desde: $creationDate",
            style: const TextStyle(
              color: MyColors.white,
              fontSize: 12,
            ),
          ),
          Text(
            "Último login: $lastSignin",
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
