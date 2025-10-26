import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/ayah.dart';
import '../models/audio_settings.dart';
import '../services/audio_service.dart';
import '../services/database_service.dart';

/// Provider for managing audio playback state across the app
class AudioProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();
  final DatabaseService _databaseService = DatabaseService();

  Ayah? _currentAyah;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration? _duration;

  // Sequential playback state
  List<Ayah> _playbackQueue = [];
  int _currentQueueIndex = 0;
  bool _isPlayingQueue = false;

  // Audio settings and looping state
  AudioSettings _audioSettings = const AudioSettings();
  int _currentAyahLoop = 0;  // Current loop count for the current ayah
  int _currentTotalLoop = 0; // Current loop count for the entire sequence

  // Getters
  Ayah? get currentAyah => _currentAyah;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration? get duration => _duration;
  bool get hasAudio => _currentAyah != null;
  bool get isPlayingQueue => _isPlayingQueue;
  List<Ayah> get playbackQueue => _playbackQueue;
  int get currentQueueIndex => _currentQueueIndex;
  AudioSettings get audioSettings => _audioSettings;
  int get currentAyahLoop => _currentAyahLoop;
  int get currentTotalLoop => _currentTotalLoop;

  AudioProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _audioService.initialize();
    await _loadAudioSettings();
    _setupListeners();
  }

  /// Load audio settings from storage
  Future<void> _loadAudioSettings() async {
    try {
      final settingsJson = await _databaseService.getSetting('audio_settings');
      if (settingsJson != null && settingsJson.isNotEmpty) {
        // Parse the JSON string
        final settingsMap = Map<String, dynamic>.from(
          jsonDecode(settingsJson) as Map
        );
        _audioSettings = AudioSettings.fromJson(settingsMap).validate();
        debugPrint('AudioProvider: Loaded settings - $_audioSettings');
        
        // Apply loaded speed setting
        await _audioService.setSpeed(_audioSettings.speed);
      }
    } catch (e) {
      debugPrint('AudioProvider: Error loading settings - $e, using defaults');
      _audioSettings = const AudioSettings();
    }
  }

  /// Save audio settings to storage
  Future<void> _saveAudioSettings() async {
    try {
      final settingsJson = jsonEncode(_audioSettings.toJson());
      await _databaseService.saveSetting('audio_settings', settingsJson);
      debugPrint('AudioProvider: Saved settings - $_audioSettings');
    } catch (e) {
      debugPrint('AudioProvider: Error saving settings - $e');
    }
  }

  void _setupListeners() {
    // Listen to player state changes
    _audioService.playerStateStream.listen((state) {
      debugPrint('AudioProvider: Player state changed - playing: ${state.playing}, processingState: ${state.processingState}');
      
      _isPlaying = state.playing;
      _isLoading = state.processingState == ProcessingState.loading ||
                   state.processingState == ProcessingState.buffering;
      
      // Clear error when successfully playing
      if (state.playing && _errorMessage != null) {
        _errorMessage = null;
      }

      // Handle completion for sequential playback and looping
      if (state.processingState == ProcessingState.completed && _currentAyah != null) {
        debugPrint('AudioProvider: Ayah completed. Current ayah loop: $_currentAyahLoop, Settings: ${_audioSettings.ayahLoopCount}');
        
        // Check if we need to loop the current ayah
        if (_audioSettings.ayahLoopCount == AudioSettings.infiniteLoop || 
            _currentAyahLoop < _audioSettings.ayahLoopCount) {
          _currentAyahLoop++;
          debugPrint('AudioProvider: Looping current ayah (${_currentAyahLoop}/${_audioSettings.ayahLoopCount == AudioSettings.infiniteLoop ? "∞" : _audioSettings.ayahLoopCount})');
          if (_currentAyah != null) {
            _replayCurrentAyah();
          }
          return;
        }
        
        // Reset ayah loop count for next ayah
        _currentAyahLoop = 0;
        
        // Handle queue progression if playing a queue
        if (_isPlayingQueue) {
          debugPrint('AudioProvider: Playing next in queue. Queue: ${_playbackQueue.length}, Index: $_currentQueueIndex');
          _playNextInQueue();
        }
      }
      
      notifyListeners();
    });

    // Listen to position changes
    _audioService.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    // Listen to duration changes
    _audioService.durationStream.listen((dur) {
      _duration = dur;
      notifyListeners();
    });
  }

  /// Update audio settings
  Future<void> updateAudioSettings(AudioSettings settings) async {
    _audioSettings = settings.validate();
    
    // Apply speed change immediately if audio is loaded
    if (_currentAyah != null) {
      try {
        await _audioService.setSpeed(_audioSettings.speed);
      } catch (e) {
        _errorMessage = 'Failed to change speed: ${e.toString()}';
      }
    }
    
    // Save settings to storage
    await _saveAudioSettings();
    
    notifyListeners();
  }

  /// Set playback speed
  Future<void> setPlaybackSpeed(double speed) async {
    final newSettings = _audioSettings.copyWith(speed: speed);
    await updateAudioSettings(newSettings);
  }

  /// Set ayah loop count
  Future<void> setAyahLoopCount(int count) async {
    // Allow infinite loop (-1) or clamp to valid range
    int validCount = count;
    if (count != AudioSettings.infiniteLoop) {
      validCount = count.clamp(0, AudioSettings.maxLoopCount);
    }
    
    final newSettings = _audioSettings.copyWith(ayahLoopCount: validCount);
    await updateAudioSettings(newSettings);
  }

  /// Set total loop count
  Future<void> setTotalLoopCount(int count) async {
    // Allow infinite loop (-1) or clamp to valid range
    int validCount = count;
    if (count != AudioSettings.infiniteLoop) {
      validCount = count.clamp(0, AudioSettings.maxLoopCount);
    }
    
    final newSettings = _audioSettings.copyWith(totalLoopCount: validCount);
    await updateAudioSettings(newSettings);
  }

  /// Toggle advanced controls visibility
  void toggleAdvancedControls() {
    _audioSettings = _audioSettings.copyWith(
      showAdvancedControls: !_audioSettings.showAdvancedControls
    );
    _saveAudioSettings(); // Save the preference
    notifyListeners();
  }
  Future<void> playAyah(Ayah ayah, {bool fromQueue = false}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      _currentAyah = ayah;
      
      // Only stop queue playback if this is NOT from the queue
      if (!fromQueue) {
        _isPlayingQueue = false;
        _playbackQueue = [];
        _currentQueueIndex = 0;
        _currentTotalLoop = 0; // Reset total loop counter for new playback
      }
      
      // Reset ayah loop counter for new ayah
      _currentAyahLoop = 0;
      
      notifyListeners();

      await _audioService.playAyah(ayah);
      
      // Apply current speed setting
      await _audioService.setSpeed(_audioSettings.speed);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to play audio: ${e.toString()}';
      debugPrint('Error in playAyah: $e');
      notifyListeners();
    }
  }

  /// Replay the current ayah (for looping)
  Future<void> _replayCurrentAyah() async {
    if (_currentAyah == null) return;
    
    try {
      await _audioService.playAyah(_currentAyah!);
      await _audioService.setSpeed(_audioSettings.speed);
    } catch (e) {
      _errorMessage = 'Failed to replay ayah: ${e.toString()}';
      debugPrint('Error in _replayCurrentAyah: $e');
      notifyListeners();
    }
  }

  /// Play a range of ayahs sequentially
  Future<void> playAyahRange(List<Ayah> ayahs) async {
    if (ayahs.isEmpty) return;

    debugPrint('AudioProvider: Starting playback queue with ${ayahs.length} ayahs');
    _playbackQueue = ayahs;
    _currentQueueIndex = 0;
    _isPlayingQueue = true;
    _currentTotalLoop = 0; // Reset total loop counter
    
    try {
      debugPrint('AudioProvider: Playing first ayah in queue: ${ayahs[0].ayahKey}');
      await playAyah(ayahs[0], fromQueue: true);
    } catch (e) {
      _isPlayingQueue = false;
      debugPrint('Error starting ayah range playback: $e');
      notifyListeners();
    }
  }

  /// Play next ayah in the queue
  Future<void> _playNextInQueue() async {
    if (!_isPlayingQueue || _playbackQueue.isEmpty) return;

    _currentQueueIndex++;
    
    if (_currentQueueIndex >= _playbackQueue.length) {
      // Reached end of queue - check if we need to loop the entire sequence
      if (_audioSettings.totalLoopCount == AudioSettings.infiniteLoop || 
          _currentTotalLoop < _audioSettings.totalLoopCount) {
        _currentTotalLoop++;
        _currentQueueIndex = 0;
        debugPrint('AudioProvider: Looping entire sequence (${_currentTotalLoop}/${_audioSettings.totalLoopCount == AudioSettings.infiniteLoop ? "∞" : _audioSettings.totalLoopCount})');
        
        // Restart from the first ayah
        try {
          final firstAyah = _playbackQueue[0];
          _currentAyah = firstAyah;
          _currentAyahLoop = 0; // Reset ayah loop for new cycle
          notifyListeners();
          
          await _audioService.playAyah(firstAyah);
          await _audioService.setSpeed(_audioSettings.speed);
        } catch (e) {
          debugPrint('Error restarting sequence: $e');
          _isPlayingQueue = false;
          notifyListeners();
        }
        return;
      }
      
      // Reached end of queue and all loops completed
      _isPlayingQueue = false;
      _currentQueueIndex = 0;
      _currentTotalLoop = 0;
      _playbackQueue = [];
      debugPrint('AudioProvider: Completed playback queue with all loops');
      notifyListeners();
      return;
    }

    // Play next ayah
    try {
      final nextAyah = _playbackQueue[_currentQueueIndex];
      _currentAyah = nextAyah;
      _currentAyahLoop = 0; // Reset ayah loop for new ayah
      notifyListeners();
      
      debugPrint('AudioProvider: Playing ayah ${_currentQueueIndex + 1} of ${_playbackQueue.length}: ${nextAyah.ayahKey}');
      await _audioService.playAyah(nextAyah);
      await _audioService.setSpeed(_audioSettings.speed);
    } catch (e) {
      debugPrint('Error playing next ayah in queue: $e');
      _isPlayingQueue = false;
      notifyListeners();
    }
  }

  /// Stop queue playback
  Future<void> stopQueue() async {
    _isPlayingQueue = false;
    _currentQueueIndex = 0;
    _currentTotalLoop = 0;
    _currentAyahLoop = 0;
    _playbackQueue = [];
    await stop();
  }

  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await resume();
    }
  }

  /// Pause playback
  Future<void> pause() async {
    try {
      await _audioService.pause();
    } catch (e) {
      _errorMessage = 'Failed to pause: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Resume playback
  Future<void> resume() async {
    try {
      await _audioService.resume();
    } catch (e) {
      _errorMessage = 'Failed to resume: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Stop playback
  Future<void> stop() async {
    try {
      await _audioService.stop();
      _currentAyah = null;
      _position = Duration.zero;
      _duration = null;
      _isPlaying = false;
      _errorMessage = null;
      _currentAyahLoop = 0;
      _currentTotalLoop = 0;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to stop: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Seek to a specific position
  Future<void> seek(Duration position) async {
    try {
      await _audioService.seek(position);
    } catch (e) {
      _errorMessage = 'Failed to seek: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Download ayah audio for offline playback
  Future<bool> downloadAyahAudio(Ayah ayah) async {
    try {
      _isLoading = true;
      notifyListeners();

      final localPath = await _audioService.downloadAyahAudio(ayah);
      
      _isLoading = false;
      notifyListeners();

      return localPath != null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to download audio: ${e.toString()}';
      debugPrint('Error downloading audio: $e');
      notifyListeners();
      return false;
    }
  }

  /// Delete cached audio
  Future<bool> deleteCachedAudio(Ayah ayah) async {
    try {
      return await _audioService.deleteCachedAudio(ayah);
    } catch (e) {
      _errorMessage = 'Failed to delete audio: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Get formatted time string
  String formatDuration(Duration? duration) {
    if (duration == null) return '0:00';
    
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// Get progress as a percentage (0.0 to 1.0)
  double get progress {
    if (_duration == null || _duration!.inMilliseconds == 0) {
      return 0.0;
    }
    return _position.inMilliseconds / _duration!.inMilliseconds;
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
