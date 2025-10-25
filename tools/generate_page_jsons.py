#!/usr/bin/env python3
"""
Generate page-based JSON files from surah-based JSON files.
This creates page_X.json files that the Flutter app expects.
Handles pages that span multiple surahs.
"""

import json
import os
from pathlib import Path
from collections import defaultdict

def generate_page_jsons():
    """Generate page-based JSON files for both qiraats"""
    
    qiraats = ['asim_hafs', 'nafi_warsh']
    base_path = Path(__file__).parent.parent / 'assets' / 'json' / 'bounds'
    
    for qiraat_id in qiraats:
        print(f'\nGenerating page JSON files for {qiraat_id}...')
        qiraat_path = base_path / qiraat_id
        
        # Dictionary to store all pages data - use defaultdict to handle multiple surahs per page
        all_pages = defaultdict(lambda: {'ayahs': []})
        
        # Read all surah JSON files
        for surah_file in sorted(qiraat_path.glob('surah_*.json')):
            with open(surah_file, 'r', encoding='utf-8') as f:
                surah_data = json.load(f)
            
            # Extract pages from this surah
            for page in surah_data['pages']:
                page_number = page['pageNumber']
                
                # Initialize page structure if first time seeing it
                if 'pageNumber' not in all_pages[page_number]:
                    all_pages[page_number]['pageNumber'] = page_number
                    all_pages[page_number]['qiraatId'] = qiraat_id
                
                # Add all ayahs for this page
                for ayah in page['ayahs']:
                    ayah_bound = {
                        'surahNumber': ayah['surahNumber'],
                        'ayahNumber': ayah['ayahNumber'],
                        'positions': ayah['positions']
                    }
                    all_pages[page_number]['ayahs'].append(ayah_bound)
        
        # Write each page to its own JSON file
        for page_number in sorted(all_pages.keys()):
            page_data = dict(all_pages[page_number])  # Convert defaultdict to regular dict
            page_file = qiraat_path / f'page_{page_number}.json'
            with open(page_file, 'w', encoding='utf-8') as f:
                json.dump(page_data, f, ensure_ascii=False, indent=2)
            
        print(f'  ✓ Created {len(all_pages)} page JSON files for {qiraat_id}')
        
        # Report missing pages
        missing_pages = []
        for p in range(2, 607):  # Pages 2-606 (skip page 1 which is cover)
            if p not in all_pages:
                missing_pages.append(p)
        
        if missing_pages:
            print(f'  ⚠️  Warning: {len(missing_pages)} pages still missing (likely between-surah pages)')
            print(f'     Missing pages: {missing_pages[:20]}...' if len(missing_pages) > 20 else f'     Missing pages: {missing_pages}')
    
    print('\n✅ All page JSON files generated successfully!')

if __name__ == '__main__':
    generate_page_jsons()
