class GitHubQiraatService {
  // TODO: Replace with your actual GitHub Pages URL
  static const String baseUrl = 'https://yourusername.github.io/mushaf-qiraats';
  
  /// Generate the URL for a qiraat page
  static String getPageUrl(String qiraatId, int pageNumber) {
    final pageNum = pageNumber.toString().padLeft(3, '0');
    return '$baseUrl/$qiraatId/page_$pageNum.jpg';
  }
  
  /// Check if qiraat is available (all qiraats are available via GitHub)
  static bool isQiraatAvailable(String qiraatId) {
    // All qiraats are available via GitHub - no download needed!
    return true;
  }
  
  /// Get all available qiraats
  static List<String> getAvailableQiraats() {
    return [
      'asim_hafs',
      'nafi_warsh',
      'nafi_qaloon',
      'asim_shubah',
      'abu_amr_duri',
      'abu_amr_sussi',
      'ibn_kathir_bazzi',
      'ibn_kathir_qunbul',
      'ibn_amir_hisham',
      'ibn_amir_dhakwan',
      'hamzah_khalaf',
      'hamzah_khalaad',
      'kisai_duri',
      'kisai_abu_harith',
      'abu_jafar_ibn_wardan',
      'abu_jafar_ibn_jammaz',
      'yaqub_ruways',
      'yaqub_rawh',
      'khalaf_ishaq',
      'khalaf_idris',
    ];
  }
}