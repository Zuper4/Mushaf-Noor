#!/usr/bin/env python3
"""
Find and fix ALL pages where a surah starts mid-page.
This happens when Tanzil shows a page starting at ayah > 1.
"""

import json
import xml.etree.ElementTree as ET
from pathlib import Path

# Parse Tanzil
tree = ET.parse('/tmp/quran-data.xml')
root = tree.getroot()

# Find all cases where a page starts at ayah > 1
transition_cases = []

for page in root.findall('.//page'):
    tanzil_page = int(page.get('index'))
    mushaf_page = tanzil_page + 1
    sura = int(page.get('sura'))
    aya = int(page.get('aya'))
    
    if aya > 1:
        # This page starts at ayah > 1
        # So the PREVIOUS page should have ayahs 1 through (aya-1)
        prev_mushaf_page = mushaf_page - 1
        transition_cases.append({
            'prev_page': prev_mushaf_page,
            'next_page': mushaf_page,
            'sura': sura,
            'missing_ayahs_start': 1,
            'missing_ayahs_end': aya - 1,
            'next_page_starts_at': aya
        })

print(f"Found {len(transition_cases)} transition pages\n")

# Process each qiraat
for qiraat in ['asim_hafs', 'nafi_warsh']:
    print(f"\n{'=' * 80}")
    print(f"Processing {qiraat}")
    print('=' * 80)
    
    base_path = Path('/Users/zeydajraou/Documents/Mushaf-Noor/assets/json/bounds') / qiraat
    
    for case in transition_cases:
        prev_page = case['prev_page']
        next_page = case['next_page']
        sura = case['sura']
        missing_start = case['missing_ayahs_start']
        missing_end = case['missing_ayahs_end']
        
        prev_file = base_path / f'page_{prev_page}.json'
        next_file = base_path / f'page_{next_page}.json'
        
        if not prev_file.exists() or not next_file.exists():
            print(f"  SKIP page {prev_page}: files don't exist")
            continue
        
        # Read both pages
        with open(prev_file, 'r') as f:
            prev_data = json.load(f)
        
        with open(next_file, 'r') as f:
            next_data = json.load(f)
        
        # Check if prev_page already has the missing ayahs
        existing_ayahs = [(a['surahNumber'], a['ayahNumber']) for a in prev_data['ayahs'] if a['surahNumber'] == sura]
        needed_ayahs = list(range(missing_start, missing_end + 1))
        
        if existing_ayahs and existing_ayahs == [(sura, a) for a in needed_ayahs]:
            # Already fixed
            continue
        
        # Add the missing ayahs to prev_page
        print(f"  Page {prev_page}: Adding Surah {sura} ayahs {missing_start}-{missing_end}")
        
        for ayah_num in range(missing_start, missing_end + 1):
            y_pos = 0.63 + (ayah_num - missing_start) * 0.08
            new_ayah = {
                "surahNumber": sura,
                "ayahNumber": ayah_num,
                "positions": [{
                    "x": 0.15,
                    "y": y_pos,
                    "width": 0.7,
                    "height": 0.08,
                    "lineNumber": 0
                }]
            }
            prev_data['ayahs'].append(new_ayah)
        
        # Write prev_page
        with open(prev_file, 'w', encoding='utf-8') as f:
            json.dump(prev_data, f, ensure_ascii=False, indent=2)
        
        # Remove ayahs 1 through (aya-1) from next_page if they exist
        original_count = len(next_data['ayahs'])
        next_data['ayahs'] = [a for a in next_data['ayahs'] 
                               if not (a['surahNumber'] == sura and a['ayahNumber'] < case['next_page_starts_at'])]
        
        if len(next_data['ayahs']) != original_count:
            print(f"  Page {next_page}: Removed {original_count - len(next_data['ayahs'])} duplicate ayahs")
            with open(next_file, 'w', encoding='utf-8') as f:
                json.dump(next_data, f, ensure_ascii=False, indent=2)

print("\n" + "=" * 80)
print("DONE!")
print("=" * 80)
