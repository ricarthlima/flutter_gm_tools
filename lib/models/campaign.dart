class Campaign {
  String id;
  String ownerId;
  String enterCode;

  String? urlBanner;
  List<String> guestsId;

  String name;
  String description;

  DateTime createdAt;
  DateTime updatedAt;

  Campaign({
    required this.id,
    required this.ownerId,
    required this.enterCode,
    this.urlBanner,
    required this.guestsId,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  Campaign.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        ownerId = map["ownerId"],
        enterCode = map["enterCode"],
        urlBanner = map["urlBanner"],
        guestsId = map["guestsId"],
        name = map["name"],
        description = map["description"],
        createdAt = DateTime.parse(map["createdAt"]),
        updatedAt = DateTime.parse(map["updatedAt"]);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "ownerId": ownerId,
      "enterCode": enterCode,
      "urlBanner": urlBanner,
      "guestsId": guestsId,
      "name": name,
      "description": description,
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString(),
    };
  }
}
