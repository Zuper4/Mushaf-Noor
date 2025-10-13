class Surah {
  final int number;
  final String name;
  final String nameArabic;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final int startPage;
  final int endPage;

  const Surah({
    required this.number,
    required this.name,
    required this.nameArabic,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.startPage,
    required this.endPage,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'],
      name: json['name'],
      nameArabic: json['nameArabic'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      numberOfAyahs: json['numberOfAyahs'],
      startPage: json['startPage'],
      endPage: json['endPage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'nameArabic': nameArabic,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'revelationType': revelationType,
      'numberOfAyahs': numberOfAyahs,
      'startPage': startPage,
      'endPage': endPage,
    };
  }

  // Helper method to get display name based on language
  String getDisplayName(String languageCode) {
    return languageCode == 'ar' ? nameArabic : englishName;
  }

  // Static list of all 114 Surahs (sample - you can complete this)
  static const List<Surah> allSurahs = [
    Surah(
      number: 1,
      name: 'Al-Fatiha',
      nameArabic: 'الفاتحة',
      englishName: 'The Opening',
      englishNameTranslation: 'The Opening',
      revelationType: 'Meccan',
      numberOfAyahs: 7,
      startPage: 1,
      endPage: 1,
    ),
    Surah(
      number: 2,
      name: 'Al-Baqarah',
      nameArabic: 'البقرة',
      englishName: 'The Cow',
      englishNameTranslation: 'The Cow',
      revelationType: 'Medinan',
      numberOfAyahs: 286,
      startPage: 2,
      endPage: 49,
    ),
    Surah(
      number: 3,
      name: 'Ali \'Imran',
      nameArabic: 'آل عمران',
      englishName: 'Family of Imran',
      englishNameTranslation: 'The Family of Imran',
      revelationType: 'Medinan',
      numberOfAyahs: 200,
      startPage: 50,
      endPage: 76,
    ),
    Surah(
      number: 4,
      name: 'An-Nisa',
      nameArabic: 'النساء',
      englishName: 'The Women',
      englishNameTranslation: 'The Women',
      revelationType: 'Medinan',
      numberOfAyahs: 176,
      startPage: 77,
      endPage: 106,
    ),
    Surah(
      number: 5,
      name: 'Al-Ma\'idah',
      nameArabic: 'المائدة',
      englishName: 'The Table Spread',
      englishNameTranslation: 'The Table',
      revelationType: 'Medinan',
      numberOfAyahs: 120,
      startPage: 106,
      endPage: 127,
    ),
    Surah(
      number: 18,
      name: 'Al-Kahf',
      nameArabic: 'الكهف',
      englishName: 'The Cave',
      englishNameTranslation: 'The Cave',
      revelationType: 'Meccan',
      numberOfAyahs: 110,
      startPage: 293,
      endPage: 304,
    ),
    Surah(
      number: 36,
      name: 'Ya-Sin',
      nameArabic: 'يس',
      englishName: 'Ya-Sin',
      englishNameTranslation: 'Ya-Sin',
      revelationType: 'Meccan',
      numberOfAyahs: 83,
      startPage: 440,
      endPage: 445,
    ),
    // Add more surahs as needed
    Surah(
      number: 114,
      name: 'An-Nas',
      nameArabic: 'الناس',
      englishName: 'Mankind',
      englishNameTranslation: 'Mankind',
      revelationType: 'Meccan',
      numberOfAyahs: 6,
      startPage: 604,
      endPage: 604,
    ),
  ];
}