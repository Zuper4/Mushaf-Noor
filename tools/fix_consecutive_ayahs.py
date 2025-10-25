#!/usr/bin/env python3
"""
Fix page JSON files to have consecutive ayah sequences.
Each page should continue from where the previous page ended.
"""

import json
from pathlib import Path

def fix_all_pages(qiraat_path):
    """Fix all pages in a qiraat directory to have consecutive ayahs."""
    page_files = sorted(qiraat_path.glob('page_*.json'), 
                       key=lambda x: int(x.stem.split('_')[1]))
    
    fixed_count = 0
    prev_surah = None
    prev_last_ayah = 0
    
    for page_file in page_files:
        page_num = int(page_file.stem.split('_')[1])
        
        with open(page_file, 'r', encoding='utf-8') as f:
            page_data = json.load(f)
        
        ayahs = page_data.get('ayahs', [])
        if not ayahs:
            continue
        
        # Group by surah
        by_surah = {}
        for ayah in ayahs:
            s = ayah['surahNumber']
            if s not in by_surah:
                by_surah[s] = []
            by_surah[s].append(ayah)
        
        # For each surah on this page
        fixed_ayahs = []
        changed = False
        
        for surah_num in sorted(by_surah.keys()):
            surah_ayahs = by_surah[surah_num]
            ayah_numbers = sorted([a['ayahNumber'] for a in surah_ayahs])
            
            # Determine the expected first ayah
            expected_first = 1
            if surah_num == prev_surah:
                expected_first = prev_last_ayah + 1
            
            # Check if we have ayahs before the expected first
            if ayah_numbers[0] < expected_first:
                # Remove ayahs before expected_first
                removed = [a for a in ayah_numbers if a < expected_first]
                kept = [a for a in ayah_numbers if a >= expected_first]
                
                if removed:
                    changed = True
                    fixed_count += 1
                    print(f"  Page {page_num}, Surah {surah_num}: Removing {removed[0]}-{removed[-1]}, keeping {kept[0] if kept else 'none'}-{kept[-1] if kept else 'none'}")
                
                # Add only kept ayahs
                for ayah in surah_ayahs:
                    if ayah['ayahNumber'] >= expected_first:
                        fixed_ayahs.append(ayah)
            else:
                # All ayahs are valid
                fixed_ayahs.extend(surah_ayahs)
            
            # Update prev tracking
            if fixed_ayahs:
                last_ayahs = [a for a in fixed_ayahs if a['surahNumber'] == surah_num]
                if last_ayahs:
                    prev_last_ayah = max(a['ayahNumber'] for a in last_ayahs)
                    prev_surah = surah_num
        
        if changed:
            page_data['ayahs'] = fixed_ayahs
            with open(page_file, 'w', encoding='utf-8') as f:
                json.dump(page_data, f, ensure_ascii=False, indent=2)
    
    return fixed_count

def main():
    """Fix all page JSONs in both qiraat directories."""
    base_path = Path(__file__).parent.parent / 'assets' / 'json' / 'bounds'
    
    for qiraat in ['asim_hafs', 'nafi_warsh']:
        qiraat_path = base_path / qiraat
        if not qiraat_path.exists():
            print(f"Skipping {qiraat} - directory not found")
            continue
        
        print(f"\nProcessing {qiraat}...")
        fixed_count = fix_all_pages(qiraat_path)
        
        print(f"✅ Fixed {fixed_count} issues in {qiraat}")
    
    print("\n✅ Done!")

if __name__ == '__main__':
    main()
