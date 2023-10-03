import 'package:firebase_storage/firebase_storage.dart';

class ImageModel {
  String name;
  String url;
  FullMetadata metadataRaw;
  ImageModel({
    required this.name,
    required this.url,
    required this.metadataRaw,
  });
}
