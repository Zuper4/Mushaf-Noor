import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static AppLocalizations of(context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return AppLocalizations(appState.languageCode);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App Title
      'app_title': 'Mus7af An Noor',
      
      // Home Screen
      'current_qiraat': 'Current Qiraat',
      'quick_actions': 'Quick Actions',
      'continue_reading': 'Continue Reading',
      'page_number': 'Page',
      'qiraats': 'Qiraats',
      'available_count': 'available',
      'go_to_page': 'Go to Page',
      'from_1_to_604': 'From 1 to 604',
      'settings': 'Settings',
      'reading_features': 'Reading Features',
      'recent_pages': 'Recent Pages',
      'bookmarks': 'Bookmarks',
      'no_bookmarks': 'No bookmarks yet',
      'no_bookmarks_desc': 'Tap the bookmark icon while reading to save pages',
      'app_language': 'Language',
      'select_language': 'Select Language',
      'no_qiraat_selected': 'No qiraat selected',
      
      // Navigation
      'cancel': 'Cancel',
      'go': 'Go',
      'page_number_hint': 'Page number (1-606)',
      
      // Qiraat Selection
      'available_qiraats': 'Available Riwayats',
      'active_downloads': 'Active Downloads',
      'storage': 'Storage',
      'download': 'Download',
      'delete': 'Delete',
      'download_qiraat': 'Download Riwayat',
      'download_confirmation': 'Do you want to download',
      'size_mb': 'Size: {0} MB approximately',
      'total_pages': '606 pages',
      'delete_qiraat': 'Delete Qiraat',
      'delete_confirmation': 'Do you want to delete {0} from the device?\n\nAll saved pages will be deleted.',
      'qiraat_downloaded': '{0} has been downloaded',
      'qiraat_deleted': '{0} has been deleted',
      'important_info': 'Important Information',
      'qiraat_info': '• Each riwayat can be accessed instantly with WiFi, no download required.\n• You can download any riwayat for offline use.\n• Each download is about 50 MB.\n• Colors indicate differences from Hafs.\n• Hafs riwayat is available by default and cannot be deleted.',
      
      // Qiraat Explanation
      'what_are_qiraats': 'What are the Qira\'at (The Canonical Recitations)?',
      'qiraats_explanation': 'The Qira\'at (singular: Qira\'ah) are the ten authentic and distinct methods of reciting the Holy Qur\'an, which trace back through an unbroken chain of reliable narrators directly to the Prophet Muhammad (PBUH).\n\nThese are not different versions of the Qur\'an; they are diverse linguistic, phonetic, and rhythmic styles of recitation, all of which are considered divinely revealed and authentic.',
      'riwayat_title': 'The Riwayāt (Narrations)',
      'riwayat_explanation': 'Each of the ten major Qira\'at is primarily conveyed through two major narrations, known as Riwayāt. A Riwayah is the specific, authenticated transmission route from a primary Qari (Reciter/Imam). For instance, the most common recitation worldwide is the Riwayah of Hafs from the Qira\'ah of Imam \'Āsim.',
      'app_feature_note': 'App Feature Note',
      'app_feature_explanation': 'This app allows you to explore the beauty of the Qur\'an by listening to and comparing recitations from multiple authenticated Qira\'at, including the Riwayāt of Hafs, Warsh, and others.',
      
      // Home Screen
      'search_surahs': 'Search surahs...',
      
      // Page Navigation
      'page_label': 'Page',
      'of_label': 'of',
      'select_page': 'Select a page to navigate',
      
      // Settings
      'reading_settings': 'Reading Settings',
      'font_size': 'Font Size',
      'small': 'Small',
      'large': 'Large',
      'font_sample': 'Sample text with selected size',
      'font_type': 'Font Type',
      'uthmanic_font': 'Uthmanic Font',
      'amiri_font': 'Amiri Font',
      'dark_mode': 'Dark Mode',
      'dark_mode_desc': 'Helps with reading in low light',
      'show_translation': 'Show Translation',
      'show_translation_desc': 'Display translation with Arabic text',
      'storage_settings': 'Storage Settings',
      'storage_info': 'Storage Information',
      'storage_used': 'Storage Used:',
      'qiraats_downloaded': 'Downloaded Qiraats:',
      'clear_cache': 'Clear Cache',
      'clear_cache_desc': 'Delete temporary files and download history',
      'app_settings': 'App Settings',
      'bookmarks_and_history': 'Bookmarks & History',
      'reset_settings': 'Reset Settings',
      'reset_settings_desc': 'Restore default settings',
      'about_app': 'About the App',
      'version': 'Version 1.0.0',
      'app_description': 'An app for reading the Holy Quran with different qiraats and downloadable content as needed.',
      'built_with_flutter': 'Built with Flutter',
      'reset_confirmation': 'Reset Settings',
      'reset_warning': 'Are you sure you want to reset all settings?\\nAll current customizations will be lost.',
      'reset_success': 'Settings have been reset successfully',
      'language': 'Language',
      'english': 'English',
      'arabic': 'العربية',
      
      // PDF Reader
      'pdf_not_found': 'PDF file not found for this qiraat',
      'go_back': 'Go Back',
      'page_number_format': 'Page {0} of {1}',
      'go_to_page_dialog': 'Go to Page',
      'surahs_list': 'Surahs',
      'ayah_count': '{0} verses',
      
      // Reading Screen
      'quick_settings': 'Quick Settings',
      'night_mode': 'Night Mode',
      'select_qiraat': 'Select Qiraat',
      'download_failed': 'Download failed: {0}',
      'resume_failed': 'Resume failed: {0}',
      
      // Download Status
      'not_started': 'Not started',
      'starting_download': 'Starting download...',
      'downloading': 'Downloading page {0} of {1}',
      'download_completed': 'Download completed',
      'download_cancelled': 'Download cancelled',
      'download_paused': 'Download paused',
      'resuming_download': 'Resuming download...',
      
      // Storage Info
      'storage_info_title': 'Storage Information',
      'total_storage_used': 'Total storage used: {0} MB',
      'estimated_size_per_qiraat': 'Estimated size per riwayat: 50 MB',
      'ok': 'OK',
      
      // Error Messages
      'error_loading_page': 'Error loading page',
      'failed_to_load_page_image': 'Failed to load page image',
      'page_content_unavailable': 'Page content unavailable',
      'ensure_qiraat_downloaded': 'Please ensure {0} is downloaded',
      'loading_page': 'Loading page...',
      
      // Placeholder Content
      'bismillah': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      
      // Audio Player
      'play_whole_surah': 'Play Whole Surah',
      'play_the_page': 'Play the Page',
      'play_ayah_range': 'Play Ayah Range',
      'play_range': 'Play Range',
      'from': 'From',
      'to': 'To',
      'ayah': 'Ayah',
      'surah': 'Surah',
      'playing_ayah': 'Playing Ayah {0}',
      'playing_range': 'Playing from Ayah {0} to {1}',
      'please_select_qiraat': 'Please select a Qiraat first',
      'showing_all_ayahs': 'Showing all',
      'showing_ayahs_on_page': 'Showing ayahs on page:',
      'choose_surah': 'Choose Surah',
      
      // Offline Mode
      'no_internet_connection': 'No Internet Connection',
      'offline_riwayat_message': 'You need an active internet connection to access this riwayat. Please connect to WiFi or mobile data to stream, or download it for offline use.',
      'connect_to_internet': 'Connect to Internet',
    },
    'ar': {
      // App Title
      'app_title': 'مصحف نور',
      
      // Home Screen
      'current_qiraat': 'القراءة الحالية',
      'quick_actions': 'الإجراءات السريعة',
      'continue_reading': 'متابعة القراءة',
      'page_number': 'الصفحة',
      'qiraats': 'القراءات',
      'available_count': 'متاحة',
      'from_1_to_604': 'من 1 إلى 604',
      'settings': 'الإعدادات',
      'reading_features': 'خصائص القراءة',
      'recent_pages': 'الصفحات الأخيرة',
      'bookmarks': 'المحفوظات',
      'no_bookmarks': 'لا توجد محفوظات بعد',
      'no_bookmarks_desc': 'انقر على أيقونة الحفظ أثناء القراءة لحفظ الصفحات',
      'app_language': 'اللغة',
      'select_language': 'اختر اللغة',
      'no_qiraat_selected': 'لم يتم اختيار قراءة',
      
      // Navigation
      'cancel': 'إلغاء',
      'go': 'اذهب',
      'page_number_hint': 'رقم الصفحة (1-606)',
      
      // Qiraat Selection
      'available_qiraats': 'الروايات المتاحة',
      'active_downloads': 'التنزيلات النشطة',
      'storage': 'التخزين',
      'download': 'تنزيل',
      'delete': 'حذف',
      'download_qiraat': 'تنزيل الرواية',
      'download_confirmation': 'هل تريد تنزيل قراءة',
      'size_mb': 'الحجم: {0} ميجابايت تقريباً',
      'total_pages': '606 صفحة',
      'delete_qiraat': 'حذف القراءة',
      'delete_confirmation': 'هل تريد حذف قراءة {0} من الجهاز؟\n\nسيتم حذف جميع الصفحات المحفوظة.',
      'qiraat_downloaded': 'تم تنزيل قراءة {0}',
      'qiraat_deleted': 'تم حذف قراءة {0}',
      'important_info': 'معلومات مهمة',
      'qiraat_info': '• يمكنك الوصول لكل رواية فوراً عبر الواي فاي بدون تنزيل.\n• يمكنك تنزيل أي رواية للاستخدام بدون إنترنت.\n• كل تنزيل حوالي 50 ميجابايت.\n• الألوان تدل على الاختلافات عن رواية حفص.\n• رواية حفص متاحة افتراضياً ولا يمكن حذفها',
      
      // Qiraat Explanation
      'what_are_qiraats': 'ما هي القراءات القرآنية المتواترة؟',
      'qiraats_explanation': 'القراءات (مفردها: قراءة) هي عشر طرق أصيلة ومتميزة لتلاوة القرآن الكريم، تعود بسلسلة متصلة من الرواة الموثوقين مباشرة إلى النبي محمد صلى الله عليه وسلم.\n\nهذه ليست نسخاً مختلفة من القرآن؛ بل هي أساليب لغوية وصوتية وإيقاعية متنوعة للتلاوة، وكلها تعتبر منزلة من عند الله وأصيلة.',
      'riwayat_title': 'الروايات',
      'riwayat_explanation': 'كل قراءة من القراءات العشر الكبرى تُنقل بشكل رئيسي من خلال روايتين رئيسيتين، تُعرف بالروايات. الرواية هي طريق النقل المحددة والموثقة من قارئ رئيسي (إمام). على سبيل المثال، القراءة الأكثر شيوعاً في جميع أنحاء العالم هي رواية حفص عن الإمام عاصم.',
      'app_feature_note': 'ملاحظة حول ميزة التطبيق',
      'app_feature_explanation': 'يتيح لك هذا التطبيق استكشاف جمال القرآن من خلال الاستماع والمقارنة بين تلاوات من قراءات متعددة موثقة، بما في ذلك روايات حفص وورش وغيرها.',
      
      // Home Screen
      'search_surahs': 'ابحث عن السور...',
      
      // Page Navigation
      'page_label': 'صفحة',
      'of_label': 'من',
      'select_page': 'اختر صفحة للانتقال إليها',
      
      // PDF Reader
      'pdf_not_found': 'لم يتم العثور على ملف PDF لهذه القراءة',
      'go_back': 'العودة',
      'page_number_format': 'الصفحة {0} من {1}',
      'go_to_page_dialog': 'الذهاب إلى صفحة',
      'surahs_list': 'السور',
      'ayah_count': '{0} آية',
      
      // Settings
      'reading_settings': 'إعدادات القراءة',
      'font_size': 'حجم الخط',
      'small': 'صغير',
      'large': 'كبير',
      'font_sample': 'نموذج للنص بالحجم المحدد',
      'font_type': 'نوع الخط',
      'uthmanic_font': 'الخط العثماني',
      'amiri_font': 'خط أميري',
      'dark_mode': 'الوضع الليلي',
      'dark_mode_desc': 'يساعد في القراءة في الإضاءة المنخفضة',
      'show_translation': 'إظهار الترجمة',
      'show_translation_desc': 'عرض الترجمة مع النص العربي',
      'storage_settings': 'إعدارات التخزين',
      'storage_info': 'معلومات التخزين',
      'storage_used': 'المساحة المستخدمة:',
      'qiraats_downloaded': 'القراءات المحملة:',
      'clear_cache': 'مسح ذاكرة التخزين المؤقت',
      'clear_cache_desc': 'حذف الملفات المؤقتة وتاريخ التنزيل',
      'app_settings': 'إعدادات التطبيق',
      'bookmarks_and_history': 'المحفوظات والتاريخ',
      'reset_settings': 'إعادة تعيين الإعدادات',
      'reset_settings_desc': 'استعادة الإعدادات الافتراضية',
      'about_app': 'حول التطبيق',
      'version': 'الإصدار 1.0.0',
      'app_description': 'تطبيق لقراءة القرآن الكريم بالقراءات المختلفة مع إمكانية تنزيل المحتوى حسب الحاجة.',
      'built_with_flutter': 'تم تطويره بـ Flutter',
      'reset_confirmation': 'إعادة تعيين الإعدادات',
      'reset_warning': 'هل أنت متأكد من إعادة تعيين جميع الإعدادات؟\\nسيتم فقدان جميع التخصيصات الحالية.',
      'reset_success': 'تم إعادة تعيين الإعدادات بنجاح',
      'language': 'اللغة',
      'english': 'English',
      'arabic': 'العربية',
      
      // Reading Screen
      'quick_settings': 'إعدادات سريعة',
      'night_mode': 'الوضع الليلي',
      'select_qiraat': 'اختر القراءة',
      'download_failed': 'فشل التنزيل: {0}',
      'resume_failed': 'فشل الاستكمال: {0}',
      
      // Download Status
      'not_started': 'لم يبدأ',
      'starting_download': 'بدء التنزيل...',
      'downloading': 'تنزيل صفحة {0} من {1}',
      'download_completed': 'اكتمل التنزيل',
      'download_cancelled': 'تم إلغاء التنزيل',
      'download_paused': 'تم إيقاف التنزيل مؤقتاً',
      'resuming_download': 'استكمال التنزيل...',
      
      // Storage Info
      'storage_info_title': 'معلومات التخزين',
      'total_storage_used': 'المساحة المستخدمة: {0} ميجابايت',
      'estimated_size_per_qiraat': 'المساحة التقديرية لكل رواية: 50 ميجابايت',
      'ok': 'موافق',
      
      // Error Messages
      'error_loading_page': 'خطأ في تحميل الصفحة',
      'failed_to_load_page_image': 'فشل في تحميل صورة الصفحة',
      'page_content_unavailable': 'محتوى الصفحة غير متوفر',
      'ensure_qiraat_downloaded': 'يرجى التأكد من تنزيل قراءة {0}',
      'loading_page': 'جاري تحميل الصفحة...',
      
      // Placeholder Content
      'bismillah': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      
      // Audio Player
      'play_whole_surah': 'تشغيل السورة كاملة',
      'play_the_page': 'تشغيل الصفحة',
      'play_ayah_range': 'تشغيل نطاق من الآيات',
      'play_range': 'تشغيل النطاق',
      'from': 'من',
      'to': 'إلى',
      'ayah': 'الآية',
      'surah': 'سورة',
      'playing_ayah': 'تشغيل الآية {0}',
      'playing_range': 'تشغيل من الآية {0} إلى {1}',
      'please_select_qiraat': 'الرجاء اختيار قراءة أولاً',
      'showing_all_ayahs': 'عرض جميع',
      'showing_ayahs_on_page': 'عرض الآيات في الصفحة:',
      'choose_surah': 'اختر السورة',
      
      // Offline Mode
      'no_internet_connection': 'لا يوجد اتصال بالإنترنت',
      'offline_riwayat_message': 'تحتاج إلى اتصال نشط بالإنترنت للوصول إلى هذه الرواية. يرجى الاتصال بالواي فاي أو بيانات الجوال للبث، أو قم بتنزيلها للاستخدام دون اتصال.',
      'connect_to_internet': 'الاتصال بالإنترنت',
    },
    'fr': {
      // App Title
      'app_title': 'Mus7af An Noor',
      
      // Home Screen
      'current_qiraat': 'Qiraat Actuelle',
      'quick_actions': 'Actions Rapides',
      'continue_reading': 'Continuer la Lecture',
      'page_number': 'Page',
      'qiraats': 'Qiraats',
      'available_count': 'disponible',
      'go_to_page': 'Aller à la Page',
      'from_1_to_604': 'De 1 à 604',
      'settings': 'Paramètres',
      'reading_features': 'Fonctionnalités de Lecture',
      'recent_pages': 'Pages Récentes',
      'bookmarks': 'Signets',
      'no_bookmarks': 'Aucun signet pour le moment',
      'no_bookmarks_desc': 'Appuyez sur l\'icône de signet pendant la lecture pour enregistrer des pages',
      'app_language': 'Langue',
      'select_language': 'Sélectionner la Langue',
      'no_qiraat_selected': 'Aucune qiraat sélectionnée',
      
      // Navigation
      'cancel': 'Annuler',
      'go': 'Aller',
      'page_number_hint': 'Numéro de page (1-606)',
      
      // Qiraat Selection
      'available_qiraats': 'Riwayats Disponibles',
      'active_downloads': 'Téléchargements Actifs',
      'storage': 'Stockage',
      'download': 'Télécharger',
      'delete': 'Supprimer',
      'download_qiraat': 'Télécharger Riwayat',
      'download_confirmation': 'Voulez-vous télécharger',
      'size_mb': 'Taille: {0} Mo environ',
      'total_pages': '606 pages',
      'delete_qiraat': 'Supprimer Qiraat',
      'delete_confirmation': 'Voulez-vous supprimer {0} de l\'appareil?\n\nToutes les pages enregistrées seront supprimées.',
      'qiraat_downloaded': '{0} a été téléchargé',
      'qiraat_deleted': '{0} a été supprimé',
      'important_info': 'Informations Importantes',
      'qiraat_info': '• Chaque riwayat peut être consulté instantanément avec le WiFi, aucun téléchargement requis.\n• Vous pouvez télécharger n\'importe quel riwayat pour une utilisation hors ligne.\n• Chaque téléchargement fait environ 50 Mo.\n• Les couleurs indiquent les différences par rapport à Hafs.\n• Le riwayat Hafs est disponible par défaut et ne peut pas être supprimé.',
      
      // Qiraat Explanation
      'what_are_qiraats': 'Que sont les Qira\'at (Les Récitations Canoniques)?',
      'qiraats_explanation': 'Les Qira\'at (singulier: Qira\'ah) sont les dix méthodes authentiques et distinctes de récitation du Saint Coran, qui remontent par une chaîne ininterrompue de narrateurs fiables directement au Prophète Muhammad (PSL).\n\nCe ne sont pas des versions différentes du Coran; ce sont des styles linguistiques, phonétiques et rythmiques diversifiés de récitation, tous considérés comme révélés divinement et authentiques.',
      'riwayat_title': 'Les Riwayāt (Narrations)',
      'riwayat_explanation': 'Chacune des dix principales Qira\'at est principalement transmise à travers deux narrations majeures, connues sous le nom de Riwayāt. Une Riwayah est la voie de transmission spécifique et authentifiée d\'un Qari principal (Récitateur/Imam). Par exemple, la récitation la plus courante dans le monde est la Riwayah de Hafs de la Qira\'ah de l\'Imam \'Āsim.',
      'app_feature_note': 'Note',
      'app_feature_explanation': 'Cette application vous permet d\'explorer la beauté du Coran en écoutant et en comparant des récitations de plusieurs Qira\'at authentifiées, y compris les Riwayāt de Hafs, Warsh et autres.',
      
      // Home Screen
      'search_surahs': 'Rechercher des sourates...',
      
      // Page Navigation
      'page_label': 'Page',
      'of_label': 'de',
      'select_page': 'Sélectionner une page pour naviguer',
      
      // Settings
      'reading_settings': 'Paramètres de Lecture',
      'font_size': 'Taille de Police',
      'small': 'Petit',
      'large': 'Grand',
      'font_sample': 'Exemple de texte avec la taille sélectionnée',
      'font_type': 'Type de Police',
      'uthmanic_font': 'Police Othmanienne',
      'amiri_font': 'Police Amiri',
      'dark_mode': 'Mode Sombre',
      'dark_mode_desc': 'Aide à la lecture en faible luminosité',
      'show_translation': 'Afficher la Traduction',
      'show_translation_desc': 'Afficher la traduction avec le texte arabe',
      'storage_settings': 'Paramètres de Stockage',
      'storage_info': 'Informations de Stockage',
      'storage_used': 'Stockage Utilisé:',
      'qiraats_downloaded': 'Qiraats Téléchargées:',
      'clear_cache': 'Vider le Cache',
      'clear_cache_desc': 'Supprimer les fichiers temporaires et l\'historique de téléchargement',
      'app_settings': 'Paramètres de l\'Application',
      'bookmarks_and_history': 'Signets et Historique',
      'reset_settings': 'Réinitialiser les Paramètres',
      'reset_settings_desc': 'Restaurer les paramètres par défaut',
      'about_app': 'À Propos de l\'Application',
      'version': 'Version 1.0.0',
      'app_description': 'Une application pour lire le Saint Coran avec différentes qiraats et du contenu téléchargeable selon les besoins.',
      'built_with_flutter': 'Développé avec Flutter',
      'reset_confirmation': 'Réinitialiser les Paramètres',
      'reset_warning': 'Êtes-vous sûr de vouloir réinitialiser tous les paramètres?\\nToutes les personnalisations actuelles seront perdues.',
      'reset_success': 'Les paramètres ont été réinitialisés avec succès',
      'language': 'Langue',
      'english': 'English',
      'arabic': 'العربية',
      
      // PDF Reader
      'pdf_not_found': 'Fichier PDF introuvable pour cette qiraat',
      'go_back': 'Retour',
      'page_number_format': 'Page {0} de {1}',
      'go_to_page_dialog': 'Aller à la Page',
      'surahs_list': 'Sourates',
      'ayah_count': '{0} versets',
      
      // Reading Screen
      'quick_settings': 'Paramètres Rapides',
      'night_mode': 'Mode Nuit',
      'select_qiraat': 'Sélectionner Qiraat',
      'download_failed': 'Échec du téléchargement: {0}',
      'resume_failed': 'Échec de la reprise: {0}',
      
      // Download Status
      'not_started': 'Non démarré',
      'starting_download': 'Démarrage du téléchargement...',
      'downloading': 'Téléchargement de la page {0} sur {1}',
      'download_completed': 'Téléchargement terminé',
      'download_cancelled': 'Téléchargement annulé',
      'download_paused': 'Téléchargement en pause',
      'resuming_download': 'Reprise du téléchargement...',
      
      // Storage Info
      'storage_info_title': 'Informations de Stockage',
      'total_storage_used': 'Stockage total utilisé: {0} Mo',
      'estimated_size_per_qiraat': 'Taille estimée par riwayat: 50 Mo',
      'ok': 'OK',
      
      // Error Messages
      'error_loading_page': 'Erreur de chargement de la page',
      'failed_to_load_page_image': 'Échec du chargement de l\'image de la page',
      'page_content_unavailable': 'Contenu de la page indisponible',
      'ensure_qiraat_downloaded': 'Veuillez vous assurer que {0} est téléchargé',
      'loading_page': 'Chargement de la page...',
      
      // Placeholder Content
      'bismillah': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      
      // Audio Player
      'play_whole_surah': 'Jouer la Sourate Entière',
      'play_the_page': 'Jouer la Page',
      'play_ayah_range': 'Jouer une Plage d\'Ayahs',
      'play_range': 'Jouer la Plage',
      'from': 'De',
      'to': 'À',
      'ayah': 'Ayah',
      'surah': 'Sourate',
      'playing_ayah': 'Lecture de l\'Ayah {0}',
      'playing_range': 'Lecture de l\'Ayah {0} à {1}',
      'please_select_qiraat': 'Veuillez d\'abord sélectionner une Qiraat',
      'showing_all_ayahs': 'Affichage de tous',
      'showing_ayahs_on_page': 'Affichage des ayahs sur la page:',
      'choose_surah': 'Choisir la Sourate',
      
      // Offline Mode
      'no_internet_connection': 'Pas de Connexion Internet',
      'offline_riwayat_message': 'Vous avez besoin d\'une connexion Internet active pour accéder à ce riwayat. Veuillez vous connecter au WiFi ou aux données mobiles pour diffuser, ou téléchargez-le pour une utilisation hors ligne.',
      'connect_to_internet': 'Se Connecter à Internet',
    },
    'es': {
      // App Title
      'app_title': 'Mus7af An Noor',
      
      // Home Screen
      'current_qiraat': 'Qiraat Actual',
      'quick_actions': 'Acciones Rápidas',
      'continue_reading': 'Continuar Leyendo',
      'page_number': 'Página',
      'qiraats': 'Qiraats',
      'available_count': 'disponible',
      'go_to_page': 'Ir a la Página',
      'from_1_to_604': 'De 1 a 604',
      'settings': 'Configuración',
      'reading_features': 'Funciones de Lectura',
      'recent_pages': 'Páginas Recientes',
      'bookmarks': 'Marcadores',
      'no_bookmarks': 'Aún no hay marcadores',
      'no_bookmarks_desc': 'Toca el ícono de marcador mientras lees para guardar páginas',
      'app_language': 'Idioma',
      'select_language': 'Seleccionar Idioma',
      'no_qiraat_selected': 'No se ha seleccionado qiraat',
      
      // Navigation
      'cancel': 'Cancelar',
      'go': 'Ir',
      'page_number_hint': 'Número de página (1-606)',
      
      // Qiraat Selection
      'available_qiraats': 'Riwayats Disponibles',
      'active_downloads': 'Descargas Activas',
      'storage': 'Almacén',
      'download': 'Descargar',
      'delete': 'Eliminar',
      'download_qiraat': 'Descargar Riwayat',
      'download_confirmation': '¿Quieres descargar',
      'size_mb': 'Tamaño: {0} MB aproximadamente',
      'total_pages': '606 páginas',
      'delete_qiraat': 'Eliminar Qiraat',
      'delete_confirmation': '¿Quieres eliminar {0} del dispositivo?\n\nTodas las páginas guardadas serán eliminadas.',
      'qiraat_downloaded': '{0} ha sido descargado',
      'qiraat_deleted': '{0} ha sido eliminado',
      'important_info': 'Información Importante',
      'qiraat_info': '• Cada riwayat se puede acceder instantáneamente con WiFi, no se requiere descarga.\n• Puedes descargar cualquier riwayat para uso sin conexión.\n• Cada descarga es de aproximadamente 50 MB.\n• Los colores indican diferencias respecto a Hafs.\n• El riwayat Hafs está disponible por defecto y no se puede eliminar.',
      
      // Qiraat Explanation
      'what_are_qiraats': '¿Qué son las Qira\'at (Las Recitaciones Canónicas)?',
      'qiraats_explanation': 'Las Qira\'at (singular: Qira\'ah) son los diez métodos auténticos y distintos de recitar el Sagrado Corán, que se remontan a través de una cadena ininterrumpida de narradores confiables directamente al Profeta Muhammad (la paz sea con él).\n\nEstas no son versiones diferentes del Corán; son estilos lingüísticos, fonéticos y rítmicos diversos de recitación, todos considerados divinamente revelados y auténticos.',
      'riwayat_title': 'Las Riwayāt (Narraciones)',
      'riwayat_explanation': 'Cada una de las diez Qira\'at principales se transmite principalmente a través de dos narraciones principales, conocidas como Riwayāt. Una Riwayah es la ruta de transmisión específica y autenticada de un Qari principal (Recitador/Imam). Por ejemplo, la recitación más común en todo el mundo es la Riwayah de Hafs de la Qira\'ah del Imam \'Āsim.',
      'app_feature_note': 'Nota',
      'app_feature_explanation': 'Esta aplicación te permite explorar la belleza del Corán escuchando y comparando recitaciones de múltiples Qira\'at autenticadas, incluyendo las Riwayāt de Hafs, Warsh y otras.',
      
      // Home Screen
      'search_surahs': 'Buscar suras...',
      
      // Page Navigation
      'page_label': 'Página',
      'of_label': 'de',
      'select_page': 'Seleccionar una página para navegar',
      
      // Settings
      'reading_settings': 'Configuración de Lectura',
      'font_size': 'Tamaño de Fuente',
      'small': 'Pequeño',
      'large': 'Grande',
      'font_sample': 'Texto de muestra con el tamaño seleccionado',
      'font_type': 'Tipo de Fuente',
      'uthmanic_font': 'Fuente Uthmánica',
      'amiri_font': 'Fuente Amiri',
      'dark_mode': 'Modo Oscuro',
      'dark_mode_desc': 'Ayuda con la lectura en poca luz',
      'show_translation': 'Mostrar Traducción',
      'show_translation_desc': 'Mostrar traducción con texto árabe',
      'storage_settings': 'Configuración de Almacenamiento',
      'storage_info': 'Información de Almacenamiento',
      'storage_used': 'Almacenamiento Usado:',
      'qiraats_downloaded': 'Qiraats Descargadas:',
      'clear_cache': 'Limpiar Caché',
      'clear_cache_desc': 'Eliminar archivos temporales e historial de descargas',
      'app_settings': 'Configuración de la Aplicación',
      'bookmarks_and_history': 'Marcadores e Historial',
      'reset_settings': 'Restablecer Configuración',
      'reset_settings_desc': 'Restaurar configuración predeterminada',
      'about_app': 'Acerca de la Aplicación',
      'version': 'Versión 1.0.0',
      'app_description': 'Una aplicación para leer el Sagrado Corán con diferentes qiraats y contenido descargable según sea necesario.',
      'built_with_flutter': 'Desarrollado con Flutter',
      'reset_confirmation': 'Restablecer Configuración',
      'reset_warning': '¿Estás seguro de que quieres restablecer toda la configuración?\\nTodas las personalizaciones actuales se perderán.',
      'reset_success': 'La configuración se ha restablecido con éxito',
      'language': 'Idioma',
      'english': 'English',
      'arabic': 'العربية',
      
      // PDF Reader
      'pdf_not_found': 'Archivo PDF no encontrado para esta qiraat',
      'go_back': 'Volver',
      'page_number_format': 'Página {0} de {1}',
      'go_to_page_dialog': 'Ir a la Página',
      'surahs_list': 'Suras',
      'ayah_count': '{0} versos',
      
      // Reading Screen
      'quick_settings': 'Configuración Rápida',
      'night_mode': 'Modo Nocturno',
      'select_qiraat': 'Seleccionar Qiraat',
      'download_failed': 'Descarga fallida: {0}',
      'resume_failed': 'Reanudación fallida: {0}',
      
      // Download Status
      'not_started': 'No iniciado',
      'starting_download': 'Iniciando descarga...',
      'downloading': 'Descargando página {0} de {1}',
      'download_completed': 'Descarga completada',
      'download_cancelled': 'Descarga cancelada',
      'download_paused': 'Descarga pausada',
      'resuming_download': 'Reanudando descarga...',
      
      // Storage Info
      'storage_info_title': 'Información de Almacenamiento',
      'total_storage_used': 'Almacenamiento total usado: {0} MB',
      'estimated_size_per_qiraat': 'Tamaño estimado por riwayat: 50 MB',
      'ok': 'OK',
      
      // Error Messages
      'error_loading_page': 'Error al cargar la página',
      'failed_to_load_page_image': 'Error al cargar la imagen de la página',
      'page_content_unavailable': 'Contenido de página no disponible',
      'ensure_qiraat_downloaded': 'Por favor asegúrate de que {0} esté descargado',
      'loading_page': 'Cargando página...',
      
      // Placeholder Content
      'bismillah': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      
      // Audio Player
      'play_whole_surah': 'Reproducir Sura Completo',
      'play_the_page': 'Reproducir la Página',
      'play_ayah_range': 'Reproducir Rango de Ayahs',
      'play_range': 'Reproducir Rango',
      'from': 'Desde',
      'to': 'Hasta',
      'ayah': 'Ayah',
      'surah': 'Sura',
      'playing_ayah': 'Reproduciendo Ayah {0}',
      'playing_range': 'Reproduciendo desde Ayah {0} hasta {1}',
      'please_select_qiraat': 'Por favor selecciona primero una Qiraat',
      'showing_all_ayahs': 'Mostrando todos',
      'showing_ayahs_on_page': 'Mostrando ayahs en la página:',
      'choose_surah': 'Elegir Sura',
      
      // Offline Mode
      'no_internet_connection': 'Sin Conexión a Internet',
      'offline_riwayat_message': 'Necesitas una conexión a Internet activa para acceder a este riwayat. Por favor conéctate a WiFi o datos móviles para transmitir, o descárgalo para uso sin conexión.',
      'connect_to_internet': 'Conectar a Internet',
    },
    'hi': {
      // App Title
      'app_title': 'मुस7फ़ अन नूर',
      
      // Home Screen
      'current_qiraat': 'वर्तमान क़िरात',
      'quick_actions': 'त्वरित कार्य',
      'continue_reading': 'पढ़ना जारी रखें',
      'page_number': 'पृष्ठ',
      'qiraats': 'क़िरात',
      'available_count': 'उपलब्ध',
      'go_to_page': 'पृष्ठ पर जाएं',
      'from_1_to_604': '1 से 604 तक',
      'settings': 'सेटिंग्स',
      'reading_features': 'पठन सुविधाएं',
      'recent_pages': 'हाल के पृष्ठ',
      'bookmarks': 'बुकमार्क',
      'no_bookmarks': 'अभी तक कोई बुकमार्क नहीं',
      'no_bookmarks_desc': 'पृष्ठों को सहेजने के लिए पढ़ते समय बुकमार्क आइकन पर टैप करें',
      'app_language': 'भाषा',
      'select_language': 'भाषा चुनें',
      'no_qiraat_selected': 'कोई क़िरात चयनित नहीं',
      
      // Navigation
      'cancel': 'रद्द करें',
      'go': 'जाएं',
      'page_number_hint': 'पृष्ठ संख्या (1-606)',
      
      // Qiraat Selection
      'available_qiraats': 'उपलब्ध रिवायत',
      'active_downloads': 'सक्रिय डाउनलोड',
      'storage': 'संग्रहण',
      'download': 'डाउनलोड',
      'delete': 'हटाएं',
      'download_qiraat': 'रिवायत डाउनलोड करें',
      'download_confirmation': 'क्या आप डाउनलोड करना चाहते हैं',
      'size_mb': 'आकार: लगभग {0} MB',
      'total_pages': '606 पृष्ठ',
      'delete_qiraat': 'क़िरात हटाएं',
      'delete_confirmation': 'क्या आप {0} को डिवाइस से हटाना चाहते हैं?\n\nसभी सहेजे गए पृष्ठ हटा दिए जाएंगे।',
      'qiraat_downloaded': '{0} डाउनलोड हो गया है',
      'qiraat_deleted': '{0} हटा दिया गया है',
      'important_info': 'महत्वपूर्ण जानकारी',
      'qiraat_info': '• प्रत्येक रिवायत को WiFi के साथ तुरंत एक्सेस किया जा सकता है, किसी डाउनलोड की आवश्यकता नहीं।\n• आप ऑफ़लाइन उपयोग के लिए किसी भी रिवायत को डाउनलोड कर सकते हैं।\n• प्रत्येक डाउनलोड लगभग 50 MB का है।\n• रंग हफ्स से अंतर दर्शाते हैं।\n• हफ्स रिवायत डिफ़ॉल्ट रूप से उपलब्ध है और इसे हटाया नहीं जा सकता।',
      
      // Qiraat Explanation
      'what_are_qiraats': 'क़िरात (प्रामाणिक पाठ) क्या हैं?',
      'qiraats_explanation': 'क़िरात (एकवचन: क़िरा\'अह) पवित्र कुरान की पाठ करने की दस प्रामाणिक और विशिष्ट विधियां हैं, जो विश्वसनीय वर्णनकर्ताओं की एक अटूट श्रृंखला के माध्यम से सीधे पैगंबर मुहम्मद (सल्ल०) तक जाती हैं।\n\nये कुरान के विभिन्न संस्करण नहीं हैं; ये पाठ की विविध भाषाई, ध्वन्यात्मक और लयबद्ध शैलियाँ हैं, जो सभी दिव्य रूप से प्रकट और प्रामाणिक मानी जाती हैं।',
      'riwayat_title': 'रिवायत (वर्णन)',
      'riwayat_explanation': 'दस प्रमुख क़िरात में से प्रत्येक मुख्य रूप से दो प्रमुख वर्णनों के माध्यम से प्रसारित होता है, जिन्हें रिवायत के रूप में जाना जाता है। एक रिवायत एक प्राथमिक क़ारी (पाठक/इमाम) से विशिष्ट, प्रमाणित संचरण मार्ग है। उदाहरण के लिए, दुनिया भर में सबसे आम पाठ इमाम आसिम की क़िरात से हफ्स की रिवायत है।',
      'app_feature_note': 'ऐप फ़ीचर नोट',
      'app_feature_explanation': 'यह ऐप आपको कुरान की सुंदरता का पता लगाने की अनुमति देता है, कई प्रमाणित क़िरात से पाठों को सुनकर और तुलना करके, जिसमें हफ्स, वर्श और अन्य की रिवायत शामिल हैं।',
      
      // Home Screen
      'search_surahs': 'सूरह खोजें...',
      
      // Page Navigation
      'page_label': 'पृष्ठ',
      'of_label': 'का',
      'select_page': 'नेविगेट करने के लिए एक पृष्ठ चुनें',
      
      // Settings
      'reading_settings': 'पठन सेटिंग्स',
      'font_size': 'फ़ॉन्ट आकार',
      'small': 'छोटा',
      'large': 'बड़ा',
      'font_sample': 'चयनित आकार के साथ नमूना पाठ',
      'font_type': 'फ़ॉन्ट प्रकार',
      'uthmanic_font': 'उस्मानी फ़ॉन्ट',
      'amiri_font': 'अमीरी फ़ॉन्ट',
      'dark_mode': 'डार्क मोड',
      'dark_mode_desc': 'कम रोशनी में पढ़ने में मदद करता है',
      'show_translation': 'अनुवाद दिखाएं',
      'show_translation_desc': 'अरबी पाठ के साथ अनुवाद प्रदर्शित करें',
      'storage_settings': 'संग्रहण सेटिंग्स',
      'storage_info': 'संग्रहण जानकारी',
      'storage_used': 'उपयोग किया गया संग्रहण:',
      'qiraats_downloaded': 'डाउनलोड किए गए क़िरात:',
      'clear_cache': 'कैश साफ़ करें',
      'clear_cache_desc': 'अस्थायी फ़ाइलें और डाउनलोड इतिहास हटाएं',
      'app_settings': 'ऐप सेटिंग्स',
      'bookmarks_and_history': 'बुकमार्क और इतिहास',
      'reset_settings': 'सेटिंग्स रीसेट करें',
      'reset_settings_desc': 'डिफ़ॉल्ट सेटिंग्स पुनर्स्थापित करें',
      'about_app': 'ऐप के बारे में',
      'version': 'संस्करण 1.0.0',
      'app_description': 'विभिन्न क़िरात के साथ पवित्र कुरान पढ़ने और आवश्यकतानुसार डाउनलोड करने योग्य सामग्री के लिए एक ऐप।',
      'built_with_flutter': 'Flutter के साथ निर्मित',
      'reset_confirmation': 'सेटिंग्स रीसेट करें',
      'reset_warning': 'क्या आप वाकई सभी सेटिंग्स रीसेट करना चाहते हैं?\\nसभी वर्तमान अनुकूलन खो जाएंगे।',
      'reset_success': 'सेटिंग्स सफलतापूर्वक रीसेट हो गई हैं',
      'language': 'भाषा',
      'english': 'English',
      'arabic': 'العربية',
      
      // PDF Reader
      'pdf_not_found': 'इस क़िरात के लिए PDF फ़ाइल नहीं मिली',
      'go_back': 'वापस जाएं',
      'page_number_format': 'पृष्ठ {0} का {1}',
      'go_to_page_dialog': 'पृष्ठ पर जाएं',
      'surahs_list': 'सूरह',
      'ayah_count': '{0} आयतें',
      
      // Reading Screen
      'quick_settings': 'त्वरित सेटिंग्स',
      'night_mode': 'रात मोड',
      'select_qiraat': 'क़िरात चुनें',
      'download_failed': 'डाउनलोड विफल: {0}',
      'resume_failed': 'पुनः आरंभ विफल: {0}',
      
      // Download Status
      'not_started': 'शुरू नहीं हुआ',
      'starting_download': 'डाउनलोड शुरू हो रहा है...',
      'downloading': 'पृष्ठ {0} का {1} डाउनलोड हो रहा है',
      'download_completed': 'डाउनलोड पूर्ण',
      'download_cancelled': 'डाउनलोड रद्द',
      'download_paused': 'डाउनलोड विराम',
      'resuming_download': 'डाउनलोड पुनः आरंभ हो रहा है...',
      
      // Storage Info
      'storage_info_title': 'संग्रहण जानकारी',
      'total_storage_used': 'कुल संग्रहण उपयोग: {0} MB',
      'estimated_size_per_qiraat': 'प्रति रिवायत अनुमानित आकार: 50 MB',
      'ok': 'ठीक है',
      
      // Error Messages
      'error_loading_page': 'पृष्ठ लोड करने में त्रुटि',
      'failed_to_load_page_image': 'पृष्ठ छवि लोड करने में विफल',
      'page_content_unavailable': 'पृष्ठ सामग्री अनुपलब्ध',
      'ensure_qiraat_downloaded': 'कृपया सुनिश्चित करें कि {0} डाउनलोड हो गया है',
      'loading_page': 'पृष्ठ लोड हो रहा है...',
      
      // Placeholder Content
      'bismillah': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      
      // Audio Player
      'play_whole_surah': 'पूरी सूरह बजाएं',
      'play_the_page': 'पृष्ठ बजाएं',
      'play_ayah_range': 'आयत श्रेणी बजाएं',
      'play_range': 'श्रेणी बजाएं',
      'from': 'से',
      'to': 'तक',
      'ayah': 'आयत',
      'surah': 'सूरह',
      'playing_ayah': 'आयत {0} बज रही है',
      'playing_range': 'आयत {0} से {1} तक बज रहा है',
      'please_select_qiraat': 'कृपया पहले एक क़िरात चुनें',
      'showing_all_ayahs': 'सभी दिखा रहे हैं',
      'showing_ayahs_on_page': 'पृष्ठ पर आयतें दिखा रहे हैं:',
      'choose_surah': 'सूरह चुनें',
      
      // Offline Mode
      'no_internet_connection': 'इंटरनेट कनेक्शन नहीं है',
      'offline_riwayat_message': 'इस रिवायत तक पहुंचने के लिए आपको एक सक्रिय इंटरनेट कनेक्शन की आवश्यकता है। कृपया स्ट्रीम करने के लिए WiFi या मोबाइल डेटा से कनेक्ट करें, या ऑफ़लाइन उपयोग के लिए इसे डाउनलोड करें।',
      'connect_to_internet': 'इंटरनेट से कनेक्ट करें',
    },
  };

  String get appTitle => _localizedValues[languageCode]!['app_title']!;
  String get currentQiraat => _localizedValues[languageCode]!['current_qiraat']!;
  String get quickActions => _localizedValues[languageCode]!['quick_actions']!;
  String get continueReading => _localizedValues[languageCode]!['continue_reading']!;
  String get pageNumber => _localizedValues[languageCode]!['page_number']!;
  String get qiraats => _localizedValues[languageCode]!['qiraats']!;
  String get availableCount => _localizedValues[languageCode]!['available_count']!;
  String get goToPage => _localizedValues[languageCode]!['go_to_page']!;
  String get from1To604 => _localizedValues[languageCode]!['from_1_to_604']!;
  String get settings => _localizedValues[languageCode]!['settings']!;
  String get readingFeatures => _localizedValues[languageCode]!['reading_features']!;
  String get recentPages => _localizedValues[languageCode]!['recent_pages']!;
  String get bookmarks => _localizedValues[languageCode]!['bookmarks']!;
  String get noBookmarks => _localizedValues[languageCode]!['no_bookmarks']!;
  String get noBookmarksDesc => _localizedValues[languageCode]!['no_bookmarks_desc']!;
  String get appLanguage => _localizedValues[languageCode]!['app_language']!;
  String get selectLanguage => _localizedValues[languageCode]!['select_language']!;
  String get noQiraatSelected => _localizedValues[languageCode]!['no_qiraat_selected']!;
  String get cancel => _localizedValues[languageCode]!['cancel']!;
  String get go => _localizedValues[languageCode]!['go']!;
  String get pageNumberHint => _localizedValues[languageCode]!['page_number_hint']!;
  String get availableQiraats => _localizedValues[languageCode]!['available_qiraats']!;
  String get activeDownloads => _localizedValues[languageCode]!['active_downloads']!;
  String get storage => _localizedValues[languageCode]!['storage']!;
  String get download => _localizedValues[languageCode]!['download']!;
  String get delete => _localizedValues[languageCode]!['delete']!;
  String get downloadQiraat => _localizedValues[languageCode]!['download_qiraat']!;
  String get downloadConfirmation => _localizedValues[languageCode]!['download_confirmation']!;
  String get sizeMb => _localizedValues[languageCode]!['size_mb']!;
  String get totalPages => _localizedValues[languageCode]!['total_pages']!;
  String get deleteQiraat => _localizedValues[languageCode]!['delete_qiraat']!;
  String get deleteConfirmation => _localizedValues[languageCode]!['delete_confirmation']!;
  String get qiraatDownloaded => _localizedValues[languageCode]!['qiraat_downloaded']!;
  String get qiraatDeleted => _localizedValues[languageCode]!['qiraat_deleted']!;
  String get importantInfo => _localizedValues[languageCode]!['important_info']!;
  String get qiraatInfo => _localizedValues[languageCode]!['qiraat_info']!;
  
  // Qiraat Explanation
  String get whatAreQiraats => _localizedValues[languageCode]!['what_are_qiraats']!;
  String get qiraatsExplanation => _localizedValues[languageCode]!['qiraats_explanation']!;
  String get riwayatTitle => _localizedValues[languageCode]!['riwayat_title']!;
  String get riwayatExplanation => _localizedValues[languageCode]!['riwayat_explanation']!;
  String get appFeatureNote => _localizedValues[languageCode]!['app_feature_note']!;
  String get appFeatureExplanation => _localizedValues[languageCode]!['app_feature_explanation']!;
  
  // Home Screen
  String get searchSurahs => _localizedValues[languageCode]!['search_surahs']!;
  
  // Page Navigation
  String get pageLabel => _localizedValues[languageCode]!['page_label']!;
  String get ofLabel => _localizedValues[languageCode]!['of_label']!;
  String get selectPage => _localizedValues[languageCode]!['select_page']!;
  
  String get readingSettings => _localizedValues[languageCode]!['reading_settings']!;
  String get fontSize => _localizedValues[languageCode]!['font_size']!;
  String get small => _localizedValues[languageCode]!['small']!;
  String get large => _localizedValues[languageCode]!['large']!;
  String get fontSample => _localizedValues[languageCode]!['font_sample']!;
  String get fontType => _localizedValues[languageCode]!['font_type']!;
  String get uthmanicFont => _localizedValues[languageCode]!['uthmanic_font']!;
  String get amiriFont => _localizedValues[languageCode]!['amiri_font']!;
  String get darkMode => _localizedValues[languageCode]!['dark_mode']!;
  String get darkModeDesc => _localizedValues[languageCode]!['dark_mode_desc']!;
  String get showTranslation => _localizedValues[languageCode]!['show_translation']!;
  String get showTranslationDesc => _localizedValues[languageCode]!['show_translation_desc']!;
  String get storageSettings => _localizedValues[languageCode]!['storage_settings']!;
  String get storageInfo => _localizedValues[languageCode]!['storage_info']!;
  String get storageUsed => _localizedValues[languageCode]!['storage_used']!;
  String get qiraatsDownloaded => _localizedValues[languageCode]!['qiraats_downloaded']!;
  String get clearCache => _localizedValues[languageCode]!['clear_cache']!;
  String get clearCacheDesc => _localizedValues[languageCode]!['clear_cache_desc']!;
  String get appSettings => _localizedValues[languageCode]!['app_settings']!;
  String get bookmarksAndHistory => _localizedValues[languageCode]!['bookmarks_and_history']!;
  String get resetSettings => _localizedValues[languageCode]!['reset_settings']!;
  String get resetSettingsDesc => _localizedValues[languageCode]!['reset_settings_desc']!;
  String get aboutApp => _localizedValues[languageCode]!['about_app']!;
  String get version => _localizedValues[languageCode]!['version']!;
  String get appDescription => _localizedValues[languageCode]!['app_description']!;
  String get builtWithFlutter => _localizedValues[languageCode]!['built_with_flutter']!;
  String get resetConfirmation => _localizedValues[languageCode]!['reset_confirmation']!;
  String get resetWarning => _localizedValues[languageCode]!['reset_warning']!;
  String get resetSuccess => _localizedValues[languageCode]!['reset_success']!;
  String get language => _localizedValues[languageCode]!['language']!;
  String get english => _localizedValues[languageCode]!['english']!;
  String get arabic => _localizedValues[languageCode]!['arabic']!;
  String get quickSettings => _localizedValues[languageCode]!['quick_settings']!;
  String get nightMode => _localizedValues[languageCode]!['night_mode']!;
  String get selectQiraat => _localizedValues[languageCode]!['select_qiraat']!;
  String get downloadFailed => _localizedValues[languageCode]!['download_failed']!;
  String get resumeFailed => _localizedValues[languageCode]!['resume_failed']!;
  String get notStarted => _localizedValues[languageCode]!['not_started']!;
  String get startingDownload => _localizedValues[languageCode]!['starting_download']!;
  String get downloading => _localizedValues[languageCode]!['downloading']!;
  String get downloadCompleted => _localizedValues[languageCode]!['download_completed']!;
  String get downloadCancelled => _localizedValues[languageCode]!['download_cancelled']!;
  String get downloadPaused => _localizedValues[languageCode]!['download_paused']!;
  String get resumingDownload => _localizedValues[languageCode]!['resuming_download']!;
  String get storageInfoTitle => _localizedValues[languageCode]!['storage_info_title']!;
  String get totalStorageUsed => _localizedValues[languageCode]!['total_storage_used']!;
  String get estimatedSizePerQiraat => _localizedValues[languageCode]!['estimated_size_per_qiraat']!;
  String get ok => _localizedValues[languageCode]!['ok']!;
  String get errorLoadingPage => _localizedValues[languageCode]!['error_loading_page']!;
  String get failedToLoadPageImage => _localizedValues[languageCode]!['failed_to_load_page_image']!;
  String get pageContentUnavailable => _localizedValues[languageCode]!['page_content_unavailable']!;
  String get ensureQiraatDownloaded => _localizedValues[languageCode]!['ensure_qiraat_downloaded']!;

  // PDF Reader methods
  String get pdfNotFound => _localizedValues[languageCode]!['pdf_not_found']!;
  String get goBack => _localizedValues[languageCode]!['go_back']!;
  String pageNumberFormat(int current, int total) => 
      _localizedValues[languageCode]!['page_number_format']!.replaceAll('{0}', current.toString()).replaceAll('{1}', total.toString());
  String get goToPageDialog => _localizedValues[languageCode]!['go_to_page_dialog']!;
  String get surahsList => _localizedValues[languageCode]!['surahs_list']!;
  String ayahCount(int count) => 
      _localizedValues[languageCode]!['ayah_count']!.replaceAll('{0}', count.toString());
  String get loadingPage => _localizedValues[languageCode]!['loading_page']!;
  String get bismillah => _localizedValues[languageCode]!['bismillah']!;

  // Audio Player getters
  String get playWholeSurah => _localizedValues[languageCode]!['play_whole_surah']!;
  String get playThePage => _localizedValues[languageCode]!['play_the_page']!;
  String get playAyahRange => _localizedValues[languageCode]!['play_ayah_range']!;
  String get playRange => _localizedValues[languageCode]!['play_range']!;
  String get from => _localizedValues[languageCode]!['from']!;
  String get to => _localizedValues[languageCode]!['to']!;
  String get ayah => _localizedValues[languageCode]!['ayah']!;
  String get surah => _localizedValues[languageCode]!['surah']!;
  String playingAyah(int ayahNumber) => 
      _localizedValues[languageCode]!['playing_ayah']!.replaceAll('{0}', ayahNumber.toString());
  String playingRange(int start, int end) => 
      _localizedValues[languageCode]!['playing_range']!
          .replaceAll('{0}', start.toString())
          .replaceAll('{1}', end.toString());
  String get pleaseSelectQiraat => _localizedValues[languageCode]!['please_select_qiraat']!;
  String get showingAllAyahs => _localizedValues[languageCode]!['showing_all_ayahs']!;
  String get showingAyahsOnPage => _localizedValues[languageCode]!['showing_ayahs_on_page']!;
  String get chooseSurah => _localizedValues[languageCode]!['choose_surah']!;
  
  // Offline Mode getters
  String get noInternetConnection => _localizedValues[languageCode]!['no_internet_connection']!;
  String get offlineRiwayatMessage => _localizedValues[languageCode]!['offline_riwayat_message']!;
  String get connectToInternet => _localizedValues[languageCode]!['connect_to_internet']!;

  // Helper methods for dynamic text
  String getQiraatDownloadedMessage(String qiraatName) => 
      qiraatDownloaded.replaceAll('{0}', qiraatName);
  
  String getQiraatDeletedMessage(String qiraatName) => 
      qiraatDeleted.replaceAll('{0}', qiraatName);
  
  String getSizeMbText(String size) => 
      sizeMb.replaceAll('{0}', size);
  
  String getDeleteConfirmationText(String qiraatName) => 
      deleteConfirmation.replaceAll('{0}', qiraatName);
  
  String getDownloadingText(String current, String total) => 
      downloading.replaceAll('{0}', current).replaceAll('{1}', total);
  
  String getTotalStorageUsedText(String size) => 
      totalStorageUsed.replaceAll('{0}', size);
  
  String getEnsureQiraatDownloadedText(String qiraatName) => 
      ensureQiraatDownloaded.replaceAll('{0}', qiraatName);
}