#!/usr/bin/env python3
"""
Fix all page JSON files to only include ayahs that are actually on each page.
Removes duplicate ayahs 1-X that were incorrectly added.
"""

import json
import os
from pathlib import Path

def fix_page_json(page_path):
    """Fix a single page JSON by removing ayahs from 1 to actual_first_ayah-1."""
    try:
        with open(page_path, 'r', encoding='utf-8') as f:
            page_data = json.load(f)
        
        ayahs = page_data.get('ayahs', [])
        if not ayahs:
            return False
        
        # Group ayahs by surah
        surahs = {}
        for ayah in ayahs:
            surah_num = ayah['surahNumber']
            ayah_num = ayah['ayahNumber']
            if surah_num not in surahs:
                surahs[surah_num] = []
            surahs[surah_num].append(ayah_num)
        
        # For each surah, find the actual range on this page
        ayahs_to_keep = []
        changed = False
        
        for surah_num, ayah_nums in surahs.items():
            ayah_nums_sorted = sorted(set(ayah_nums))
            
            # Check if we have consecutive ayahs from 1 to X
            # If so, we need to find where the actual page starts
            
            # Find the largest gap in the sequence
            largest_gap_start = None
            largest_gap = 0
            
            for i in range(len(ayah_nums_sorted) - 1):
                current = ayah_nums_sorted[i]
                next_ayah = ayah_nums_sorted[i + 1]
                gap = next_ayah - current - 1
                
                if gap > largest_gap:
                    largest_gap = gap
                    largest_gap_start = current
            
            # If there's a large gap, keep only ayahs AFTER the gap
            if largest_gap > 5:  # Arbitrary threshold for a "large" gap
                # Keep ayahs after the gap
                actual_start = largest_gap_start + 1 if largest_gap_start else ayah_nums_sorted[0]
                ayahs_to_keep_for_surah = [a for a in ayah_nums_sorted if a > largest_gap_start]
                changed = True
                print(f"  Surah {surah_num}: Removing ayahs 1-{largest_gap_start}, keeping {ayahs_to_keep_for_surah[0]}-{ayahs_to_keep_for_surah[-1]}")
            else:
                # No large gap, keep all ayahs
                ayahs_to_keep_for_surah = ayah_nums_sorted
            
            ayahs_to_keep.extend([(surah_num, a) for a in ayahs_to_keep_for_surah])
        
        if not changed:
            return False
        
        # Filter the ayahs list to keep only the correct ones
        filtered_ayahs = []
        for ayah in ayahs:
            if (ayah['surahNumber'], ayah['ayahNumber']) in ayahs_to_keep:
                filtered_ayahs.append(ayah)
        
        # Update the page data
        page_data['ayahs'] = filtered_ayahs
        
        # Write back to file
        with open(page_path, 'w', encoding='utf-8') as f:
            json.dump(page_data, f, ensure_ascii=False, indent=2)
        
        return True
        
    except Exception as e:
        print(f"  Error: {e}")
        return False

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
            print(f"Checking page {page_num}...", end=' ')
            
            if fix_page_json(page_file):
                fixed_count += 1
                print("✓ Fixed")
            else:
                print("OK")
        
        print(f"\nFixed {fixed_count} pages in {qiraat}")
    
    print("\n✅ Done!")

if __name__ == '__main__':
    main()
