import 'package:flutter/material.dart';

class PDFReaderScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Reader'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.picture_as_pdf,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'PDF Reader temporarily disabled\nfor Android compatibility',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}