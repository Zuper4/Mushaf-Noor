import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ayah.dart';
import '../models/ayah_bounds.dart';
import '../providers/audio_provider.dart';
import '../services/ayah_bounds_service.dart';

/// Overlay widget that detects ayah taps/long-presses on a Mushaf page
/// This widget should be placed on top of the page image
class AyahDetectionOverlay extends StatefulWidget {
  final int pageNumber;
  final String qiraatId;
  final double imageWidth;
  final double imageHeight;
  final bool enabled; // Enable/disable ayah detection

  const AyahDetectionOverlay({
    super.key,
    required this.pageNumber,
    required this.qiraatId,
    required this.imageWidth,
    required this.imageHeight,
    this.enabled = true,
  });

  @override
  State<AyahDetectionOverlay> createState() => _AyahDetectionOverlayState();
}

class _AyahDetectionOverlayState extends State<AyahDetectionOverlay> {
  final AyahBoundsService _boundsService = AyahBoundsService();
  PageAyahBounds? _pageBounds;
  AyahBoundInfo? _selectedAyah;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBounds();
  }

  @override
  void didUpdateWidget(AyahDetectionOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageNumber != widget.pageNumber ||
        oldWidget.qiraatId != widget.qiraatId) {
      _loadBounds();
    }
  }

  Future<void> _loadBounds() async {
    if (!widget.enabled) return;

    setState(() {
      _isLoading = true;
      _selectedAyah = null;
    });

    try {
      final bounds = await _boundsService.getBoundsForPage(
        widget.qiraatId,
        widget.pageNumber,
      );

      if (mounted) {
        setState(() {
          _pageBounds = bounds;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading ayah bounds: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleLongPress(Offset localPosition) {
    print('DEBUG OVERLAY: Long press detected at $localPosition');
    print('DEBUG OVERLAY: Image dimensions: ${widget.imageWidth} x ${widget.imageHeight}');
    print('DEBUG OVERLAY: Page bounds loaded: ${_pageBounds != null}');
    print('DEBUG OVERLAY: Enabled: ${widget.enabled}');
    
    if (_pageBounds == null || !widget.enabled) {
      print('DEBUG OVERLAY: Long press ignored - bounds=${_pageBounds != null}, enabled=${widget.enabled}');
      return;
    }

    // Convert local position to normalized coordinates (0.0 - 1.0)
    final normalizedX = localPosition.dx / widget.imageWidth;
    final normalizedY = localPosition.dy / widget.imageHeight;
    
    print('DEBUG OVERLAY: Normalized coordinates: ($normalizedX, $normalizedY)');

    // Find which ayah was tapped
    final ayahBound = _pageBounds!.findAyahAtPoint(normalizedX, normalizedY);
    
    print('DEBUG OVERLAY: Ayah found: ${ayahBound != null}');

    if (ayahBound != null) {
      print('DEBUG OVERLAY: Playing Surah ${ayahBound.surahNumber}, Ayah ${ayahBound.ayahNumber}');
      setState(() {
        _selectedAyah = ayahBound;
      });

      // Trigger audio playback
      _playAyah(ayahBound);

      // Show feedback
      _showAyahSelectedFeedback(ayahBound);
    } else {
      print('DEBUG OVERLAY: No ayah found at this position');
    }
  }

  void _playAyah(AyahBoundInfo ayahBound) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    // Create Ayah object with audio URL
    // TODO: Get actual audio URL from a service/API
    final audioUrl = _buildAudioUrl(widget.qiraatId, ayahBound.surahNumber, ayahBound.ayahNumber);

    final ayah = Ayah(
      surahNumber: ayahBound.surahNumber,
      ayahNumber: ayahBound.ayahNumber,
      pageNumber: widget.pageNumber,
      qiraatId: widget.qiraatId,
      audioUrl: audioUrl,
      positions: ayahBound.positions,
    );

    audioProvider.playAyah(ayah);
  }

  /// Build audio URL for an ayah
  /// Replace YOUR_R2_URL with your actual Cloudflare R2 public URL
  /// Example: https://pub-xxxxx.r2.dev or https://audio.yourdomain.com
  String _buildAudioUrl(String qiraatId, int surahNumber, int ayahNumber) {
    // Cloudflare R2 public URL for your ayahs bucket
    const baseUrl = 'https://pub-820035f689da4250823ad729c03363e9.r2.dev';
    
    // Convert qiraatId (e.g., "nafi_warsh") to R2 path structure
    // qiraatId format: "qari_rawi" -> R2 path: "ayahs/Zeyd/qari/rawi"
    final parts = qiraatId.split('_');
    if (parts.length != 2) {
      print('ERROR: Invalid qiraatId format: $qiraatId');
      return '';
    }
    
    final qariName = _normalizeQariName(parts[0]);  // e.g., "nafi" -> "nafi"
    final rawiName = _normalizeRawiName(parts[1]);  // e.g., "warsh" -> "warsh"
    
    // Format: {baseUrl}/ayahs/Zeyd/{qari}/{rawi}/{surah}{ayah}.mp3
    // Example: https://pub-820035f689da4250823ad729c03363e9.r2.dev/ayahs/Zeyd/nafi/warsh/001001.mp3
    final surahPadded = surahNumber.toString().padLeft(3, '0');
    final ayahPadded = ayahNumber.toString().padLeft(3, '0');
    
    final audioUrl = '$baseUrl/ayahs/Zeyd/$qariName/$rawiName/$surahPadded$ayahPadded.mp3';
    print('DEBUG: Built audio URL: $audioUrl');
    return audioUrl;
  }

  // Normalize qari names to match R2 folder structure
  String _normalizeQariName(String qariId) {
    // Map qari IDs to folder names if they differ
    // Add mappings here if your R2 folder names differ from the ID
    return qariId.toLowerCase();
  }

  // Normalize rawi names to match R2 folder structure
  String _normalizeRawiName(String rawiId) {
    // Map rawi IDs to folder names if they differ
    // Add mappings here if your R2 folder names differ from the ID
    return rawiId.toLowerCase();
  }

  void _showAyahSelectedFeedback(AyahBoundInfo ayahBound) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Playing Surah ${ayahBound.surahNumber}, Ayah ${ayahBound.ayahNumber}',
          style: const TextStyle(fontFamily: 'Amiri'),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || _pageBounds == null) {
      // Return transparent container when disabled or no bounds available
      return const SizedBox.expand();
    }

    return GestureDetector(
      onLongPressStart: (details) {
        _handleLongPress(details.localPosition);
      },
      child: Container(
        width: widget.imageWidth,
        height: widget.imageHeight,
        color: Colors.transparent,
        child: _buildOverlay(),
      ),
    );
  }

  Widget _buildOverlay() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
        ),
      );
    }

    // Optionally show visual feedback for selected ayah
    if (_selectedAyah != null) {
      return Stack(
        children: _selectedAyah!.positions.map((position) {
          return Positioned(
            left: position.x * widget.imageWidth,
            top: position.y * widget.imageHeight,
            width: position.width * widget.imageWidth,
            height: position.height * widget.imageHeight,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.3),
                border: Border.all(
                  color: Colors.amber,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }).toList(),
      );
    }

    return const SizedBox.shrink();
  }
}
