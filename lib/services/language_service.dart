enum LanguageCodeEnum {
  // english,
  czech,
}

const String ENGLISH = "en";
const String CZECH = "cs";

extension LanguageExtension on LanguageCodeEnum {
  String getValue() {
    switch (this) {
      // case LanguageCodeEnum.english:
      //   return ENGLISH;
      case LanguageCodeEnum.czech:
        return CZECH;
    }
  }
}

class Language {
  final String name;
  final String country;
  final String languageCode;

  Language(this.name, this.country, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      // Language("English", "US", LanguageCodeEnum.english.getValue()),
      Language("Czech", "CZ", LanguageCodeEnum.czech.getValue()),
    ];
  }
}
