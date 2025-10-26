import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../models/ayah.dart';
import '../l10n/app_localizations.dart';
import '../services/ayah_bounds_service.dart';

class AyahAudioSelector extends StatefulWidget {
  final int pageNumber;
  final String qiraatId;
  final int currentSurah;

  const AyahAudioSelector({
    Key? key,
    required this.pageNumber,
    required this.qiraatId,
    required this.currentSurah,
  }) : super(key: key);

  @override
  State<AyahAudioSelector> createState() => _AyahAudioSelectorState();
}

class _AyahAudioSelectorState extends State<AyahAudioSelector> {
  int? _selectedStartAyah;
  int? _selectedEndAyah;
  bool _isRangeMode = false;
  List<int>? _ayahsOnPageCache; // Cache the ayahs from bounds
  final AyahBoundsService _boundsService = AyahBoundsService();

  @override
  void initState() {
    super.initState();
    _loadAyahsOnPage();
  }

  Future<void> _loadAyahsOnPage() async {
    try {
      final bounds = await _boundsService.getBoundsForPage(widget.qiraatId, widget.pageNumber);
      if (bounds != null && mounted) {
        setState(() {
          // Extract unique ayah numbers from the bounds for the current surah
          final ayahsForCurrentSurah = bounds.ayahs
              .where((ayahBound) => ayahBound.surahNumber == widget.currentSurah)
              .map((ayahBound) => ayahBound.ayahNumber)
              .toSet()
              .toList()
            ..sort();
          
          _ayahsOnPageCache = ayahsForCurrentSurah.isNotEmpty 
              ? ayahsForCurrentSurah 
              : null; // If no ayahs found for this surah, use fallback
        });
        
        debugPrint('Loaded ${_ayahsOnPageCache?.length ?? 0} ayahs from bounds for page ${widget.pageNumber}, surah ${widget.currentSurah}');
      } else {
        debugPrint('No bounds data found for page ${widget.pageNumber}, using fallback ayah list');
      }
    } catch (e) {
      debugPrint('Error loading ayahs from bounds: $e');
      // Will use fallback in _getAyahsOnPage()
    }
  }

