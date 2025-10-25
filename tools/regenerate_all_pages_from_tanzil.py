#!/usr/bin/env python3
"""
Regenerate ALL page JSON files from Tanzil data.
This ensures each page only has the ayahs that Tanzil says are on that page.
"""

import json
import xml.etree.ElementTree as ET
from pathlib import Path

def load_tanzil_data():
    """Load and parse Tanzil XML data."""
    tanzil_path = '/tmp/quran-data.xml'
    tree = ET.parse(tanzil_path)
    root = tree.getroot()
    
    # Structure: {qiraat: {page_num: [(surah, ayah), ...]}}
    pages = {'asim_hafs': {}, 'nafi_warsh': {}}
    
    for sura in root.findall('sura'):
        sura_num = int(sura.get('index'))
        
        for aya in sura.findall('aya'):
            aya_num = int(aya.get('index'))
            
            # Get page numbers for both qiraats
            kufi_page = aya.get('page-kufi')  # Hafs
            madani_page = aya.get('page-madani')  # Warsh
            
            if kufi_page:
                page_num = int(kufi_page) + 1  # Tanzil is 0-indexed
                if page_num not in pages['asim_hafs']:
                    pages['asim_hafs'][page_num] = []
                pages['asim_hafs'][page_num].append((sura_num, aya_num))
            
            if madani_page:
                page_num = int(madani_page) + 1  # Tanzil is 0-indexed
                if page_num not in pages['nafi_warsh']:
                    pages['nafi_warsh'][page_num] = []
                pages['nafi_warsh'][page_num].append((sura_num, aya_num))
    
    return pages

def create_page_json(page_num, ayahs, qiraat_id):
    """Create a page JSON with proper ayah data."""
    page_data = {
        "pageNumber": page_num,
        "qiraatId": qiraat_id,
        "ayahs": []
    }
    
    # Add placeholder positions for each ayah
    y_pos = 0.15
    for surah_num, ayah_num in ayahs:
        ayah_entry = {
            "surahNumber": surah_num,
            "ayahNumber": ayah_num,
            "positions": [{
                "x": 0.15,
                "y": y_pos,
                "width": 0.7,
                "height": 0.08,
                "lineNumber": 0
            }]
        }
        page_data["ayahs"].append(ayah_entry)
        y_pos += 0.08
    
    return page_data

def main():
    """Regenerate all page JSON files."""
    print("Loading Tanzil data...")
    pages_data = load_tanzil_data()
    
    base_path = Path(__file__).parent.parent / 'assets' / 'json' / 'bounds'
    
    for qiraat in ['asim_hafs', 'nafi_warsh']:
        print(f"\nRegenerating {qiraat} pages...")
        qiraat_path = base_path / qiraat
        qiraat_path.mkdir(parents=True, exist_ok=True)
        
        pages = pages_data[qiraat]
        total_pages = len(pages)
        
        for page_num in sorted(pages.keys()):
            ayahs = pages[page_num]
            page_json = create_page_json(page_num, ayahs, qiraat)
            
            output_file = qiraat_path / f'page_{page_num}.json'
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(page_json, f, ensure_ascii=False, indent=2)
            
            print(f"  Page {page_num}: {len(ayahs)} ayahs", end='')
            # Show surah info
            surahs = sorted(set(s for s, a in ayahs))
            if len(surahs) == 1:
                ayah_nums = sorted(a for s, a in ayahs)
                print(f" (Surah {surahs[0]}: {ayah_nums[0]}-{ayah_nums[-1]})")
            else:
                print(f" ({len(surahs)} surahs)")
        
        print(f"\n✅ Generated {total_pages} pages for {qiraat}")
    
    print("\n✅ All pages regenerated!")

if __name__ == '__main__':
    main()
