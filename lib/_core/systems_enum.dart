class SystemsRPG {
  static const String dnd5e = "dnd5e";
  static const String op = "op";

  static String getLongName(String system) {
    if (system == SystemsRPG.dnd5e) {
      return "Dungeons & Dragons - 5e.";
    }

    if (system == SystemsRPG.op) {
      return "Ordem Paranormal";
    }

    return "-";
  }

  static List<String> getAllSystems() {
    return [dnd5e, op];
  }

  static int countSystems() {
    return getAllSystems().length;
  }
}