  // Surah info - Complete list of all 114 surahs
  final Map<int, Map<String, dynamic>> surahInfo = {
    1: {'name': 'الفاتحة', 'totalAyahs': 7},
    2: {'name': 'البقرة', 'totalAyahs': 286},
    3: {'name': 'آل عمران', 'totalAyahs': 200},
    4: {'name': 'النساء', 'totalAyahs': 176},
    5: {'name': 'المائدة', 'totalAyahs': 120},
    6: {'name': 'الأنعام', 'totalAyahs': 165},
    7: {'name': 'الأعراف', 'totalAyahs': 206},
    8: {'name': 'الأنفال', 'totalAyahs': 75},
    9: {'name': 'التوبة', 'totalAyahs': 129},
    10: {'name': 'يونس', 'totalAyahs': 109},
    11: {'name': 'هود', 'totalAyahs': 123},
    12: {'name': 'يوسف', 'totalAyahs': 111},
    13: {'name': 'الرعد', 'totalAyahs': 43},
    14: {'name': 'إبراهيم', 'totalAyahs': 52},
    15: {'name': 'الحجر', 'totalAyahs': 99},
    16: {'name': 'النحل', 'totalAyahs': 128},
    17: {'name': 'الإسراء', 'totalAyahs': 111},
    18: {'name': 'الكهف', 'totalAyahs': 110},
    19: {'name': 'مريم', 'totalAyahs': 98},
    20: {'name': 'طه', 'totalAyahs': 135},
    21: {'name': 'الأنبياء', 'totalAyahs': 112},
    22: {'name': 'الحج', 'totalAyahs': 78},
    23: {'name': 'المؤمنون', 'totalAyahs': 118},
    24: {'name': 'النور', 'totalAyahs': 64},
    25: {'name': 'الفرقان', 'totalAyahs': 77},
    26: {'name': 'الشعراء', 'totalAyahs': 227},
    27: {'name': 'النمل', 'totalAyahs': 93},
    28: {'name': 'القصص', 'totalAyahs': 88},
    29: {'name': 'العنكبوت', 'totalAyahs': 69},
    30: {'name': 'الروم', 'totalAyahs': 60},
    31: {'name': 'لقمان', 'totalAyahs': 34},
    32: {'name': 'السجدة', 'totalAyahs': 30},
    33: {'name': 'الأحزاب', 'totalAyahs': 73},
    34: {'name': 'سبأ', 'totalAyahs': 54},
    35: {'name': 'فاطر', 'totalAyahs': 45},
    36: {'name': 'يس', 'totalAyahs': 83},
    37: {'name': 'الصافات', 'totalAyahs': 182},
    38: {'name': 'ص', 'totalAyahs': 88},
    39: {'name': 'الزمر', 'totalAyahs': 75},
    40: {'name': 'غافر', 'totalAyahs': 85},
    41: {'name': 'فصلت', 'totalAyahs': 54},
    42: {'name': 'الشورى', 'totalAyahs': 53},
    43: {'name': 'الزخرف', 'totalAyahs': 89},
    44: {'name': 'الدخان', 'totalAyahs': 59},
    45: {'name': 'الجاثية', 'totalAyahs': 37},
    46: {'name': 'الأحقاف', 'totalAyahs': 35},
    47: {'name': 'محمد', 'totalAyahs': 38},
    48: {'name': 'الفتح', 'totalAyahs': 29},
    49: {'name': 'الحجرات', 'totalAyahs': 18},
    50: {'name': 'ق', 'totalAyahs': 45},
    51: {'name': 'الذاريات', 'totalAyahs': 60},
    52: {'name': 'الطور', 'totalAyahs': 49},
    53: {'name': 'النجم', 'totalAyahs': 62},
    54: {'name': 'القمر', 'totalAyahs': 55},
    55: {'name': 'الرحمن', 'totalAyahs': 78},
    56: {'name': 'الواقعة', 'totalAyahs': 96},
    57: {'name': 'الحديد', 'totalAyahs': 29},
    58: {'name': 'المجادلة', 'totalAyahs': 22},
    59: {'name': 'الحشر', 'totalAyahs': 24},
    60: {'name': 'الممتحنة', 'totalAyahs': 13},
    61: {'name': 'الصف', 'totalAyahs': 14},
    62: {'name': 'الجمعة', 'totalAyahs': 11},
    63: {'name': 'المنافقون', 'totalAyahs': 11},
    64: {'name': 'التغابن', 'totalAyahs': 18},
    65: {'name': 'الطلاق', 'totalAyahs': 12},
    66: {'name': 'التحريم', 'totalAyahs': 12},
    67: {'name': 'الملك', 'totalAyahs': 30},
    68: {'name': 'القلم', 'totalAyahs': 52},
    69: {'name': 'الحاقة', 'totalAyahs': 52},
    70: {'name': 'المعارج', 'totalAyahs': 44},
    71: {'name': 'نوح', 'totalAyahs': 28},
    72: {'name': 'الجن', 'totalAyahs': 28},
    73: {'name': 'المزمل', 'totalAyahs': 20},
    74: {'name': 'المدثر', 'totalAyahs': 56},
    75: {'name': 'القيامة', 'totalAyahs': 40},
    76: {'name': 'الإنسان', 'totalAyahs': 31},
    77: {'name': 'المرسلات', 'totalAyahs': 50},
    78: {'name': 'النبأ', 'totalAyahs': 40},
    79: {'name': 'النازعات', 'totalAyahs': 46},
    80: {'name': 'عبس', 'totalAyahs': 42},
    81: {'name': 'التكوير', 'totalAyahs': 29},
    82: {'name': 'الانفطار', 'totalAyahs': 19},
    83: {'name': 'المطففين', 'totalAyahs': 36},
    84: {'name': 'الانشقاق', 'totalAyahs': 25},
    85: {'name': 'البروج', 'totalAyahs': 22},
    86: {'name': 'الطارق', 'totalAyahs': 17},
    87: {'name': 'الأعلى', 'totalAyahs': 19},
    88: {'name': 'الغاشية', 'totalAyahs': 26},
    89: {'name': 'الفجر', 'totalAyahs': 30},
    90: {'name': 'البلد', 'totalAyahs': 20},
    91: {'name': 'الشمس', 'totalAyahs': 15},
    92: {'name': 'الليل', 'totalAyahs': 21},
    93: {'name': 'الضحى', 'totalAyahs': 11},
    94: {'name': 'الشرح', 'totalAyahs': 8},
    95: {'name': 'التين', 'totalAyahs': 8},
    96: {'name': 'العلق', 'totalAyahs': 19},
    97: {'name': 'القدر', 'totalAyahs': 5},
    98: {'name': 'البينة', 'totalAyahs': 8},
    99: {'name': 'الزلزلة', 'totalAyahs': 8},
    100: {'name': 'العاديات', 'totalAyahs': 11},
    101: {'name': 'القارعة', 'totalAyahs': 11},
    102: {'name': 'التكاثر', 'totalAyahs': 8},
    103: {'name': 'العصر', 'totalAyahs': 3},
    104: {'name': 'الهمزة', 'totalAyahs': 9},
    105: {'name': 'الفيل', 'totalAyahs': 5},
    106: {'name': 'قريش', 'totalAyahs': 4},
    107: {'name': 'الماعون', 'totalAyahs': 7},
    108: {'name': 'الكوثر', 'totalAyahs': 3},
    109: {'name': 'الكافرون', 'totalAyahs': 6},
    110: {'name': 'النصر', 'totalAyahs': 3},
    111: {'name': 'المسد', 'totalAyahs': 5},
    112: {'name': 'الإخلاص', 'totalAyahs': 4},
    113: {'name': 'الفلق', 'totalAyahs': 5},
    114: {'name': 'الناس', 'totalAyahs': 6},
  };

