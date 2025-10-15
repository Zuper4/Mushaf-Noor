class Qiraat {
  final String id; // Format: "qari_rawi" (e.g., "asim_hafs")
  final String qariName; // The Qari name (e.g., "Asim")
  final String rawiName; // The Rawi name (e.g., "Hafs")
  final String name; // Combined name (e.g., "Hafs 'an 'Asim")
  final String arabicName;
  final String qariArabicName; // Qari name in Arabic
  final String rawiArabicName; // Rawi name in Arabic
  final String description;
  final String colorCode; // For highlighting differences from Hafs
  final bool isDownloaded;
  final double downloadProgress;
  final int totalPages;
  final String folderPath; // Path to the Qari folder

  Qiraat({
    required this.id,
    required this.qariName,
    required this.rawiName,
    required this.name,
    required this.arabicName,
    required this.qariArabicName,
    required this.rawiArabicName,
    required this.description,
    required this.colorCode,
    required this.folderPath,
    this.isDownloaded = false,
    this.downloadProgress = 0.0,
    this.totalPages = 606, // Standard Mushaf page count
  });

  factory Qiraat.fromJson(Map<String, dynamic> json) {
    return Qiraat(
      id: json['id'],
      qariName: json['qariName'],
      rawiName: json['rawiName'],
      name: json['name'],
      arabicName: json['arabicName'],
      qariArabicName: json['qariArabicName'],
      rawiArabicName: json['rawiArabicName'],
      description: json['description'],
      colorCode: json['colorCode'],
      folderPath: json['folderPath'],
      isDownloaded: json['isDownloaded'] ?? false,
      downloadProgress: json['downloadProgress']?.toDouble() ?? 0.0,
      totalPages: json['totalPages'] ?? 606,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qariName': qariName,
      'rawiName': rawiName,
      'name': name,
      'arabicName': arabicName,
      'qariArabicName': qariArabicName,
      'rawiArabicName': rawiArabicName,
      'description': description,
      'colorCode': colorCode,
      'folderPath': folderPath,
      'isDownloaded': isDownloaded,
      'downloadProgress': downloadProgress,
      'totalPages': totalPages,
    };
  }

  Qiraat copyWith({
    String? id,
    String? qariName,
    String? rawiName,
    String? name,
    String? arabicName,
    String? qariArabicName,
    String? rawiArabicName,
    String? description,
    String? colorCode,
    String? folderPath,
    bool? isDownloaded,
    double? downloadProgress,
    int? totalPages,
  }) {
    return Qiraat(
      id: id ?? this.id,
      qariName: qariName ?? this.qariName,
      rawiName: rawiName ?? this.rawiName,
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      qariArabicName: qariArabicName ?? this.qariArabicName,
      rawiArabicName: rawiArabicName ?? this.rawiArabicName,
      description: description ?? this.description,
      colorCode: colorCode ?? this.colorCode,
      folderPath: folderPath ?? this.folderPath,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  // Predefined list of all 20 Qiraats (10 Qaris × 2 Rawis each)
  static final List<Qiraat> allQiraats = [
    // Nafi' from Madinah
    Qiraat(
      id: 'nafi_qalun',
      qariName: 'Nafi\'',
      rawiName: 'Qalun',
      name: 'Qalun \'an Nafi\'',
      arabicName: 'قالون عن نافع',
      qariArabicName: 'نافع',
      rawiArabicName: 'قالون',
      description: 'The recitation of Imam Nafi\' from Madinah through his student Qalun',
      colorCode: '#2E8B57', // Sea Green
      folderPath: 'assets/images/qiraats/nafi_qalun',
    ),
    Qiraat(
      id: 'nafi_warsh',
      qariName: 'Nafi\'',
      rawiName: 'Warsh',
      name: 'Warsh \'an Nafi\'',
      arabicName: 'ورش عن نافع',
      qariArabicName: 'نافع',
      rawiArabicName: 'ورش',
      description: 'The recitation of Imam Nafi\' from Madinah through his student Warsh, widely used in North and West Africa',
      colorCode: '#4682B4', // Steel Blue
      folderPath: 'assets/images/qiraats/nafi_warsh',
    ),

    // Ibn Kathir from Makkah
    Qiraat(
      id: 'ibn_kathir_bazzi',
      qariName: 'Ibn Kathir',
      rawiName: 'Al-Bazzi',
      name: 'Al-Bazzi \'an Ibn Kathir',
      arabicName: 'البزي عن ابن كثير',
      qariArabicName: 'ابن كثير',
      rawiArabicName: 'البزي',
      description: 'The recitation of Ibn Kathir from Makkah through his student Al-Bazzi',
      colorCode: '#CD853F', // Peru
      folderPath: 'assets/images/qiraats/ibn_kathir_bazzi',
    ),
    Qiraat(
      id: 'ibn_kathir_qunbul',
      qariName: 'Ibn Kathir',
      rawiName: 'Qunbul',
      name: 'Qunbul \'an Ibn Kathir',
      arabicName: 'قنبل عن ابن كثير',
      qariArabicName: 'ابن كثير',
      rawiArabicName: 'قنبل',
      description: 'The recitation of Ibn Kathir from Makkah through his student Qunbul',
      colorCode: '#DAA520', // Goldenrod
      folderPath: 'assets/images/qiraats/ibn_kathir_qunbul',
    ),

    // Abu 'Amr from Basra
    Qiraat(
      id: 'abu_amr_duri',
      qariName: 'Abu \'Amr',
      rawiName: 'Ad-Duri',
      name: 'Ad-Duri \'an Abu \'Amr',
      arabicName: 'الدوري عن أبي عمرو',
      qariArabicName: 'أبو عمرو',
      rawiArabicName: 'الدوري',
      description: 'The recitation of Abu \'Amr from Basra through his student Ad-Duri',
      colorCode: '#8B4513', // Saddle Brown
      folderPath: 'assets/images/qiraats/abu_amr_duri',
    ),
    Qiraat(
      id: 'abu_amr_sussi',
      qariName: 'Abu \'Amr',
      rawiName: 'As-Sussi',
      name: 'As-Sussi \'an Abu \'Amr',
      arabicName: 'السوسي عن أبي عمرو',
      qariArabicName: 'أبو عمرو',
      rawiArabicName: 'السوسي',
      description: 'The recitation of Abu \'Amr from Basra through his student As-Sussi',
      colorCode: '#A0522D', // Sienna
      folderPath: 'assets/images/qiraats/abu_amr_sussi',
    ),

    // Ibn 'Amir from Damascus
    Qiraat(
      id: 'ibn_amir_hisham',
      qariName: 'Ibn \'Amir',
      rawiName: 'Hisham',
      name: 'Hisham \'an Ibn \'Amir',
      arabicName: 'هشام عن ابن عامر',
      qariArabicName: 'ابن عامر',
      rawiArabicName: 'هشام',
      description: 'The recitation of Ibn \'Amir from Damascus through his student Hisham',
      colorCode: '#556B2F', // Dark Olive Green
      folderPath: 'assets/images/qiraats/ibn_amir_hisham',
    ),
    Qiraat(
      id: 'ibn_amir_dhakwan',
      qariName: 'Ibn \'Amir',
      rawiName: 'Ibn Dhakwan',
      name: 'Ibn Dhakwan \'an Ibn \'Amir',
      arabicName: 'ابن ذكوان عن ابن عامر',
      qariArabicName: 'ابن عامر',
      rawiArabicName: 'ابن ذكوان',
      description: 'The recitation of Ibn \'Amir from Damascus through his student Ibn Dhakwan',
      colorCode: '#6B8E23', // Olive Drab
      folderPath: 'assets/images/qiraats/ibn_amir_dhakwan',
    ),

    // 'Asim from Kufa
    Qiraat(
      id: 'asim_shuba',
      qariName: '\'Asim',
      rawiName: 'Shu\'ba',
      name: 'Shu\'ba \'an \'Asim',
      arabicName: 'شعبة عن عاصم',
      qariArabicName: 'عاصم',
      rawiArabicName: 'شعبة',
      description: 'The recitation of \'Asim from Kufa through his student Shu\'ba',
      colorCode: '#483D8B', // Dark Slate Blue
      folderPath: 'assets/images/qiraats/asim_shuba',
    ),
    Qiraat(
      id: 'asim_hafs',
      qariName: '\'Asim',
      rawiName: 'Hafs',
      name: 'Hafs \'an \'Asim',
      arabicName: 'حفص عن عاصم',
      qariArabicName: 'عاصم',
      rawiArabicName: 'حفص',
      description: 'The most widely used recitation today. The recitation of \'Asim from Kufa through his student Hafs',
      colorCode: '#32CD32', // Lime Green (most common)
      folderPath: 'assets/images/qiraats/asim_hafs',
    ),

    // Hamzah from Kufa
    Qiraat(
      id: 'hamzah_khalaad',
      qariName: 'Hamzah',
      rawiName: 'Khalaad',
      name: 'Khalaad \'an Hamzah',
      arabicName: 'خلاد عن حمزة',
      qariArabicName: 'حمزة',
      rawiArabicName: 'خلاد',
      description: 'The recitation of Hamzah from Kufa through his student Khalaad',
      colorCode: '#DC143C', // Crimson
      folderPath: 'assets/images/qiraats/hamzah_khalaad',
    ),
    Qiraat(
      id: 'hamzah_khalaf',
      qariName: 'Hamzah',
      rawiName: 'Khalaf',
      name: 'Khalaf \'an Hamzah',
      arabicName: 'خلف عن حمزة',
      qariArabicName: 'حمزة',
      rawiArabicName: 'خلف',
      description: 'The recitation of Hamzah from Kufa through his student Khalaf',
      colorCode: '#B22222', // Fire Brick
      folderPath: 'assets/images/qiraats/hamzah_khalaf',
    ),

    // Al-Kisa'i from Kufa
    Qiraat(
      id: 'kisai_abu_harith',
      qariName: 'Al-Kisa\'i',
      rawiName: 'Abu al-Harith',
      name: 'Abu al-Harith \'an al-Kisa\'i',
      arabicName: 'أبو الحارث عن الكسائي',
      qariArabicName: 'الكسائي',
      rawiArabicName: 'أبو الحارث',
      description: 'The recitation of Al-Kisa\'i from Kufa through his student Abu al-Harith',
      colorCode: '#800080', // Purple
      folderPath: 'assets/images/qiraats/kisai_abu_harith',
    ),
    Qiraat(
      id: 'kisai_duri',
      qariName: 'Al-Kisa\'i',
      rawiName: 'Ad-Duri',
      name: 'Ad-Duri \'an al-Kisa\'i',
      arabicName: 'الدوري عن الكسائي',
      qariArabicName: 'الكسائي',
      rawiArabicName: 'الدوري',
      description: 'The recitation of Al-Kisa\'i from Kufa through his student Ad-Duri',
      colorCode: '#9932CC', // Dark Orchid
      folderPath: 'assets/images/qiraats/kisai_duri',
    ),

    // Abu Ja'far from Madinah
    Qiraat(
      id: 'abu_jafar_ibn_wardan',
      qariName: 'Abu Ja\'far',
      rawiName: 'Ibn Wardan',
      name: 'Ibn Wardan \'an Abu Ja\'far',
      arabicName: 'ابن وردان عن أبي جعفر',
      qariArabicName: 'أبو جعفر',
      rawiArabicName: 'ابن وردان',
      description: 'The recitation of Abu Ja\'far from Madinah through his student Ibn Wardan',
      colorCode: '#FF8C00', // Dark Orange
      folderPath: 'assets/images/qiraats/abu_jafar_ibn_wardan',
    ),
    Qiraat(
      id: 'abu_jafar_ibn_jammaz',
      qariName: 'Abu Ja\'far',
      rawiName: 'Ibn Jammaz',
      name: 'Ibn Jammaz \'an Abu Ja\'far',
      arabicName: 'ابن جماز عن أبي جعفر',
      qariArabicName: 'أبو جعفر',
      rawiArabicName: 'ابن جماز',
      description: 'The recitation of Abu Ja\'far from Madinah through his student Ibn Jammaz',
      colorCode: '#FF6347', // Tomato
      folderPath: 'assets/images/qiraats/abu_jafar_ibn_jammaz',
    ),

    // Ya'qub from Basra
    Qiraat(
      id: 'yaqub_ruways',
      qariName: 'Ya\'qub',
      rawiName: 'Ruways',
      name: 'Ruways \'an Ya\'qub',
      arabicName: 'رويس عن يعقوب',
      qariArabicName: 'يعقوب',
      rawiArabicName: 'رويس',
      description: 'The recitation of Ya\'qub from Basra through his student Ruways',
      colorCode: '#4169E1', // Royal Blue
      folderPath: 'assets/images/qiraats/yaqub_ruways',
    ),
    Qiraat(
      id: 'yaqub_rawh',
      qariName: 'Ya\'qub',
      rawiName: 'Rawh',
      name: 'Rawh \'an Ya\'qub',
      arabicName: 'روح عن يعقوب',
      qariArabicName: 'يعقوب',
      rawiArabicName: 'روح',
      description: 'The recitation of Ya\'qub from Basra through his student Rawh',
      colorCode: '#0000CD', // Medium Blue
      folderPath: 'assets/images/qiraats/yaqub_rawh',
    ),

    // Khalaf al-'Ashir
    Qiraat(
      id: 'khalaf_ishaq',
      qariName: 'Khalaf',
      rawiName: 'Ishaq',
      name: 'Ishaq \'an Khalaf',
      arabicName: 'إسحاق عن خلف',
      qariArabicName: 'خلف',
      rawiArabicName: 'إسحاق',
      description: 'The recitation of Khalaf al-\'Ashir through his student Ishaq',
      colorCode: '#8A2BE2', // Blue Violet
      folderPath: 'assets/images/qiraats/khalaf_ishaq',
    ),
    Qiraat(
      id: 'khalaf_idris',
      qariName: 'Khalaf',
      rawiName: 'Idris',
      name: 'Idris \'an Khalaf',
      arabicName: 'إدريس عن خلف',
      qariArabicName: 'خلف',
      rawiArabicName: 'إدريس',
      description: 'The recitation of Khalaf al-\'Ashir through his student Idris',
      colorCode: '#9370DB', // Medium Purple
      folderPath: 'assets/images/qiraats/khalaf_idris',
    ),
  ];

  // Helper methods
  static List<String> get allQariNames => allQiraats.map((q) => q.qariName).toSet().toList();
  
  static List<Qiraat> getQiraatsByQari(String qariName) => 
      allQiraats.where((q) => q.qariName == qariName).toList();
      
  static Qiraat? getQiraatById(String id) {
    try {
      return allQiraats.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }
}