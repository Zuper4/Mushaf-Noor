#!/usr/bin/env python3
"""
Generate complete page JSON files using Tanzil page data.
This ensures ALL pages 2-606 are covered.
"""

import json
from pathlib import Path
import re

def parse_tanzil_data():
    """Parse the Tanzil XML to get complete page mappings"""
    with open('/tmp/quran-data.xml', 'r') as f:
        content = f.read()
    
    # Extract all page entries
    pages_raw = re.findall(r'<page index="(\d+)" sura="(\d+)" aya="(\d+)"', content)
    
    # Build page-to-(surah, start_ayah) mapping
    pages = []
    for tanzil_page, sura, aya in pages_raw:
        mushaf_page = int(tanzil_page) + 1  # Tanzil is 0-indexed, add 1 for Mushaf
        pages.append({
            'page': mushaf_page,
            'surah': int(sura),
            'start_ayah': int(aya)
        })
    
    return pages

def load_surah_data(qiraat_id):
    """Load all surah JSON data"""
    base_path = Path(__file__).parent.parent / 'assets' / 'json' / 'bounds' / qiraat_id
    surah_data = {}
    
    for surah_file in sorted(base_path.glob('surah_*.json')):
        with open(surah_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
            surah_num = data['surahNumber']
            surah_data[surah_num] = data
    
    return surah_data

def get_ayahs_for_page(page_num, surah_num, start_ayah, end_ayah, surah_data):
    """Extract ayah data for a specific page from surah data"""
    if surah_num not in surah_data:
        return []
    
    surah = surah_data[surah_num]
    
    # Find the page in this surah's data
    for page in surah['pages']:
        if page['pageNumber'] == page_num:
            # Filter ayahs that fall in our range
            ayahs = []
            for ayah in page['ayahs']:
                if start_ayah <= ayah['ayahNumber'] <= end_ayah:
                    ayahs.append({
                        'surahNumber': ayah['surahNumber'],
                        'ayahNumber': ayah['ayahNumber'],
                        'positions': ayah['positions']
                    })
            return ayahs
    
    return []

def generate_all_page_jsons():
    """Generate complete page JSON files for all pages"""
    
    print("Parsing Tanzil data...")
    tanzil_pages = parse_tanzil_data()
    
    qiraats = ['asim_hafs', 'nafi_warsh']
    
    for qiraat_id in qiraats:
        print(f'\n{"="*70}')
        print(f'Processing {qiraat_id}...')
        print(f'{"="*70}')
        
        # Load all surah data for this qiraat
        surah_data = load_surah_data(qiraat_id)
        print(f'Loaded {len(surah_data)} surahs')
        
        output_path = Path(__file__).parent.parent / 'assets' / 'json' / 'bounds' / qiraat_id
        
        # Process each page
        pages_created = 0
        pages_with_data = 0
        
        for i, page_info in enumerate(tanzil_pages):
            page_num = page_info['page']
            surah_num = page_info['surah']
            start_ayah = page_info['start_ayah']
            
            # Determine end ayah (either start of next page or end of surah)
            if i < len(tanzil_pages) - 1:
                next_page = tanzil_pages[i + 1]
                if next_page['surah'] == surah_num:
                    # Same surah, end is one before next page's start
                    end_ayah = next_page['start_ayah'] - 1
                else:
                    # Different surah, end is last ayah of current surah
                    end_ayah = surah_data[surah_num]['numberOfAyahs']
            else:
                # Last page
                end_ayah = surah_data[surah_num]['numberOfAyahs']
            
            # Get ayah data from surah JSON
            ayahs = get_ayahs_for_page(page_num, surah_num, start_ayah, end_ayah, surah_data)
            
            # Create page JSON
            page_json = {
                'pageNumber': page_num,
                'qiraatId': qiraat_id,
                'ayahs': ayahs
            }
            
            # Write to file
            page_file = output_path / f'page_{page_num}.json'
            with open(page_file, 'w', encoding='utf-8') as f:
                json.dump(page_json, f, ensure_ascii=False, indent=2)
            
            pages_created += 1
            if ayahs:
                pages_with_data += 1
            else:
                print(f'  ⚠️  Page {page_num}: No ayah data found (Surah {surah_num}, ayahs {start_ayah}-{end_ayah})')
        
        print(f'\n✓ Created {pages_created} page JSON files')
        print(f'✓ {pages_with_data} pages have ayah data')
        print(f'⚠️  {pages_created - pages_with_data} pages missing ayah data')
    
    print(f'\n{"="*70}')
    print('✅ All page JSON files generated!')
    print(f'{"="*70}')

if __name__ == '__main__':
    generate_all_page_jsons()
