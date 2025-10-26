import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import 'audio_controls_widget.dart';

/// Floating audio player UI that appears at the bottom when audio is playing
/// Shows currently playing ayah info and playback controls
class FloatingAudioPlayer extends StatefulWidget {
  const FloatingAudioPlayer({super.key});

  @override
  State<FloatingAudioPlayer> createState() => _FloatingAudioPlayerState();
}

class _FloatingAudioPlayerState extends State<FloatingAudioPlayer> {
  bool _isControlsExpanded = false;
  bool _isPlayerCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        // Don't show player if no audio is loaded
        if (!audioProvider.hasAudio) {
          return const SizedBox.shrink();
        }

        return Positioned(
          left: 16.w,
          right: 16.w,
          bottom: 80.h, // Above bottom navigation/controls
          child: _isPlayerCollapsed 
              ? _buildCollapsedPlayer(context, audioProvider)
              : _buildPlayerCard(context, audioProvider),
        );
      },
    );
  }

  Widget _buildCollapsedPlayer(BuildContext context, AudioProvider audioProvider) {
    final ayah = audioProvider.currentAyah!;
    
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            // Play/Pause button
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: audioProvider.isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        audioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                onPressed: audioProvider.isLoading
                    ? null
                    : () => audioProvider.togglePlayPause(),
              ),
            ),
            
            SizedBox(width: 12.w),
            
            // Ayah info and progress
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Surah ${ayah.surahNumber} : Ayah ${ayah.ayahNumber}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Amiri',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  
                  // Mini progress bar
                  Container(
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(1.5.r),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: audioProvider.progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.5.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(width: 12.w),
            
            // Stop button
            IconButton(
              icon: Icon(
                Icons.stop,
                color: Colors.white,
                size: 20.sp,
              ),
              onPressed: () => audioProvider.stop(),
            ),
            
            // Expand button
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_up,
                color: Colors.white70,
                size: 24.sp,
              ),
              onPressed: () {
                setState(() {
                  _isPlayerCollapsed = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerCard(BuildContext context, AudioProvider audioProvider) {
    final ayah = audioProvider.currentAyah!;
    
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ayah info
            _buildAyahInfo(ayah, audioProvider),
            SizedBox(height: 12.h),
            
            // Progress slider
            _buildProgressSlider(context, audioProvider),
            SizedBox(height: 8.h),
            
            // Time labels
            _buildTimeLabels(audioProvider),
            SizedBox(height: 12.h),
            
            // Audio controls (speed and loop settings)
            AudioControlsWidget(
              isExpanded: _isControlsExpanded,
              onToggleExpanded: () {
                setState(() {
                  _isControlsExpanded = !_isControlsExpanded;
                });
              },
            ),
            SizedBox(height: 8.h),
            
            // Playback controls
            _buildControls(audioProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildAyahInfo(ayah, AudioProvider audioProvider) {
    return Row(
      children: [
        // Quran icon
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.menu_book,
            color: Colors.white,
            size: 24.sp,
          ),
        ),
        SizedBox(width: 12.w),
        
        // Ayah details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Surah ${ayah.surahNumber} : Ayah ${ayah.ayahNumber}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Amiri',
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Text(
                    'Page ${ayah.pageNumber}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
                  // Show queue progress if playing range
                  if (audioProvider.isPlayingQueue) ...[
                    Text(
                      '  •  ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      '${audioProvider.currentQueueIndex + 1} / ${audioProvider.playbackQueue.length}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSlider(BuildContext context, AudioProvider audioProvider) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 3.h,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 12.r),
        activeTrackColor: Colors.white,
        inactiveTrackColor: Colors.white24,
        thumbColor: Colors.white,
        overlayColor: Colors.white24,
      ),
      child: Slider(
        value: audioProvider.progress.clamp(0.0, 1.0),
        onChanged: (value) {
          if (audioProvider.duration != null) {
            final position = Duration(
              milliseconds: (audioProvider.duration!.inMilliseconds * value).round(),
            );
            audioProvider.seek(position);
          }
        },
      ),
    );
  }

  Widget _buildTimeLabels(AudioProvider audioProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            audioProvider.formatDuration(audioProvider.position),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11.sp,
            ),
          ),
          Text(
            audioProvider.formatDuration(audioProvider.duration),
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(AudioProvider audioProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stop button
        IconButton(
          icon: Icon(
            Icons.stop,
            color: Colors.white,
            size: 28.sp,
          ),
          onPressed: () => audioProvider.stop(),
        ),
        
        SizedBox(width: 16.w),
        
        // Play/Pause button (larger)
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: audioProvider.isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    audioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 36.sp,
                  ),
            onPressed: audioProvider.isLoading
                ? null
                : () => audioProvider.togglePlayPause(),
          ),
        ),
        
        SizedBox(width: 16.w),
        
        // Player collapse/expand button (always visible)
        IconButton(
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white70,
            size: 24.sp,
          ),
          onPressed: () {
            setState(() {
              _isPlayerCollapsed = true;
            });
          },
        ),
      ],
    );
  }
}

/// Compact version of the audio player for minimal UI
class CompactAudioPlayer extends StatelessWidget {
  const CompactAudioPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        if (!audioProvider.hasAudio) {
          return const SizedBox.shrink();
        }

        final ayah = audioProvider.currentAyah!;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: Row(
            children: [
              // Play/Pause button
              IconButton(
                icon: Icon(
                  audioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () => audioProvider.togglePlayPause(),
              ),
              
              // Ayah info
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Surah ${ayah.surahNumber} : ${ayah.ayahNumber}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                      child: LinearProgressIndicator(
                        value: audioProvider.progress,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Stop button
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => audioProvider.stop(),
              ),
            ],
          ),
        );
      },
    );
  }
}
