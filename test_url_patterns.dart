// Test specific qiraats that user mentioned
import 'dart:io';

void main() async {
  print('Testing Audio URLs for Khalaf and Shu\'ba Qiraats\n');
  
  // Test the specific qiraats user mentioned
  final testUrls = [
    'https://pub-820035f689da4250823ad729c03363e9.r2.dev/Zeyd/khalaf/ishaq/001001.mp3',  // khalaf_ishaq
    'https://pub-820035f689da4250823ad729c03363e9.r2.dev/Zeyd/khalaf/idris/001001.mp3',  // khalaf_idris
    'https://pub-820035f689da4250823ad729c03363e9.r2.dev/Zeyd/asim/shu_ba/001001.mp3',   // asim_shuba
    
    // Alternative patterns to test
    'https://pub-820035f689da4250823ad729c03363e9.r2.dev/Zeyd/Khalaf/Ishaq/001001.mp3',  // Capital case
    'https://pub-820035f689da4250823ad729c03363e9.r2.dev/Zeyd/Khalaf/Idris/001001.mp3',  // Capital case
    'https://pub-820035f689da4250823ad729c03363e9.r2.dev/Zeyd/Asim/Shu_ba/001001.mp3',   // Capital case
    'https://pub-820035f689da4250823ad729c03363e9.r2.dev/Zeyd/Asim/Shuba/001001.mp3',    // Different rawi format
  ];
  
  final client = HttpClient();
  client.connectionTimeout = Duration(seconds: 5);
  
  for (final url in testUrls) {
    try {
      final uri = Uri.parse(url);
      final request = await client.headUrl(uri);
      final response = await request.close();
      
      print('✓ ${response.statusCode} - $url');
      
      if (response.statusCode == 200) {
        print('  SUCCESS: File exists!');
      }
    } catch (e) {
      print('✗ ERROR - $url');
      print('  ${e.toString()}');
    }
  }
  
  client.close();
}