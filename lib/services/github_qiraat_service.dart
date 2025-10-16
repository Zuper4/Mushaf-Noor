class GitHubQiraatService {
  // Cloudflare R2 URL for mushaf-qiraats repository
  static const String baseUrl = 'https://pub-908424a64cd948adab8cb072f37d26a0.r2.dev';
  
  /// Generate the URL for a qiraat page
  static String getPageUrl(String qiraatId, int pageNumber) {
    final pageNum = pageNumber.toString().padLeft(3, '0');
    return '$baseUrl/$qiraatId/page_$pageNum.jpg';
  }
  
  /// Check if qiraat is available (all qiraats are available via GitHub)
  static bool isQiraatAvailable(String qiraatId) {
    // All qiraats are available via GitHub - no download needed!
    return getAvailableQiraats().contains(qiraatId);
  }
  
  /// Get all available qiraats from GitHub repo
  /// These match the folder names in https://github.com/Zuper4/mushaf-qiraats
  static List<String> getAvailableQiraats() {
    return [
      // 'asim_hafs' is bundled as assets, not needed from GitHub
      'abu_amr_duri',
      'abu_amr_sussi',
      'abu_jafar_ibn_jammaz',
      'abu_jafar_ibn_wardan',
      'asim_shuba',
      'hamzah_khalaad',
      'hamzah_khalaf',
      'ibn_amir_dhakwan',
      'ibn_amir_hisham',
      'ibn_kathir_bazzi',
      'ibn_kathir_qunbul',
      'khalaf_idris',
      'khalaf_ishaq',
      'kisai_abu_harith',
      'kisai_duri',
      'nafi_qalun',
      'nafi_warsh',
      'yaqub_rawh',
      'yaqub_ruways',
    ];
  }
}