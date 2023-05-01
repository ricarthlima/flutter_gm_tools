enum SoundTag {
  music,
  ambience,
  effect,
  others,
}

String getSoundTagName(SoundTag tag) {
  switch (tag) {
    case SoundTag.music:
      return "Música de Fundo";
    case SoundTag.ambience:
      return "Ambientação";
    case SoundTag.effect:
      return "Efeitos";
    case SoundTag.others:
      return "Outros";
  }
}

SoundTag? soundTagFromString(String nameTage) {
  for (SoundTag tag in SoundTag.values) {
    if (tag.name == nameTage) {
      return tag;
    }
  }

  return null;
}
