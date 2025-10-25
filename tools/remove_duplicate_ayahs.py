#!/usr/bin/env python3
"""
Fix ALL page JSON files to remove duplicate ayahs.
Pattern: If a page has ayahs starting at N (where N > 1), and also has ayahs 1 to N-1,
remove ayahs 1 to N-1 as they are duplicates.
"""

import json
from pathlib import Path

def fix_page_duplicates(page_data):
    """Remove duplicate ayahs from a page."""
    ayahs = page_data.get('ayahs', [])
    if not ayahs:
        return page_data, False
    
    # Group ayahs by surah
    by_surah = {}
    for ayah in ayahs:
        surah_num = ayah['surahNumber']
        if surah_num not in by_surah:
            by_surah[surah_num] = []
        by_surah[surah_num].append(ayah)
    
    fixed_ayahs = []
    changed = False
    
    for surah_num in sorted(by_surah.keys()):
        surah_ayahs = by_surah[surah_num]
        ayah_numbers = sorted([a['ayahNumber'] for a in surah_ayahs])
        
        # Check if we have the pattern: larger numbers followed by 1-X
        # Example: [1,2,3,4,25,26,27,28,29] should become [25,26,27,28,29]
        
        # Find if there's a big jump in the sequence
        max_gap = 0
        gap_after = None
        
        for i in range(len(ayah_numbers) - 1):
            gap = ayah_numbers[i + 1] - ayah_numbers[i]
            if gap > max_gap:
                max_gap = gap
                gap_after = ayah_numbers[i]
        
        # If there's a gap of more than 3, assume ayahs before the gap are duplicates
        if max_gap > 3:
            # Keep only ayahs AFTER the gap
            keep_from = gap_after + 1
            removed_ayahs = [a for a in ayah_numbers if a < keep_from]
            kept_ayahs = [a for a in ayah_numbers if a >= keep_from]
            
            if removed_ayahs:
                changed = True
                print(f"    Surah {surah_num}: Removing duplicates {removed_ayahs[0]}-{removed_ayahs[-1]}, keeping {kept_ayahs[0]}-{kept_ayahs[-1]}")
            
            # Add only the kept ayahs
            for ayah in surah_ayahs:
                if ayah['ayahNumber'] >= keep_from:
                    fixed_ayahs.append(ayah)
        else:
            # No significant gap, keep all ayahs
            fixed_ayahs.extend(surah_ayahs)
    
    if changed:
        page_data['ayahs'] = fixed_ayahs
    
    return page_data, changed

def main():
    """Fix all page JSONs in both qiraat directories."""
    base_path = Path(__file__).parent.parent / 'assets' / 'json' / 'bounds'
    
    qiraats = ['asim_hafs', 'nafi_warsh']
    
    for qiraat in qiraats:
        qiraat_path = base_path / qiraat
        if not qiraat_path.exists():
            print(f"Skipping {qiraat} - directory not found")
            continue
        
        print(f"\nProcessing {qiraat}...")
        fixed_count = 0
        
        # Process all page files
        for page_file in sorted(qiraat_path.glob('page_*.json')):
            page_num = int(page_file.stem.split('_')[1])
            
            with open(page_file, 'r', encoding='utf-8') as f:
                page_data = json.load(f)
            
            fixed_data, changed = fix_page_duplicates(page_data)
            
            if changed:
                fixed_count += 1
                print(f"  Page {page_num}:")
                
                # Write back
                with open(page_file, 'w', encoding='utf-8') as f:
                    json.dump(fixed_data, f, ensure_ascii=False, indent=2)
        
        print(f"\n✅ Fixed {fixed_count} pages in {qiraat}")
    
    print("\n✅ All pages fixed!")

if __name__ == '__main__':
    main()
