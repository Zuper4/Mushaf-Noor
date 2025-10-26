import 'package:flutter_test/flutter_test.dart';
import 'package:mushaf_noor/models/audio_settings.dart';

void main() {
  group('AudioSettings Tests', () {
    test('should create default settings', () {
      const settings = AudioSettings();
      
      expect(settings.speed, 1.0);
      expect(settings.ayahLoopCount, 0);
      expect(settings.totalLoopCount, 0);
      expect(settings.showAdvancedControls, false);
    });

    test('should validate speed correctly', () {
      const validSettings = AudioSettings(speed: 1.5);
      const invalidSettings = AudioSettings(speed: 3.0);
      
      expect(validSettings.isValidSpeed, true);
      expect(invalidSettings.isValidSpeed, false);
      
      final corrected = invalidSettings.validate();
      expect(corrected.speed, 1.0); // Should default to 1.0
    });

    test('should clamp loop counts within valid range', () {
      const settings = AudioSettings(
        ayahLoopCount: 15,  // Over max
        totalLoopCount: -2, // Below allowed (only -1 is allowed for infinite)
      );
      
      final validated = settings.validate();
      expect(validated.ayahLoopCount, AudioSettings.maxLoopCount);
      expect(validated.totalLoopCount, 0); // Should clamp to 0, not -1
    });

    test('should convert to and from JSON correctly', () {
      const original = AudioSettings(
        speed: 1.25,
        ayahLoopCount: 3,
        totalLoopCount: 2,
        showAdvancedControls: true,
      );
      
      final json = original.toJson();
      final recreated = AudioSettings.fromJson(json);
      
      expect(recreated, original);
    });

    test('should create proper labels', () {
      const settings = AudioSettings(
        speed: 1.5,
        ayahLoopCount: 3,
        totalLoopCount: 2,
      );
      
      expect(settings.speedLabel, '1.5x');
      expect(settings.ayahLoopDescription, 'Repeat 3x');
      expect(settings.totalLoopDescription, 'Repeat all 2x');
    });

    test('should handle zero loops properly', () {
      const settings = AudioSettings();
      
      expect(settings.ayahLoopDescription, 'No repeat');
      expect(settings.totalLoopDescription, 'Play once');
    });

    test('should handle infinite loops properly', () {
      const infiniteAyahSettings = AudioSettings(ayahLoopCount: AudioSettings.infiniteLoop);
      const infiniteTotalSettings = AudioSettings(totalLoopCount: AudioSettings.infiniteLoop);
      
      expect(infiniteAyahSettings.ayahLoopDescription, 'Repeat ∞');
      expect(infiniteTotalSettings.totalLoopDescription, 'Repeat all ∞');
      
      // Infinite loops should be preserved during validation
      final validatedAyah = infiniteAyahSettings.validate();
      final validatedTotal = infiniteTotalSettings.validate();
      
      expect(validatedAyah.ayahLoopCount, AudioSettings.infiniteLoop);
      expect(validatedTotal.totalLoopCount, AudioSettings.infiniteLoop);
    });

    test('should create copies with modified values', () {
      const original = AudioSettings(speed: 1.0);
      final modified = original.copyWith(speed: 1.5, ayahLoopCount: 2);
      
      expect(modified.speed, 1.5);
      expect(modified.ayahLoopCount, 2);
      expect(modified.totalLoopCount, 0); // Should remain unchanged
      expect(modified.showAdvancedControls, false); // Should remain unchanged
    });

    test('should contain all expected speeds', () {
      final expectedSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
      expect(AudioSettings.availableSpeeds, expectedSpeeds);
    });
  });
}