  List<int> _getAyahsOnPage() {
    // Return cached ayahs from bounds JSON if available
    if (_ayahsOnPageCache != null && _ayahsOnPageCache!.isNotEmpty) {
      return _ayahsOnPageCache!;
    }
    
    // Fallback: Return a default set of ayahs while loading
    // This will be replaced once bounds are loaded
    return List.generate(7, (index) => index + 1);
  }

  List<int> _getAllAyahsInSurah() {
    // Get total ayahs for the current surah
    final surahData = surahInfo[widget.currentSurah];
    if (surahData == null) {
      // Default to 15 ayahs if surah not found
      return List.generate(15, (index) => index + 1);
    }
    
    final totalAyahs = surahData['totalAyahs'] as int;
    return List.generate(totalAyahs, (index) => index + 1);
  }

  List<int> _getDisplayedAyahs() {
    // If range mode is ON, show all ayahs in surah
    // If range mode is OFF, show only ayahs on current page
    return _isRangeMode ? _getAllAyahsInSurah() : _getAyahsOnPage();
  }

  String _buildAudioUrl(int surahNumber, int ayahNumber) {
    const baseUrl = 'https://pub-820035f689da4250823ad729c03363e9.r2.dev';
    
    final parts = widget.qiraatId.split('_');
    if (parts.length != 2) {
      print('DEBUG AUDIO SELECTOR: Invalid qiraatId: ${widget.qiraatId}');
      return '';
    }
    
    // Map qiraat IDs to correct R2 folder structure
    final qariName = _mapQariName(parts[0]);
    final rawiName = _mapRawiName(parts[1]);
    
    // Format: SSSAAA.mp3 (3-digit surah + 3-digit ayah, no separator)
    final surahStr = surahNumber.toString().padLeft(3, '0');
    final ayahStr = ayahNumber.toString().padLeft(3, '0');
    final audioUrl = '$baseUrl/Zeyd/$qariName/$rawiName/$surahStr$ayahStr.mp3';
    
    print('DEBUG AUDIO SELECTOR: Built audio URL for ${widget.qiraatId}:');
    print('  Qari: $qariName, Rawi: $rawiName');
    print('  Surah: $surahNumber ($surahStr), Ayah: $ayahNumber ($ayahStr)');
    print('  Full URL: $audioUrl');
    
    return audioUrl;
  }

  /// Map qari IDs to R2 folder names
  String _mapQariName(String qariId) {
    // Handle compound qari names by checking the full qiraat ID
    final fullQiraatId = widget.qiraatId;
    if (fullQiraatId.startsWith('ibn_kathir')) return 'ibn_kathir';
    if (fullQiraatId.startsWith('abu_amr')) return 'abu_amr';
    if (fullQiraatId.startsWith('abu_jafar')) return 'abu_ja_far';
    if (fullQiraatId.startsWith('kisai') || fullQiraatId.startsWith('al_kisai')) return 'kisa_i';
    if (fullQiraatId.startsWith('ibn_amir')) return 'ibn_amir';
    if (fullQiraatId.startsWith('khalaf')) return 'khalaf_tenth';  // Khalaf al-'Ashir
    
    const mapping = {
      'nafi': 'nafi',
      'asim': 'asim',
      'hamzah': 'hamza',        // Note: hamza not hamzah
      'yaqub': 'ya_qub',        // Note: ya_qub with underscore
    };
    
    return mapping[qariId] ?? qariId;
  }

