/// Model for storing audio playback settings
/// Includes speed control and looping configurations
class AudioSettings {
  /// Playback speed (0.5x to 2.0x)
  final double speed;
  
  /// Number of times to repeat each individual ayah (0 = no loop, 1+ = repeat count)
  final int ayahLoopCount;
  
  /// Number of times to repeat the entire sequence/range (0 = no loop, 1+ = repeat count)
  final int totalLoopCount;
  
  /// Whether to show advanced audio controls in UI
  final bool showAdvancedControls;

  const AudioSettings({
    this.speed = 1.0,
    this.ayahLoopCount = 0,
    this.totalLoopCount = 0,
    this.showAdvancedControls = false,
  });

  /// Available playback speeds
  static const List<double> availableSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  /// Maximum loop count to prevent infinite loops (except for infinity)
  static const int maxLoopCount = 10;
  
  /// Special value to represent infinite loops
  static const int infiniteLoop = -1;

  /// Validate speed is in available options
  bool get isValidSpeed => availableSpeeds.contains(speed);

  /// Get speed as percentage string (e.g., "1.25x")
  String get speedLabel => '${speed}x';

  /// Get ayah loop description
  String get ayahLoopDescription {
    if (ayahLoopCount == 0) return 'No repeat';
    if (ayahLoopCount == infiniteLoop) return 'Repeat ∞';
    return 'Repeat ${ayahLoopCount}x';
  }

  /// Get total loop description
  String get totalLoopDescription {
    if (totalLoopCount == 0) return 'Play once';
    if (totalLoopCount == infiniteLoop) return 'Repeat all ∞';
    return 'Repeat all ${totalLoopCount}x';
  }

  /// Create a copy with modified values
  AudioSettings copyWith({
    double? speed,
    int? ayahLoopCount,
    int? totalLoopCount,
    bool? showAdvancedControls,
  }) {
    return AudioSettings(
      speed: speed ?? this.speed,
      ayahLoopCount: ayahLoopCount ?? this.ayahLoopCount,
      totalLoopCount: totalLoopCount ?? this.totalLoopCount,
      showAdvancedControls: showAdvancedControls ?? this.showAdvancedControls,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'speed': speed,
      'ayahLoopCount': ayahLoopCount,
      'totalLoopCount': totalLoopCount,
      'showAdvancedControls': showAdvancedControls,
    };
  }

  /// Create from JSON
  factory AudioSettings.fromJson(Map<String, dynamic> json) {
    return AudioSettings(
      speed: (json['speed'] as num?)?.toDouble() ?? 1.0,
      ayahLoopCount: json['ayahLoopCount'] as int? ?? 0,
      totalLoopCount: json['totalLoopCount'] as int? ?? 0,
      showAdvancedControls: json['showAdvancedControls'] as bool? ?? false,
    );
  }

  /// Validate settings and return corrected version if needed
  AudioSettings validate() {
    double validSpeed = speed;
    if (!availableSpeeds.contains(speed)) {
      validSpeed = 1.0; // Default to normal speed
    }

    int validAyahLoops = ayahLoopCount;
    int validTotalLoops = totalLoopCount;
    
    // Allow infinite loop (-1) or values between 0 and maxLoopCount
    if (ayahLoopCount != infiniteLoop) {
      validAyahLoops = ayahLoopCount.clamp(0, maxLoopCount);
    }
    
    if (totalLoopCount != infiniteLoop) {
      validTotalLoops = totalLoopCount.clamp(0, maxLoopCount);
    }

    return AudioSettings(
      speed: validSpeed,
      ayahLoopCount: validAyahLoops,
      totalLoopCount: validTotalLoops,
      showAdvancedControls: showAdvancedControls,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AudioSettings &&
        other.speed == speed &&
        other.ayahLoopCount == ayahLoopCount &&
        other.totalLoopCount == totalLoopCount &&
        other.showAdvancedControls == showAdvancedControls;
  }

  @override
  int get hashCode {
    return Object.hash(speed, ayahLoopCount, totalLoopCount, showAdvancedControls);
  }

  @override
  String toString() {
    return 'AudioSettings(speed: $speed, ayahLoops: $ayahLoopCount, totalLoops: $totalLoopCount, advanced: $showAdvancedControls)';
  }
}