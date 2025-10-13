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
      'app_title': 'Mushaf Noor',
      
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
      'no_qiraat_selected': 'No qiraat selected',
      
      // Navigation
      'cancel': 'Cancel',
      'go': 'Go',
      'page_number_hint': 'Page number (1-604)',
      
      // Qiraat Selection
      'available_qiraats': 'Available Qiraats',
      'active_downloads': 'Active Downloads',
      'storage': 'Storage',
      'download': 'Download',
      'delete': 'Delete',
      'download_qiraat': 'Download Qiraat',
      'download_confirmation': 'Do you want to download',
      'size_mb': 'Size: {0} MB approximately',
      'total_pages': '604 pages',
      'delete_qiraat': 'Delete Qiraat',
      'delete_confirmation': 'Do you want to delete {0} from the device?\\n\\nAll saved pages will be deleted.',
      'qiraat_downloaded': '{0} has been downloaded',
      'qiraat_deleted': '{0} has been deleted',
      'important_info': 'Important Information',
      'qiraat_info': '• Each qiraat needs approximately 50 MB of storage\\n• You can download qiraats as needed\\n• Colors indicate differences from Hafs\\n• Hafs qiraat is available by default and cannot be deleted',
      
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
      'estimated_size_per_qiraat': 'Estimated size per qiraat: 50 MB',
      'ok': 'OK',
      
      // Error Messages
      'error_loading_page': 'Error loading page',
      'failed_to_load_page_image': 'Failed to load page image',
      'page_content_unavailable': 'Page content unavailable',
      'ensure_qiraat_downloaded': 'Please ensure {0} is downloaded',
      'loading_page': 'Loading page...',
      
      // Placeholder Content
      'bismillah': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
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
      'go_to_page': 'الذهاب إلى صفحة',
      'from_1_to_604': 'من 1 إلى 604',
      'settings': 'الإعدادات',
      'reading_features': 'خصائص القراءة',
      'recent_pages': 'الصفحات الأخيرة',
      'bookmarks': 'المحفوظات',
      'no_qiraat_selected': 'لم يتم اختيار قراءة',
      
      // Navigation
      'cancel': 'إلغاء',
      'go': 'اذهب',
      'page_number_hint': 'رقم الصفحة (1-604)',
      
      // Qiraat Selection
      'available_qiraats': 'القراءات المتاحة',
      'active_downloads': 'التنزيلات النشطة',
      'storage': 'التخزين',
      'download': 'تنزيل',
      'delete': 'حذف',
      'download_qiraat': 'تنزيل القراءة',
      'download_confirmation': 'هل تريد تنزيل قراءة',
      'size_mb': 'الحجم: {0} ميجابايت تقريباً',
      'total_pages': '604 صفحة',
      'delete_qiraat': 'حذف القراءة',
      'delete_confirmation': 'هل تريد حذف قراءة {0} من الجهاز؟\\n\\nسيتم حذف جميع الصفحات المحفوظة.',
      'qiraat_downloaded': 'تم تنزيل قراءة {0}',
      'qiraat_deleted': 'تم حذف قراءة {0}',
      'important_info': 'معلومات مهمة',
      
      // PDF Reader
      'pdf_not_found': 'لم يتم العثور على ملف PDF لهذه القراءة',
      'go_back': 'العودة',
      'page_number_format': 'الصفحة {0} من {1}',
      'go_to_page_dialog': 'الذهاب إلى صفحة',
      'surahs_list': 'السور',
      'ayah_count': '{0} آية',
      'qiraat_info': '• كل قراءة تحتاج تقريباً 50 ميجابايت من التخزين\\n• يمكنك تنزيل القراءات عند الحاجة\\n• الألوان تدل على الاختلافات عن رواية حفص\\n• قراءة حفص متاحة افتراضياً ولا يمكن حذفها',
      
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
      'estimated_size_per_qiraat': 'المساحة التقديرية لكل قراءة: 50 ميجابايت',
      'ok': 'موافق',
      
      // Error Messages
      'error_loading_page': 'خطأ في تحميل الصفحة',
      'failed_to_load_page_image': 'فشل في تحميل صورة الصفحة',
      'page_content_unavailable': 'محتوى الصفحة غير متوفر',
      'ensure_qiraat_downloaded': 'يرجى التأكد من تنزيل قراءة {0}',
      'loading_page': 'جاري تحميل الصفحة...',
      
      // Placeholder Content
      'bismillah': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
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