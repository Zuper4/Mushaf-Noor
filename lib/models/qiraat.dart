class Qiraat {
  final String id; // Format: "qari_rawi" (e.g., "asim_hafs")
  final String qariName; // The Qari name (e.g., "Asim")
  final String rawiName; // The Rawi name (e.g., "Hafs")
  final String name; // Combined name (e.g., "Hafs 'an 'Asim")
  final String arabicName;
  final String qariArabicName; // Qari name in Arabic
  final String rawiArabicName; // Rawi name in Arabic
  final String description;
  final String colorCode; // For highlighting differences from Hafs
  final bool isDownloaded;
  final double downloadProgress;
  final int totalPages;
  final String folderPath; // Path to the Qari folder

  Qiraat({
    required this.id,
    required this.qariName,
    required this.rawiName,
    required this.name,
    required this.arabicName,
    required this.qariArabicName,
    required this.rawiArabicName,
    required this.description,
    required this.colorCode,
    required this.folderPath,
    this.isDownloaded = false,
    this.downloadProgress = 0.0,
    this.totalPages = 606, // Standard Mushaf page count
  });

  factory Qiraat.fromJson(Map<String, dynamic> json) {
    return Qiraat(
      id: json['id'],
      qariName: json['qariName'],
      rawiName: json['rawiName'],
      name: json['name'],
      arabicName: json['arabicName'],
      qariArabicName: json['qariArabicName'],
      rawiArabicName: json['rawiArabicName'],
      description: json['description'],
      colorCode: json['colorCode'],
      folderPath: json['folderPath'],
      isDownloaded: json['isDownloaded'] ?? false,
      downloadProgress: json['downloadProgress']?.toDouble() ?? 0.0,
      totalPages: json['totalPages'] ?? 606,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qariName': qariName,
      'rawiName': rawiName,
      'name': name,
      'arabicName': arabicName,
      'qariArabicName': qariArabicName,
      'rawiArabicName': rawiArabicName,
      'description': description,
      'colorCode': colorCode,
      'folderPath': folderPath,
      'isDownloaded': isDownloaded,
      'downloadProgress': downloadProgress,
      'totalPages': totalPages,
    };
  }

  Qiraat copyWith({
    String? id,
    String? qariName,
    String? rawiName,
    String? name,
    String? arabicName,
    String? qariArabicName,
    String? rawiArabicName,
    String? description,
    String? colorCode,
    String? folderPath,
    bool? isDownloaded,
    double? downloadProgress,
    int? totalPages,
  }) {
    return Qiraat(
      id: id ?? this.id,
      qariName: qariName ?? this.qariName,
      rawiName: rawiName ?? this.rawiName,
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      qariArabicName: qariArabicName ?? this.qariArabicName,
      rawiArabicName: rawiArabicName ?? this.rawiArabicName,
      description: description ?? this.description,
      colorCode: colorCode ?? this.colorCode,
      folderPath: folderPath ?? this.folderPath,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}