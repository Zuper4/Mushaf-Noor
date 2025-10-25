import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/ayah.dart';
import '../services/audio_service.dart';

/// Provider for managing audio playback state across the app
class AudioProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();

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

  AudioProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _audioService.initialize();
    _setupListeners();
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

      // Handle completion for sequential playback
      if (state.processingState == ProcessingState.completed && _isPlayingQueue) {
        debugPrint('AudioProvider: Ayah completed, playing next in queue. Queue: ${_playbackQueue.length}, Index: $_currentQueueIndex');
        _playNextInQueue();
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

  /// Play a specific ayah
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
      }
      
      notifyListeners();

      await _audioService.playAyah(ayah);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to play audio: ${e.toString()}';
      debugPrint('Error in playAyah: $e');
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
      // Reached end of queue
      _isPlayingQueue = false;
      _currentQueueIndex = 0;
      _playbackQueue = [];
      debugPrint('AudioProvider: Completed playback queue');
      notifyListeners();
      return;
    }

    // Play next ayah
    try {
      final nextAyah = _playbackQueue[_currentQueueIndex];
      _currentAyah = nextAyah;
      notifyListeners();
      
      debugPrint('AudioProvider: Playing ayah ${_currentQueueIndex + 1} of ${_playbackQueue.length}: ${nextAyah.ayahKey}');
      await _audioService.playAyah(nextAyah);
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
