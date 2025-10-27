import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import '../models/ayah.dart';
import '../models/audio_settings.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Service for managing audio playback of Quranic ayahs
/// Handles streaming from cloud storage and local caching
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final Dio _dio = Dio();
  
  Ayah? _currentAyah;
  bool _isInitialized = false;
  double _currentSpeed = 1.0;

  // Getters for audio state
  AudioPlayer get player => _audioPlayer;
  Ayah? get currentAyah => _currentAyah;
  bool get isPlaying => _audioPlayer.playing;
  double get currentSpeed => _currentSpeed;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  /// Initialize audio session
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));
      
      // Ensure loop mode is OFF for sequential playback
      await _audioPlayer.setLoopMode(LoopMode.off);
      
      // Enable skipSilence to improve audio quality at different speeds
      // This helps reduce artifacts and vibrations during speed changes
      await _audioPlayer.setSkipSilenceEnabled(true);
      
      // Set volume to 1.0 (full) for consistent playback
      await _audioPlayer.setVolume(1.0);
      
      // Handle audio interruptions
      session.interruptionEventStream.listen((event) {
        if (event.begin) {
          // Pause when interrupted (e.g., phone call)
          _audioPlayer.pause();
        }
      });

      // Handle becoming noisy (e.g., headphones unplugged)
      session.becomingNoisyEventStream.listen((_) {
        _audioPlayer.pause();
      });

      _isInitialized = true;
      debugPrint('AudioService initialized successfully with optimized settings');
    } catch (e) {
      debugPrint('Error initializing AudioService: $e');
    }
  }

  /// Play an ayah's audio
  /// Will stream from cloud if not cached, or play from local cache
  Future<void> playAyah(Ayah ayah) async {
    try {
      await initialize();
      
      _currentAyah = ayah;
      
      // Check if audio is cached locally
      if (ayah.isAudioDownloaded && ayah.localAudioPath != null) {
        final file = File(ayah.localAudioPath!);
        if (await file.exists()) {
          await _audioPlayer.setFilePath(ayah.localAudioPath!);
          // Restore speed and pitch settings after loading new audio
          await _audioPlayer.setPitch(1.0); // Maintain original pitch
          await _audioPlayer.setSpeed(_currentSpeed);
          await _audioPlayer.play();
          debugPrint('Playing cached audio for ${ayah.ayahKey} at ${_currentSpeed}x speed with pitch correction');
          return;
        }
      }

      // Stream from cloud
      if (ayah.audioUrl != null && ayah.audioUrl!.isNotEmpty) {
        await _audioPlayer.setUrl(ayah.audioUrl!);
        // Restore speed and pitch settings after loading new audio
        await _audioPlayer.setPitch(1.0); // Maintain original pitch
        await _audioPlayer.setSpeed(_currentSpeed);
        await _audioPlayer.play();
        debugPrint('Streaming audio for ${ayah.ayahKey} from ${ayah.audioUrl} at ${_currentSpeed}x speed with pitch correction');
      } else {
        debugPrint('No audio URL available for ${ayah.ayahKey}');
      }
    } catch (e) {
      debugPrint('Error playing ayah audio: $e');
      rethrow;
    }
  }

  /// Pause current playback
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  /// Resume playback
  Future<void> resume() async {
    await _audioPlayer.play();
  }

  /// Stop playback and reset
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentAyah = null;
  }

  /// Seek to a specific position
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// Set playback speed with better audio quality
  Future<void> setSpeed(double speed) async {
    if (!AudioSettings.availableSpeeds.contains(speed)) {
      debugPrint('Invalid speed: $speed. Using 1.0 instead.');
      speed = 1.0;
    }
    
    try {
      // CRITICAL: Set pitch to 1.0 BEFORE changing speed
      // This maintains natural voice quality and prevents the "chipmunk effect"
      // and vibrations during speed changes, especially on elongated sounds (mad)
      await _audioPlayer.setPitch(1.0);
      
      // Increased delay to 150ms to allow pitch processing to fully stabilize
      // This significantly reduces vibrations/artifacts on elongated vowels
      await Future.delayed(const Duration(milliseconds: 150));
      
      // Now set the speed - the pitch correction will prevent artifacts
      // Android's audio processor handles this more smoothly when pitch is locked
      await _audioPlayer.setSpeed(speed);
      
      // Additional short delay after speed change for final stabilization
      await Future.delayed(const Duration(milliseconds: 50));
      
      _currentSpeed = speed;
      debugPrint('AudioService: Speed set to ${speed}x with extended pitch stabilization (150ms delay)');
    } catch (e) {
      debugPrint('Error setting playback speed: $e');
      // Fallback: try setting speed directly without delay
      try {
        await _audioPlayer.setPitch(1.0);
        await _audioPlayer.setSpeed(speed);
        _currentSpeed = speed;
        debugPrint('AudioService: Speed set to ${speed}x (fallback)');
      } catch (e2) {
        debugPrint('Error setting playback speed (fallback): $e2');
        rethrow;
      }
    }
  }

  /// Get current playback speed
  double getSpeed() {
    return _currentSpeed;
  }

  /// Download audio for offline playback
  Future<String?> downloadAyahAudio(Ayah ayah) async {
    if (ayah.audioUrl == null || ayah.audioUrl!.isEmpty) {
      debugPrint('No audio URL to download for ${ayah.ayahKey}');
      return null;
    }

    try {
      final dir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${dir.path}/audio/${ayah.qiraatId}');
      
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }

      final filename = '${ayah.surahNumber}_${ayah.ayahNumber}.mp3';
      final savePath = '${audioDir.path}/$filename';
      
      // Check if already downloaded
      final file = File(savePath);
      if (await file.exists()) {
        debugPrint('Audio already downloaded: $savePath');
        return savePath;
      }

      // Download the file
      await _dio.download(
        ayah.audioUrl!,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            debugPrint('Downloading ${ayah.ayahKey}: $progress%');
          }
        },
      );

      debugPrint('Audio downloaded successfully: $savePath');
      return savePath;
    } catch (e) {
      debugPrint('Error downloading ayah audio: $e');
      return null;
    }
  }

  /// Delete cached audio for an ayah
  Future<bool> deleteCachedAudio(Ayah ayah) async {
    if (ayah.localAudioPath == null) return false;

    try {
      final file = File(ayah.localAudioPath!);
      if (await file.exists()) {
        await file.delete();
        debugPrint('Deleted cached audio: ${ayah.localAudioPath}');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting cached audio: $e');
      return false;
    }
  }

  /// Check if audio file exists locally
  Future<bool> isAudioCached(String localPath) async {
    try {
      final file = File(localPath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get the size of cached audio for a qiraat
  Future<int> getCachedAudioSize(String qiraatId) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${dir.path}/audio/$qiraatId');
      
      if (!await audioDir.exists()) return 0;

      int totalSize = 0;
      await for (final entity in audioDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      return totalSize;
    } catch (e) {
      debugPrint('Error calculating cached audio size: $e');
      return 0;
    }
  }

  /// Clear all cached audio for a qiraat
  Future<void> clearCachedAudio(String qiraatId) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${dir.path}/audio/$qiraatId');
      
      if (await audioDir.exists()) {
        await audioDir.delete(recursive: true);
        debugPrint('Cleared cached audio for $qiraatId');
      }
    } catch (e) {
      debugPrint('Error clearing cached audio: $e');
    }
  }

  /// Dispose of resources
  Future<void> dispose() async {
    await _audioPlayer.dispose();
    _isInitialized = false;
  }
}
