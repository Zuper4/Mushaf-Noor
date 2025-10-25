#!/usr/bin/env python3
"""
Fix the last pages of the Quran that should contain multiple complete surahs.
Based on standard Hafs and Warsh page layouts.
"""

import json
import os
from pathlib import Path

# Define which surahs appear on which pages (based on standard Mushaf layout)
# Format: {page_num: [surah_numbers]}
HAFS_MULTI_SURAH_PAGES = {
    597: [93, 94],  # Ad-Dhuha, Ash-Sharh
    600: [98, 99],  # Al-Bayyinah, Az-Zalzalah  
    601: [100, 101, 102],  # Al-Adiyat, Al-Qariah, At-Takathur
    602: [103, 104, 105],  # Al-Asr, Al-Humazah, Al-Fil
    603: [106, 107, 108],  # Quraysh, Al-Maun, Al-Kawthar
    604: [109, 110, 111],  # Al-Kafirun, An-Nasr, Al-Masad
    605: [112, 113, 114],  # Al-Ikhlas, Al-Falaq, An-Nas
}

# Warsh may have slightly different layout
WARSH_MULTI_SURAH_PAGES = {
    596: [93, 94],  # Ad-Dhuha, Ash-Sharh
    599: [98, 99],  # Al-Bayyinah, Az-Zalzalah
    600: [100, 101, 102],  # Al-Adiyat, Al-Qariah, At-Takathur
    601: [103, 104, 105],  # Al-Asr, Al-Humazah, Al-Fil
    602: [106, 107, 108],  # Quraysh, Al-Maun, Al-Kawthar
    603: [109, 110, 111],  # Al-Kafirun, An-Nasr, Al-Masad
    604: [112, 113, 114],  # Al-Ikhlas, Al-Falaq, An-Nas
}

def get_surah_info(surah_dir, surah_num):
    """Load surah info from surah JSON file."""
    surah_file = surah_dir / f'surah_{str(surah_num).zfill(3)}.json'
    with open(surah_file, 'r', encoding='utf-8') as f:
        return json.load(f)

def create_placeholder_ayahs(surah_num, start_ayah, end_ayah):
    """Create placeholder ayah entries when surah file is incomplete."""
    ayahs = []
    for ayah_num in range(start_ayah, end_ayah + 1):
        ayahs.append({
            'surahNumber': surah_num,
            'ayahNumber': ayah_num,
            'positions': [{
                'x': 0.15,
                'y': 0.2,
                'width': 0.7,
                'height': 0.08,
                'lineNumber': 0
            }]
        })
    return ayahs

def fix_multi_surah_pages(qiraat, page_mapping):
    """Fix pages that should contain multiple complete surahs."""
    
    base_dir = Path('/Users/zeydajraou/Documents/Mushaf-Noor/assets/json/bounds')
    qiraat_dir = base_dir / qiraat
    
    print(f"\n{'='*60}")
    print(f"Fixing {qiraat}")
    print(f"{'='*60}\n")
    
    for page_num, surah_numbers in sorted(page_mapping.items()):
        print(f"Page {page_num}: Surahs {surah_numbers}")
        
        # Create page JSON
        page_data = {
            'pageNumber': page_num,
            'qiraatId': qiraat,
            'surahs': [],
            'ayahs': []
        }
        
        # Add all surahs
        for surah_num in surah_numbers:
            surah_info = get_surah_info(qiraat_dir, surah_num)
            
            # Add surah metadata
            page_data['surahs'].append({
                'surahNumber': surah_num,
                'surahName': surah_info['surahName'],
                'surahNameArabic': surah_info['surahNameArabic'],
                'startAyah': 1,
                'endAyah': surah_info['numberOfAyahs']
            })
            
            # Try to get ayahs from surah file
            ayahs_added = False
            if len(surah_info['pages']) > 0:
                for page_info in surah_info['pages']:
                    if page_info['pageNumber'] == page_num:
                        page_data['ayahs'].extend(page_info['ayahs'])
                        ayahs_added = True
                        print(f"  ✓ Surah {surah_num} ({surah_info['surahNameArabic']}): "
                              f"found {len(page_info['ayahs'])} ayahs from surah file")
                        break
            
            # If no ayah data found, create placeholders
            if not ayahs_added:
                placeholder_ayahs = create_placeholder_ayahs(
                    surah_num, 1, surah_info['numberOfAyahs']
                )
                page_data['ayahs'].extend(placeholder_ayahs)
                print(f"  ⚠ Surah {surah_num} ({surah_info['surahNameArabic']}): "
                      f"created {len(placeholder_ayahs)} placeholder ayahs")
        
        # Write page file
        page_file = qiraat_dir / f'page_{page_num}.json'
        with open(page_file, 'w', encoding='utf-8') as f:
            json.dump(page_data, f, ensure_ascii=False, indent=2)
        
        print(f"  ✓ Saved page_{page_num}.json with {len(page_data['surahs'])} surahs, "
              f"{len(page_data['ayahs'])} total ayahs\n")

if __name__ == '__main__':
    fix_multi_surah_pages('asim_hafs', HAFS_MULTI_SURAH_PAGES)
    fix_multi_surah_pages('nafi_warsh', WARSH_MULTI_SURAH_PAGES)
    
    print("\n" + "="*60)
    print("✅ DONE! All multi-surah end pages have been fixed!")
    print("="*60)
    print("\nNow the surah selector dialog should appear on all pages")
    print("with multiple surahs!")
