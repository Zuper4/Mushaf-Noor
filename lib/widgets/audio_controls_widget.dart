import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../models/audio_settings.dart';
import '../providers/audio_provider.dart';

/// Widget for audio playback controls including speed and looping options
class AudioControlsWidget extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback? onToggleExpanded;

  const AudioControlsWidget({
    super.key,
    this.isExpanded = false,
    this.onToggleExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        if (!audioProvider.hasAudio) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Controls toggle button
              _buildToggleButton(context, audioProvider),
              
              // Expanded controls
              if (isExpanded) ...[
                SizedBox(height: 8.h),
                _buildExpandedControls(context, audioProvider),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggleButton(BuildContext context, AudioProvider audioProvider) {
    return GestureDetector(
      onTap: onToggleExpanded,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Speed indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                audioProvider.audioSettings.speedLabel,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            SizedBox(width: 8.w),
            
            // Loop indicators
            if (audioProvider.audioSettings.ayahLoopCount > 0 ||
                audioProvider.audioSettings.totalLoopCount > 0) ...[
              Icon(
                Icons.repeat,
                color: Colors.white70,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
            ],
            
            // Expand/collapse icon
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.white70,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedControls(BuildContext context, AudioProvider audioProvider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        children: [
          // Speed controls
          _buildSpeedControls(context, audioProvider),
          
          SizedBox(height: 12.h),
          
          // Loop controls
          _buildLoopControls(context, audioProvider),
        ],
      ),
    );
  }

  Widget _buildSpeedControls(BuildContext context, AudioProvider audioProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Playback Speed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        
        // Speed buttons
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: AudioSettings.availableSpeeds.map((speed) {
            final isSelected = audioProvider.audioSettings.speed == speed;
            return GestureDetector(
              onTap: () => audioProvider.setPlaybackSpeed(speed),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.white.withOpacity(0.3)
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                  border: isSelected 
                      ? Border.all(color: Colors.white, width: 1)
                      : null,
                ),
                child: Text(
                  '${speed}x',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLoopControls(BuildContext context, AudioProvider audioProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loop Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        
        // Ayah loop control
        _buildLoopControl(
          context,
          'Repeat each Ayah:',
          audioProvider.audioSettings.ayahLoopCount,
          (value) => audioProvider.setAyahLoopCount(value),
          audioProvider.currentAyahLoop,
        ),
        
        SizedBox(height: 8.h),
        
        // Total loop control (only show if playing queue)
        if (audioProvider.isPlayingQueue)
          _buildLoopControl(
            context,
            'Repeat sequence:',
            audioProvider.audioSettings.totalLoopCount,
            (value) => audioProvider.setTotalLoopCount(value),
            audioProvider.currentTotalLoop,
          ),
      ],
    );
  }

  Widget _buildLoopControl(
    BuildContext context,
    String label,
    int currentValue,
    ValueChanged<int> onChanged,
    int currentProgress,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
              // Show current progress for finite loops
              if (currentValue > 0 && currentValue != AudioSettings.infiniteLoop && currentProgress > 0)
                Text(
                  currentValue == AudioSettings.infiniteLoop 
                      ? '($currentProgress/∞)'
                      : '($currentProgress/$currentValue)',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10.sp,
                  ),
                ),
            ],
          ),
        ),
        
        // Decrease button
        _buildLoopButton(
          icon: Icons.remove,
          onTap: () {
            if (currentValue == AudioSettings.infiniteLoop) {
              // From infinity to max value
              onChanged(AudioSettings.maxLoopCount);
            } else {
              // Regular decrease
              final newValue = currentValue - 1;
              if (newValue < 0) {
                onChanged(AudioSettings.infiniteLoop); // Go to infinity
              } else {
                onChanged(newValue);
              }
            }
          },
          enabled: true, // Always enabled now
        ),
        
        SizedBox(width: 8.w),
        
        // Current value
        Container(
          width: 32.w,
          alignment: Alignment.center,
          child: Text(
            currentValue == AudioSettings.infiniteLoop ? '∞' : currentValue.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        SizedBox(width: 8.w),
        
        // Increase button
        _buildLoopButton(
          icon: Icons.add,
          onTap: () {
            if (currentValue == AudioSettings.infiniteLoop) {
              // From infinity to 0
              onChanged(0);
            } else if (currentValue >= AudioSettings.maxLoopCount) {
              // From max to infinity
              onChanged(AudioSettings.infiniteLoop);
            } else {
              // Regular increase
              onChanged(currentValue + 1);
            }
          },
          enabled: true, // Always enabled now
        ),
      ],
    );
  }

  Widget _buildLoopButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 28.w,
        height: 28.h,
        decoration: BoxDecoration(
          color: enabled 
              ? Colors.white.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : Colors.white38,
          size: 16.sp,
        ),
      ),
    );
  }
}

/// Compact speed selector for minimal UI
class CompactSpeedSelector extends StatelessWidget {
  const CompactSpeedSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        if (!audioProvider.hasAudio) {
          return const SizedBox.shrink();
        }

        return PopupMenuButton<double>(
          onSelected: (speed) => audioProvider.setPlaybackSpeed(speed),
          itemBuilder: (context) {
            return AudioSettings.availableSpeeds.map((speed) {
              final isSelected = audioProvider.audioSettings.speed == speed;
              return PopupMenuItem<double>(
                value: speed,
                child: Row(
                  children: [
                    if (isSelected)
                      Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                        size: 16.sp,
                      )
                    else
                      SizedBox(width: 16.w),
                    SizedBox(width: 8.w),
                    Text(
                      '${speed}x',
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  audioProvider.audioSettings.speedLabel,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}