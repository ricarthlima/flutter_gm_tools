class PublicUser {
  String uid;
  String displayName;
  String urlPhoto;

  PublicUser(
      {required this.uid, required this.displayName, required this.urlPhoto});

  PublicUser.fromMap(Map<String, dynamic> map)
      : uid = map["uid"],
        displayName = map["displayName"],
        urlPhoto = map["urlPhoto"];

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "displayName": displayName,
      "urlPhoto": urlPhoto,
    };
  }
}