  /// Map rawi IDs to R2 folder names
  String _mapRawiName(String rawiId) {
    // Handle context-specific mappings based on the full qiraat ID
    final fullQiraatId = widget.qiraatId;
    
    // Special cases where the same rawi name appears with different qaris
    if (fullQiraatId == 'abu_amr_duri') return 'duri';
    if (fullQiraatId == 'kisai_duri') return 'duri_kisa_i';  // Different Duri for Kisa'i
    
    const mapping = {
      // Nafi'
      'qalun': 'qaloun',        // Note: qaloun not qalun
      'warsh': 'warsh',
      
      // Ibn Kathir
      'bazzi': 'bazzi',
      'qunbul': 'qunbul',
      
      // Abu Amr
      'sussi': 'susi',          // Note: susi not sussi
      
      // Asim
      'hafs': 'hafs',
      'shuba': 'shu_ba',        // Note: shu_ba with underscore
      
      // Hamzah (note: khalaf here is different from Khalaf al-'Ashir)
      'khalaf': 'khalaf',       // Khalaf an Hamzah
      'khalaad': 'khallad',     // Note: khallad not khalaad
      
      // Al-Kisa'i
      'abu_harith': 'abu_harith',
      
      // Abu Jafar
      'ibn_jammaz': 'ibn_jammaz',
      'ibn_wardan': 'ibn_wardaan',  // Note: ibn_wardaan not ibn_wardan
      
      // Ya'qub
      'ruways': 'ruways',
      'rawh': 'rawh',
      
      // Khalaf al-'Ashir (the 10th reader) - THESE ARE THE KEY ONES!
      'ishaq': 'ishaq',         // lowercase
      'idris': 'idris',         // lowercase
      
      // Ibn Amir
      'hisham': 'hisham',
      'ibn_zakwan': 'ibn_dhakwan',  // Note: ibn_dhakwan not ibn_zakwan
    };
    
    return mapping[rawiId] ?? rawiId;
  }

  void _playSingleAyah(int ayahNumber) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final localizations = AppLocalizations.of(context);
    final audioUrl = _buildAudioUrl(widget.currentSurah, ayahNumber);
    
    final ayah = Ayah(
      surahNumber: widget.currentSurah,
      ayahNumber: ayahNumber,
      pageNumber: widget.pageNumber,
      qiraatId: widget.qiraatId,
      audioUrl: audioUrl,
    );
    
    audioProvider.playAyah(ayah);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations.playingAyah(ayahNumber),
          style: const TextStyle(fontFamily: 'Amiri', fontSize: 16),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _playAyahRange(int startAyah, int endAyah) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final localizations = AppLocalizations.of(context);
    
    // Build list of ayahs in the range
    final ayahsToPlay = <Ayah>[];
    for (int i = startAyah; i <= endAyah; i++) {
      final audioUrl = _buildAudioUrl(widget.currentSurah, i);
      final ayah = Ayah(
        surahNumber: widget.currentSurah,
        ayahNumber: i,
        pageNumber: widget.pageNumber,
        qiraatId: widget.qiraatId,
        audioUrl: audioUrl,
      );
      ayahsToPlay.add(ayah);
    }
    
    // Start sequential playback
    audioProvider.playAyahRange(ayahsToPlay);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations.playingRange(startAyah, endAyah),
          style: const TextStyle(fontFamily: 'Amiri', fontSize: 16),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _playWholeSurah() {
    // Play from first ayah on page to last ayah on page (not 1 to total)
    final ayahsOnPage = _getAyahsOnPage();
    if (ayahsOnPage.isEmpty) return;
    
    final firstAyah = ayahsOnPage.first;
    final lastAyah = ayahsOnPage.last;
    _playAyahRange(firstAyah, lastAyah);
  }

