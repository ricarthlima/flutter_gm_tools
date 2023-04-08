import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/public_user.dart';

Future<String?> checkOwnerImage(String ownerId) async {
  DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection("users").doc(ownerId).get();

  if (snapshot.data() != null && snapshot.data()!.isNotEmpty) {
    PublicUser user = PublicUser.fromMap(snapshot.data()!);
    if (user.urlPhoto != "") {
      return user.urlPhoto;
    }
  }

  return null;
}
