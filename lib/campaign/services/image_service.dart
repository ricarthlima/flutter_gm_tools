import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gm_tools/campaign/models/image_model.dart';

import '../../_core/models/campaign.dart';

class ImageService {
  final Campaign campaign;
  ImageService({required this.campaign});

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String _getBaseRef() {
    return "campaign/${campaign.id}/";
  }

  Future<String> addImage({
    required Uint8List file,
    required String fileName,
    required bool isBackground,
  }) async {
    String path = "background";
    if (!isBackground) {
      path = "characters";
    }

    TaskSnapshot snapshot =
        await _firebaseStorage.ref("${_getBaseRef()}$path/$fileName").putData(
              file,
              SettableMetadata(contentType: 'image/png'),
            );

    String url = await snapshot.ref.getDownloadURL();

    return url;
  }

  Future<List<ImageModel>> getAllImages({bool isBackground = true}) async {
    String path = "background";

    if (!isBackground) {
      path = "characters";
    }

    ListResult result =
        await _firebaseStorage.ref("${_getBaseRef()}$path/").listAll();

    List<ImageModel> listImages = [];

    for (Reference reference in result.items) {
      String name = reference.name;
      String url = await reference.getDownloadURL();
      FullMetadata metadata = await reference.getMetadata();

      listImages.add(ImageModel(name: name, url: url, metadataRaw: metadata));
    }

    return listImages;
  }
}
