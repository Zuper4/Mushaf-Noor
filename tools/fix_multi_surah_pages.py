#!/usr/bin/env python3
"""
Fix pages that should contain multiple complete surahs.
Based on surah JSON files which show the correct page distribution.
"""

import json
import os
from pathlib import Path

def fix_multi_surah_pages():
    """Fix pages that should have multiple surahs."""
    
    base_dir = Path('/Users/zeydajraou/Documents/Mushaf-Noor/assets/json/bounds')
    qiraats = ['asim_hafs', 'nafi_warsh']
    
    for qiraat in qiraats:
        qiraat_dir = base_dir / qiraat
        
        print(f"\n{'='*60}")
        print(f"Processing {qiraat}")
        print(f"{'='*60}\n")
        
        # First, scan all surah files to find which surahs belong on which pages
        page_to_surahs = {}  # page_num -> [surah_data]
        
        # Check all surahs
        for surah_num in range(1, 115):
            surah_file = qiraat_dir / f'surah_{str(surah_num).zfill(3)}.json'
            if not surah_file.exists():
                continue
                
            with open(surah_file, 'r', encoding='utf-8') as f:
                surah_data = json.load(f)
            
            # Check each page this surah appears on
            for page_info in surah_data['pages']:
                page_num = page_info['pageNumber']
                
                if page_num not in page_to_surahs:
                    page_to_surahs[page_num] = []
                
                page_to_surahs[page_num].append({
                    'surahNumber': surah_num,
                    'surahName': surah_data['surahName'],
                    'surahNameArabic': surah_data['surahNameArabic'],
                    'startAyah': page_info['startAyah'],
                    'endAyah': page_info['endAyah'],
                    'ayahs': page_info['ayahs']
                })
        
        # Now regenerate ONLY pages that have multiple surahs
        multi_surah_pages = {page: surahs for page, surahs in page_to_surahs.items() if len(surahs) > 1}
        
        print(f"Found {len(multi_surah_pages)} pages with multiple surahs")
        print(f"Pages: {sorted(multi_surah_pages.keys())}\n")
        
        for page_num in sorted(multi_surah_pages.keys()):
            surahs_on_page = multi_surah_pages[page_num]
            
            print(f"Page {page_num}:")
            for surah_info in surahs_on_page:
                print(f"  - Surah {surah_info['surahNumber']} ({surah_info['surahNameArabic']}): "
                      f"ayahs {surah_info['startAyah']}-{surah_info['endAyah']}")
            
            # Create page JSON with all surahs
            page_data = {
                'pageNumber': page_num,
                'qiraatId': qiraat,
                'surahs': []
            }
            
            all_ayahs = []
            for surah_info in surahs_on_page:
                page_data['surahs'].append({
                    'surahNumber': surah_info['surahNumber'],
                    'surahName': surah_info['surahName'],
                    'surahNameArabic': surah_info['surahNameArabic'],
                    'startAyah': surah_info['startAyah'],
                    'endAyah': surah_info['endAyah']
                })
                
                # Add all ayahs from this surah
                all_ayahs.extend(surah_info['ayahs'])
            
            page_data['ayahs'] = all_ayahs
            
            # Write to file
            page_file = qiraat_dir / f'page_{page_num}.json'
            with open(page_file, 'w', encoding='utf-8') as f:
                json.dump(page_data, f, ensure_ascii=False, indent=2)
            
            print(f"  ✓ Updated page_{page_num}.json with {len(surahs_on_page)} surahs, {len(all_ayahs)} total ayahs\n")

if __name__ == '__main__':
    fix_multi_surah_pages()
    print("\n" + "="*60)
    print("✅ DONE! All multi-surah pages have been fixed!")
    print("="*60)
