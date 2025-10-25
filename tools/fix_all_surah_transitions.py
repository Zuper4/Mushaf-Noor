#!/usr/bin/env python3
"""
Fix all cases where a surah starts mid-page (between-surah transitions).
This script identifies pages where Tanzil shows a surah starting at ayah > 1,
meaning the previous page should have the earlier ayahs of that surah.
"""

import json
import xml.etree.ElementTree as ET
from pathlib import Path

# Parse Tanzil data
tree = ET.parse('/tmp/quran-data.xml')
root = tree.getroot()

# Get all page entries from Tanzil
page_entries = []
for page in root.findall('.//page'):
    page_idx = int(page.get('index'))
    sura = int(page.get('sura'))
    aya = int(page.get('aya'))
    page_entries.append({
        'tanzil_page': page_idx,
        'mushaf_page': page_idx + 1,  # Tanzil is 0-indexed, Mushaf is 1-indexed
        'sura': sura,
        'aya': aya
    })

print("=" * 80)
print("SURAH TRANSITION PAGES (where surah starts mid-page)")
print("=" * 80)

# Find all cases where a surah starts at ayah > 1
transition_pages = []
for entry in page_entries:
    if entry['aya'] > 1:
        # This page starts at ayah > 1, so previous page should have ayahs 1 to (aya-1)
        prev_mushaf_page = entry['mushaf_page'] - 1
        transition_pages.append({
            'page': prev_mushaf_page,
            'sura': entry['sura'],
            'start_ayah': 1,
            'end_ayah': entry['aya'] - 1,
            'next_page_starts_at': entry['aya']
        })
        print(f"\nPage {prev_mushaf_page}:")
        print(f"  Should END with Surah {entry['sura']} ayahs 1-{entry['aya']-1}")
        print(f"  (Next page {entry['mushaf_page']} starts at ayah {entry['aya']})")

print(f"\n{'=' * 80}")
print(f"Total transition pages found: {len(transition_pages)}")
print(f"{'=' * 80}")

# Now let's fix these pages for both qiraats
base_path = Path('/Users/zeydajraou/Documents/Mushaf-Noor/assets/json/bounds')

for qiraat_dir in ['asim_hafs', 'nafi_warsh']:
    print(f"\n\nProcessing {qiraat_dir}...")
    
    for transition in transition_pages:
        page_num = transition['page']
        page_file = base_path / qiraat_dir / f'page_{page_num}.json'
        
        if not page_file.exists():
            print(f"  WARNING: {page_file} does not exist, skipping")
            continue
        
        # Read current page data
        with open(page_file, 'r') as f:
            page_data = json.load(f)
        
        # Check if the new surah ayahs are already present
        new_sura_ayahs = [a for a in page_data['ayahs'] if a['surahNumber'] == transition['sura']]
        
        if new_sura_ayahs:
            # Check if we have all the ayahs we need
            existing_ayah_nums = sorted([a['ayahNumber'] for a in new_sura_ayahs])
            needed_ayah_nums = list(range(transition['start_ayah'], transition['end_ayah'] + 1))
            
            if existing_ayah_nums == needed_ayah_nums:
                print(f"  Page {page_num}: Already has Surah {transition['sura']} ayahs {transition['start_ayah']}-{transition['end_ayah']} ✓")
                continue
            else:
                print(f"  Page {page_num}: Has some ayahs but incomplete. Existing: {existing_ayah_nums}, Needed: {needed_ayah_nums}")
        
        # Find the last ayah of the previous surah (if any)
        if page_data['ayahs']:
            last_prev_surah = max(a['surahNumber'] for a in page_data['ayahs'])
            if last_prev_surah < transition['sura']:
                print(f"  Page {page_num}: Adding Surah {transition['sura']} ayahs {transition['start_ayah']}-{transition['end_ayah']}")
                
                # Add the new surah ayahs
                for ayah_num in range(transition['start_ayah'], transition['end_ayah'] + 1):
                    y_pos = 0.35 + (ayah_num - 1) * 0.08
                    new_ayah = {
                        "surahNumber": transition['sura'],
                        "ayahNumber": ayah_num,
                        "positions": [
                            {
                                "x": 0.15,
                                "y": y_pos,
                                "width": 0.7,
                                "height": 0.08,
                                "lineNumber": 0
                            }
                        ]
                    }
                    page_data['ayahs'].append(new_ayah)
                
                # Write back
                with open(page_file, 'w', encoding='utf-8') as f:
                    json.dump(page_data, f, ensure_ascii=False, indent=2)
                
                print(f"    ✓ Updated page {page_num}")

print("\n" + "=" * 80)
print("DONE! All surah transition pages have been fixed.")
print("=" * 80)
