#!/usr/bin/env python3
"""
Properly fix all pages where surahs start mid-page.
This will REBUILD pages to include both:
1. The end of the previous surah
2. The complete beginning of the new surah (from ayah 1)
"""

import json
import xml.etree.ElementTree as ET
from pathlib import Path
from collections import defaultdict

# Parse Tanzil data
tree = ET.parse('/tmp/quran-data.xml')
root = tree.getroot()

# Build a complete mapping of which surahs appear on which pages
page_to_surahs = defaultdict(set)  # page_num -> set of (sura, first_ayah)

for page in root.findall('.//page'):
    page_idx = int(page.get('index'))
    mushaf_page = page_idx + 1
    sura = int(page.get('sura'))
    aya = int(page.get('aya'))
    page_to_surahs[mushaf_page].add((sura, aya))

print("=" * 80)
print("FIXING ALL SURAH START PAGES")
print("=" * 80)

# Process each qiraat
for qiraat_dir in ['asim_hafs', 'nafi_warsh']:
    print(f"\n\nProcessing {qiraat_dir}...")
    base_path = Path('/Users/zeydajraou/Documents/Mushaf-Noor/assets/json/bounds')
    surah_dir = base_path / qiraat_dir
    
    # For each page, check if multiple surahs appear
    for mushaf_page, surah_starts in sorted(page_to_surahs.items()):
        if len(surah_starts) <= 1:
            continue  # Only one surah on this page, skip
        
        # This page has multiple surahs - need to fix it
        surah_list = sorted(list(surah_starts))  # Sort by (sura, aya)
        
        page_file = surah_dir / f'page_{mushaf_page}.json'
        if not page_file.exists():
            print(f"  WARNING: {page_file} doesn't exist")
            continue
        
        # Read the current page
        with open(page_file, 'r') as f:
            page_data = json.load(f)
        
        print(f"\n  Page {mushaf_page}: {len(surah_list)} surahs")
        
        # Build the correct ayah list
        correct_ayahs = []
        
        for sura, first_aya in surah_list:
            print(f"    - Surah {sura} starting at ayah {first_aya}")
            
            # Read the surah JSON to get ayah count
            surah_file = surah_dir / f'surah_{sura:03d}.json'
            if not surah_file.exists():
                print(f"      WARNING: {surah_file} doesn't exist")
                continue
            
            with open(surah_file, 'r') as f:
                surah_data = json.load(f)
            
            # Find this page in the surah data
            for page in surah_data['pages']:
                if page['pageNumber'] == mushaf_page:
                    # Check if this page should start from ayah 1
                    if first_aya > 1:
                        # Tanzil says this page starts at ayah > 1, but it should include all ayahs from 1
                        # We need to prepend ayahs 1 to first_aya-1
                        for aya_num in range(1, first_aya):
                            correct_ayahs.append({
                                "surahNumber": sura,
                                "ayahNumber": aya_num,
                                "positions": [{
                                    "x": 0.15,
                                    "y": 0.35 + (len(correct_ayahs) * 0.08),
                                    "width": 0.7,
                                    "height": 0.08,
                                    "lineNumber": 0
                                }]
                            })
                    
                    # Now add the ayahs that are actually on this page
                    for ayah in page['ayahs']:
                        correct_ayahs.append(ayah)
                    break
        
        # Check if we need to update
        existing_ayah_ids = [(a['surahNumber'], a['ayahNumber']) for a in page_data['ayahs']]
        correct_ayah_ids = [(a['surahNumber'], a['ayahNumber']) for a in correct_ayahs]
        
        if existing_ayah_ids != correct_ayah_ids:
            print(f"    UPDATING: was {existing_ayah_ids[:3]}...{existing_ayah_ids[-2:]}, now {correct_ayah_ids[:3]}...{correct_ayah_ids[-2:]}")
            page_data['ayahs'] = correct_ayahs
            
            with open(page_file, 'w', encoding='utf-8') as f:
                json.dump(page_data, f, ensure_ascii=False, indent=2)
            print(f"    ✓ Updated")
        else:
            print(f"    Already correct ✓")

print("\n" + "=" * 80)
print("DONE!")
print("=" * 80)
