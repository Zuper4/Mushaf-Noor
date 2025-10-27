import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../providers/app_state.dart';
import '../providers/qiraat_provider.dart';
import '../services/pdf_service.dart';
import '../l10n/app_localizations.dart';
import '../models/surah.dart';
import 'reading_screen.dart';

class PDFReaderScreen extends StatefulWidget {
  final String qiraatId;
  final int? initialPage;
  final int? surahNumber;

  const PDFReaderScreen({
    super.key,
    required this.qiraatId,
    this.initialPage,
    this.surahNumber,
  });

  @override
  State<PDFReaderScreen> createState() => _PDFReaderScreenState();
}

class _PDFReaderScreenState extends State<PDFReaderScreen> {
  late PdfViewerController _pdfController;
  final PDFService _pdfService = PDFService();
  
  bool _isLoading = true;
  bool _hasError = false;
  String? _pdfPath;
  int _currentPage = 1;
  int _totalPages = 606;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    // For web compatibility, redirect to ReadingScreen instead of loading PDFs
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ReadingScreen()),
        );
      });
      return;
    }
    
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Get the qiraat details from provider
      final qiraatProvider = context.read<QiraatProvider>();
      final selectedQiraat = qiraatProvider.availableQiraats
          .firstWhere((q) => q.id == widget.qiraatId, orElse: () => qiraatProvider.availableQiraats.first);
      
      final pdfPath = await _pdfService.getPDFPath(
        widget.qiraatId,
        qariFolder: selectedQiraat.folderPath,
        rawiFileName: selectedQiraat.rawiName,
      );
      
      if (pdfPath != null) {
        setState(() {
          _pdfPath = pdfPath;
          _isLoading = false;
        });

        // Navigate to initial page if specified
        if (widget.initialPage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _pdfController.jumpToPage(widget.initialPage!);
          });
        } else if (widget.surahNumber != null) {
          final startPage = _pdfService.getSurahStartPage(widget.surahNumber!, widget.qiraatId);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _pdfController.jumpToPage(startPage);
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _goToPage() {
    showDialog(
      context: context,
      builder: (context) => _GoToPageDialog(
        currentPage: _currentPage,
        totalPages: _totalPages,
        onPageSelected: (page) {
          _pdfController.jumpToPage(page);
        },
      ),
    );
  }

  void _showSurahList() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _SurahListSheet(
        qiraatId: widget.qiraatId,
        onSurahSelected: (surah) {
          final startPage = _pdfService.getSurahStartPage(surah.number, widget.qiraatId);
          _pdfController.jumpToPage(startPage);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final qiraatProvider = context.watch<QiraatProvider>();
    final selectedQiraat = qiraatProvider.selectedQiraat;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // PDF Viewer
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            else if (_hasError)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: Colors.white70,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      AppLocalizations.of(context)
                          .pdfNotFound,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context)
                            .goBack,
                      ),
                    ),
                  ],
                ),
              )
            else if (_pdfPath != null)
              GestureDetector(
                onTap: _toggleControls,
                child: SfPdfViewer.asset(
                  _pdfPath!,
                  controller: _pdfController,
                  onPageChanged: (details) {
                    setState(() {
                      _currentPage = details.newPageNumber;
                    });
                  },
                  onDocumentLoaded: (details) {
                    setState(() {
                      _totalPages = details.document.pages.count;
                    });
                  },
                ),
              ),

            // Top Controls
            if (_showControls)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedQiraat?.name ?? 'Mushaf',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .pageNumberFormat(_currentPage, _totalPages),
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _showSurahList,
                        icon: Icon(
                          Icons.list,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                      IconButton(
                        onPressed: _goToPage,
                        icon: Icon(
                          Icons.pages,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Bottom Controls
            if (_showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _currentPage > 1 ? () {
                          _pdfController.previousPage();
                        } : null,
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: _currentPage > 1 ? Colors.white : Colors.white30,
                          size: 20.sp,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          '$_currentPage / $_totalPages',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _currentPage < _totalPages ? () {
                          _pdfController.nextPage();
                        } : null,
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: _currentPage < _totalPages ? Colors.white : Colors.white30,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }
}

// Go to Page Dialog
class _GoToPageDialog extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageSelected;

  const _GoToPageDialog({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  @override
  State<_GoToPageDialog> createState() => _GoToPageDialogState();
}

class _GoToPageDialogState extends State<_GoToPageDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentPage.toString());
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).goToPageDialog,
      ),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: '1 - ${widget.totalPages}',
          border: const OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppLocalizations.of(context).cancel,
          ),
        ),
        TextButton(
          onPressed: () {
            final page = int.tryParse(_controller.text);
            if (page != null && page >= 1 && page <= widget.totalPages) {
              widget.onPageSelected(page);
              Navigator.pop(context);
            }
          },
          child: Text(
            AppLocalizations.of(context).go,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Surah List Sheet
class _SurahListSheet extends StatelessWidget {
  final String qiraatId;
  final Function(Surah) onSurahSelected;

  const _SurahListSheet({
    required this.qiraatId,
    required this.onSurahSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Container(
      height: 500.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context).surahsList,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: Surah.allSurahs.length,
              itemBuilder: (context, index) {
                final surah = Surah.allSurahs[index];
                return ListTile(
                  leading: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        surah.number.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    surah.getDisplayName(appState.languageCode),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)
                        .ayahCount(surah.numberOfAyahs),
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  onTap: () => onSurahSelected(surah),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}