  void _playEntireSurah() {
    // Play the entire surah from ayah 1 to the last ayah
    final surahData = surahInfo[widget.currentSurah];
    if (surahData == null) return;
    
    final totalAyahs = surahData['totalAyahs'] as int;
    _playAyahRange(1, totalAyahs);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final displayedAyahs = _getDisplayedAyahs();
    final surahData = surahInfo[widget.currentSurah];
    final surahName = surahData?['name'] ?? 'السورة';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          
          // Title
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              '${localizations.surah} $surahName',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Play entire surah button (green)
          if (surahData != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: ElevatedButton.icon(
                onPressed: _playEntireSurah,
                icon: const Icon(Icons.play_circle_filled),
                label: Text(
                  localizations.playWholeSurah,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 18.sp,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),

          // Play all ayahs on page button
          if (surahData != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: ElevatedButton.icon(
                onPressed: _playWholeSurah,
                icon: const Icon(Icons.play_arrow),
                label: Builder(
                  builder: (context) {
                    final ayahsOnPage = _getAyahsOnPage();
                    final buttonText = ayahsOnPage.isNotEmpty
                        ? '${localizations.playThePage} (${ayahsOnPage.first}-${ayahsOnPage.last})'
                        : localizations.playThePage;
                    return Text(
                      buttonText,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18.sp,
                      ),
                    );
                  }
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),

          // Range mode toggle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SwitchListTile(
              title: Text(
                localizations.playAyahRange,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16.sp,
                ),
              ),
              subtitle: _isRangeMode && surahData != null
                  ? Builder(
                      builder: (context) {
                        final localizations = AppLocalizations.of(context);
                        return Text(
                          '${localizations.showingAllAyahs} ${surahData['totalAyahs']}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                    )
                  : Builder(
                      builder: (context) {
                        final ayahsOnPage = _getAyahsOnPage();
                        if (ayahsOnPage.isEmpty) return const SizedBox.shrink();
                        
                        final localizations = AppLocalizations.of(context);
                        return Text(
                          '${localizations.showingAyahsOnPage} ${ayahsOnPage.first}-${ayahsOnPage.last}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                    ),
              value: _isRangeMode,
              onChanged: (value) {
                setState(() {
                  _isRangeMode = value;
                  _selectedStartAyah = null;
                  _selectedEndAyah = null;
                });
              },
            ),
          ),

          // Range selection info
          if (_isRangeMode && (_selectedStartAyah != null || _selectedEndAyah != null))
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${localizations.from}: ${_selectedStartAyah ?? '...'} ',
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_forward, size: 20),
                    Text(
                      ' ${localizations.to}: ${_selectedEndAyah ?? '...'}',
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Play range button
          if (_isRangeMode && _selectedStartAyah != null && _selectedEndAyah != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: ElevatedButton.icon(
                onPressed: () => _playAyahRange(_selectedStartAyah!, _selectedEndAyah!),
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  localizations.playRange,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16.sp,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 45.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),

          // Ayah list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: displayedAyahs.length,
              itemBuilder: (context, index) {
                final ayahNumber = displayedAyahs[index];
                final isSelected = _isRangeMode
                    ? (_selectedStartAyah == ayahNumber || _selectedEndAyah == ayahNumber)
                    : false;
                
                return Card(
                  margin: EdgeInsets.only(bottom: 8.h),
                  color: isSelected ? Colors.blue.withOpacity(0.2) : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        '$ayahNumber',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      '${localizations.ayah} $ayahNumber',
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18.sp,
                      ),
                    ),
                    trailing: _isRangeMode
                        ? null
                        : Icon(
                            Icons.play_arrow,
                            color: Theme.of(context).primaryColor,
                          ),
                    onTap: () {
                      if (_isRangeMode) {
                        setState(() {
                          if (_selectedStartAyah == null) {
                            _selectedStartAyah = ayahNumber;
                          } else if (_selectedEndAyah == null) {
                            if (ayahNumber > _selectedStartAyah!) {
                              _selectedEndAyah = ayahNumber;
                            } else {
                              _selectedEndAyah = _selectedStartAyah;
                              _selectedStartAyah = ayahNumber;
                            }
                          } else {
                            _selectedStartAyah = ayahNumber;
                            _selectedEndAyah = null;
                          }
                        });
                      } else {
                        _playSingleAyah(ayahNumber);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
