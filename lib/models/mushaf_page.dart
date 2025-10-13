class MushafPage {
  final int pageNumber;
  final int surahNumber;
  final String surahName;
  final String surahNameArabic;
  final int juzNumber;
  final List<String> ayahs;
  final String? imageUrl; // For PDF page images
  final String? localImagePath;
  final bool isDownloaded;

  MushafPage({
    required this.pageNumber,
    required this.surahNumber,
    required this.surahName,
    required this.surahNameArabic,
    required this.juzNumber,
    required this.ayahs,
    this.imageUrl,
    this.localImagePath,
    this.isDownloaded = false,
  });

  factory MushafPage.fromJson(Map<String, dynamic> json) {
    return MushafPage(
      pageNumber: json['pageNumber'],
      surahNumber: json['surahNumber'],
      surahName: json['surahName'],
      surahNameArabic: json['surahNameArabic'],
      juzNumber: json['juzNumber'],
      ayahs: List<String>.from(json['ayahs']),
      imageUrl: json['imageUrl'],
      localImagePath: json['localImagePath'],
      isDownloaded: json['isDownloaded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'surahNumber': surahNumber,
      'surahName': surahName,
      'surahNameArabic': surahNameArabic,
      'juzNumber': juzNumber,
      'ayahs': ayahs,
      'imageUrl': imageUrl,
      'localImagePath': localImagePath,
      'isDownloaded': isDownloaded,
    };
  }

  MushafPage copyWith({
    int? pageNumber,
    int? surahNumber,
    String? surahName,
    String? surahNameArabic,
    int? juzNumber,
    List<String>? ayahs,
    String? imageUrl,
    String? localImagePath,
    bool? isDownloaded,
  }) {
    return MushafPage(
      pageNumber: pageNumber ?? this.pageNumber,
      surahNumber: surahNumber ?? this.surahNumber,
      surahName: surahName ?? this.surahName,
      surahNameArabic: surahNameArabic ?? this.surahNameArabic,
      juzNumber: juzNumber ?? this.juzNumber,
      ayahs: ayahs ?? this.ayahs,
      imageUrl: imageUrl ?? this.imageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}