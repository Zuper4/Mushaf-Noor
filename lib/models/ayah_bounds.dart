import 'ayah.dart';

/// Represents a mapping of all ayahs on a specific page for a specific qiraat
/// This is used to determine which ayah was tapped based on coordinates
class PageAyahBounds {
  final int pageNumber;
  final String qiraatId;
  final List<AyahBoundInfo> ayahs;

  const PageAyahBounds({
    required this.pageNumber,
    required this.qiraatId,
    required this.ayahs,
  });

  factory PageAyahBounds.fromJson(Map<String, dynamic> json) {
    return PageAyahBounds(
      pageNumber: json['pageNumber'],
      qiraatId: json['qiraatId'],
      ayahs: (json['ayahs'] as List<dynamic>)
          .map((a) => AyahBoundInfo.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'qiraatId': qiraatId,
      'ayahs': ayahs.map((a) => a.toJson()).toList(),
    };
  }

  /// Finds which ayah was tapped based on normalized coordinates (0.0 - 1.0)
  AyahBoundInfo? findAyahAtPoint(double x, double y) {
    for (final ayahBound in ayahs) {
      if (ayahBound.containsPoint(x, y)) {
        return ayahBound;
      }
    }
    return null;
  }
}

/// Contains the full information about an ayah's bounds on a page
/// Including all its positions if it spans multiple lines
class AyahBoundInfo {
  final int surahNumber;
  final int ayahNumber;
  final List<AyahPosition> positions; // Can have multiple positions for multi-line ayahs
  
  const AyahBoundInfo({
    required this.surahNumber,
    required this.ayahNumber,
    required this.positions,
  });

  String get ayahKey => '$surahNumber:$ayahNumber';

  factory AyahBoundInfo.fromJson(Map<String, dynamic> json) {
    return AyahBoundInfo(
      surahNumber: json['surahNumber'],
      ayahNumber: json['ayahNumber'],
      positions: (json['positions'] as List<dynamic>)
          .map((p) => AyahPosition.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'positions': positions.map((p) => p.toJson()).toList(),
    };
  }

  /// Checks if a point is within any of the positions of this ayah
  bool containsPoint(double x, double y) {
    return positions.any((pos) => pos.containsPoint(x, y));
  }

  @override
  String toString() {
    return 'AyahBoundInfo(surah: $surahNumber, ayah: $ayahNumber, positions: ${positions.length})';
  }
}

/// Metadata about ayah bounds data for a qiraat
/// This helps track if bounds data is available and downloaded
class QiraatBoundsMetadata {
  final String qiraatId;
  final bool isBoundsDataAvailable; // Whether bounds mapping exists for this qiraat
  final bool isBoundsDataDownloaded; // Whether it's cached locally
  final String? cloudBoundsUrl; // URL to download the bounds data JSON
  final DateTime? lastUpdated;

  const QiraatBoundsMetadata({
    required this.qiraatId,
    this.isBoundsDataAvailable = false,
    this.isBoundsDataDownloaded = false,
    this.cloudBoundsUrl,
    this.lastUpdated,
  });

  factory QiraatBoundsMetadata.fromJson(Map<String, dynamic> json) {
    return QiraatBoundsMetadata(
      qiraatId: json['qiraatId'],
      isBoundsDataAvailable: json['isBoundsDataAvailable'] ?? false,
      isBoundsDataDownloaded: json['isBoundsDataDownloaded'] ?? false,
      cloudBoundsUrl: json['cloudBoundsUrl'],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qiraatId': qiraatId,
      'isBoundsDataAvailable': isBoundsDataAvailable,
      'isBoundsDataDownloaded': isBoundsDataDownloaded,
      'cloudBoundsUrl': cloudBoundsUrl,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  QiraatBoundsMetadata copyWith({
    String? qiraatId,
    bool? isBoundsDataAvailable,
    bool? isBoundsDataDownloaded,
    String? cloudBoundsUrl,
    DateTime? lastUpdated,
  }) {
    return QiraatBoundsMetadata(
      qiraatId: qiraatId ?? this.qiraatId,
      isBoundsDataAvailable: isBoundsDataAvailable ?? this.isBoundsDataAvailable,
      isBoundsDataDownloaded: isBoundsDataDownloaded ?? this.isBoundsDataDownloaded,
      cloudBoundsUrl: cloudBoundsUrl ?? this.cloudBoundsUrl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
