/// Represents a single Ayah (verse) in the Quran
/// Each ayah has metadata including its location, audio URL, and qiraat-specific positioning
class Ayah {
  final int surahNumber; // 1-114
  final int ayahNumber; // Starting from 1 for each surah
  final int pageNumber; // Mushaf page number (1-606)
  final String qiraatId; // The qiraat this ayah belongs to
  final String? audioUrl; // Cloud URL to the MP3 file for this ayah
  final bool isAudioDownloaded; // Whether the audio is cached locally
  final String? localAudioPath; // Path to local cached audio file
  
  // For combining multiple parts of an ayah that span multiple lines
  final List<AyahPosition> positions; // Positions of this ayah on the page

  const Ayah({
    required this.surahNumber,
    required this.ayahNumber,
    required this.pageNumber,
    required this.qiraatId,
    this.audioUrl,
    this.isAudioDownloaded = false,
    this.localAudioPath,
    this.positions = const [],
  });

  /// Creates a unique identifier for this ayah
  /// Format: {surahNumber}:{ayahNumber}
  String get ayahKey => '$surahNumber:$ayahNumber';

  /// Creates a unique identifier including qiraat
  /// Format: {qiraatId}_{surahNumber}:{ayahNumber}
  String get fullKey => '${qiraatId}_$ayahKey';

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      surahNumber: json['surahNumber'],
      ayahNumber: json['ayahNumber'],
      pageNumber: json['pageNumber'],
      qiraatId: json['qiraatId'],
      audioUrl: json['audioUrl'],
      isAudioDownloaded: json['isAudioDownloaded'] ?? false,
      localAudioPath: json['localAudioPath'],
      positions: (json['positions'] as List<dynamic>?)
          ?.map((p) => AyahPosition.fromJson(p as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'pageNumber': pageNumber,
      'qiraatId': qiraatId,
      'audioUrl': audioUrl,
      'isAudioDownloaded': isAudioDownloaded,
      'localAudioPath': localAudioPath,
      'positions': positions.map((p) => p.toJson()).toList(),
    };
  }

  Ayah copyWith({
    int? surahNumber,
    int? ayahNumber,
    int? pageNumber,
    String? qiraatId,
    String? audioUrl,
    bool? isAudioDownloaded,
    String? localAudioPath,
    List<AyahPosition>? positions,
  }) {
    return Ayah(
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      pageNumber: pageNumber ?? this.pageNumber,
      qiraatId: qiraatId ?? this.qiraatId,
      audioUrl: audioUrl ?? this.audioUrl,
      isAudioDownloaded: isAudioDownloaded ?? this.isAudioDownloaded,
      localAudioPath: localAudioPath ?? this.localAudioPath,
      positions: positions ?? this.positions,
    );
  }

  @override
  String toString() {
    return 'Ayah(surah: $surahNumber, ayah: $ayahNumber, page: $pageNumber, qiraat: $qiraatId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ayah &&
        other.surahNumber == surahNumber &&
        other.ayahNumber == ayahNumber &&
        other.qiraatId == qiraatId;
  }

  @override
  int get hashCode => Object.hash(surahNumber, ayahNumber, qiraatId);
}

/// Represents the position/bounds of an ayah (or part of an ayah) on a page
/// This allows for ayahs that span multiple lines to be properly detected
class AyahPosition {
  final double x; // X coordinate (0.0 - 1.0 normalized)
  final double y; // Y coordinate (0.0 - 1.0 normalized)
  final double width; // Width (0.0 - 1.0 normalized)
  final double height; // Height (0.0 - 1.0 normalized)
  final int lineNumber; // Which line of the ayah this is (for multi-line ayahs)

  const AyahPosition({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.lineNumber = 0,
  });

  factory AyahPosition.fromJson(Map<String, dynamic> json) {
    return AyahPosition(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      lineNumber: json['lineNumber'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'lineNumber': lineNumber,
    };
  }

  /// Checks if a point (normalized coordinates) is within this position
  bool containsPoint(double px, double py) {
    return px >= x && px <= (x + width) && py >= y && py <= (y + height);
  }

  @override
  String toString() {
    return 'AyahPosition(x: $x, y: $y, w: $width, h: $height, line: $lineNumber)';
  }
}
