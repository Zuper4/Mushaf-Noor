class GitHubQiraatService {
  // Cloudflare R2 URL for mushaf-qiraats repository
  static const String baseUrl = 'https://pub-908424a64cd948adab8cb072f37d26a0.r2.dev';
  
  // Version number for cache busting when images are updated
  // Increment this whenever you replace images in the R2 bucket
  static const String imageVersion = 'v2';
  
  /// Map internal qiraat IDs to R2 folder names
  static String _getR2FolderName(String qiraatId) {
    const folderMapping = {
      'asim_hafs': 'Hafs_An_3asim',
      'abu_amr_duri': 'Ad-Duri_An_Abu_3amr',
      'abu_amr_sussi': 'As-Sussi_An_Abu_3amr',
      'abu_jafar_ibn_jammaz': 'Ibn_Jammaaz_An_Abu_Ja3far',
      'abu_jafar_ibn_wardan': 'Ibn_Wardaan_An_Abu_Ja3far',
      'asim_shuba': 'Shu3ba_An_3asim',
      'hamzah_khalaad': 'Khalaad_An_Hamzah',
      'hamzah_khalaf': 'Khalaf_An_Hamzah',
      'ibn_amir_dhakwan': 'Ibn_Dhakwan_An_Ibn_3amir',
      'ibn_amir_hisham': 'Hisham_An_Ibn_3amir',
      'ibn_kathir_bazzi': 'Al-Bazzi_Ibn_Kathir',
      'ibn_kathir_qunbul': 'Qunbul_An_IbnKathir',
      'khalaf_idris': 'Idris_An_Khalaf',
      'khalaf_ishaq': 'Ishaq_An_Khalaf',
      'kisai_abu_harith': 'Abu_Al-Harith_An_Al-Kisaae',
      'kisai_duri': 'Ad-Duri_An_Al-Kisaae',
      'nafi_qalun': 'Qalun_An_Nafi3',
      'nafi_warsh': 'Warsh_An_Nafi3',
      'yaqub_rawh': 'Rawh_An_Ya3qub',
      'yaqub_ruways': 'Ruwais_An_Ya3qub',
    };
    return folderMapping[qiraatId] ?? qiraatId;
  }
  
  /// Generate the URL for a qiraat page
  static String getPageUrl(String qiraatId, int pageNumber) {
    final folderName = _getR2FolderName(qiraatId);
    return '$baseUrl/$folderName/page_$pageNumber.png?v=$imageVersion';
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
      'asim_hafs', // Now also loaded from R2 with updated images
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