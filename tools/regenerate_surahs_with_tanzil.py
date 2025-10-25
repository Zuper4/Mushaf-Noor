#!/usr/bin/env python3
"""
Regenerate surah JSON files using accurate Tanzil page-to-ayah mappings.
This replaces the approximate calculations with real data from Tanzil.
"""

import json
import re
from pathlib import Path

# Import the SURAHS constant
import sys
sys.path.append(str(Path(__file__).parent))

# Surah data with corrected page numbers (already has +1 offset)
SURAHS = [
    {"number": 1, "name": "Al-Fatiha", "nameArabic": "الفاتحة", "startPage": 2, "endPage": 2, "numberOfAyahs": 7},
    {"number": 2, "name": "Al-Baqarah", "nameArabic": "البقرة", "startPage": 3, "endPage": 50, "numberOfAyahs": 286},
    {"number": 3, "name": "Ali 'Imran", "nameArabic": "آل عمران", "startPage": 51, "endPage": 77, "numberOfAyahs": 200},
    # ... (rest of surahs - will be filled from existing file)
]

def load_surahs_data():
    """Load SURAHS data from existing generate_surah_jsons.py"""
    with open(Path(__file__).parent / 'generate_surah_jsons.py', 'r') as f:
        content = f.read()
    
    # Extract SURAHS list (very hacky but works)
    import ast
    tree = ast.parse(content)
    for node in ast.walk(tree):
        if isinstance(node, ast.Assign):
            for target in node.targets:
                if isinstance(target, ast.Name) and target.id == 'SURAHS':
                    return ast.literal_eval(node.value)
    return []

def parse_tanzil_pages():
    """Parse Tanzil XML to get page-to-ayah mappings"""
    with open('/tmp/quran-data.xml', 'r') as f:
        content = f.read()
    
    pages_raw = re.findall(r'<page index="(\d+)" sura="(\d+)" aya="(\d+)"', content)
    
    pages = []
    for tanzil_page, sura, aya in pages_raw:
        mushaf_page = int(tanzil_page) + 1
        pages.append({
            'page': mushaf_page,
            'surah': int(sura),
            'start_ayah': int(aya)
        })
    
    return pages

def get_ayah_count_for_qiraat(surah_num, qiraat_id):
    """Get correct ayah count for qiraat"""
    # Only Al-Baqarah differs
    if surah_num == 2:
        return 285 if qiraat_id == 'nafi_warsh' else 286
    
    # For all other surahs, get from SURAHS data
    for surah in SURAHS:
        if surah['number'] == surah_num:
            return surah['numberOfAyahs']
    return 0

def generate_placeholder_ayah_data(surah_num, ayah_num):
    """Generate placeholder position data for an ayah"""
    # Simple placeholder - positions will need to be updated with real PDF data
    return {
        "surahNumber": surah_num,
        "ayahNumber": ayah_num,
        "positions": [
            {
                "x": 0.15,
                "y": 0.35 + (ayah_num % 10) * 0.08,  # Spread ayahs vertically
                "width": 0.7,
                "height": 0.08,
                "lineNumber": 0
            }
        ]
    }

def generate_surah_json_with_tanzil(surah, qiraat_id, tanzil_pages):
    """Generate surah JSON using Tanzil page data"""
    surah_num = surah['number']
    
    # Find all pages for this surah from Tanzil data
    surah_pages = []
    for i, page_info in enumerate(tanzil_pages):
        if page_info['surah'] != surah_num:
            continue
        
        page_num = page_info['page']
        start_ayah = page_info['start_ayah']
        
        # Find end ayah for this page
        # Look at next Tanzil entry
        if i < len(tanzil_pages) - 1:
            next_page = tanzil_pages[i + 1]
            if next_page['surah'] == surah_num:
                # Same surah continues, end is one before next page's start
                end_ayah = next_page['start_ayah'] - 1
            else:
                # Next page is different surah, this page has rest of current surah
                end_ayah = get_ayah_count_for_qiraat(surah_num, qiraat_id)
        else:
            # Last page
            end_ayah = get_ayah_count_for_qiraat(surah_num, qiraat_id)
        
        # Adjust for Warsh (Al-Baqarah only)
        if surah_num == 2 and qiraat_id == 'nafi_warsh':
            # Import baqarah mappings
            sys.path.append(str(Path(__file__).parent))
            from baqarah_mappings import get_baqarah_page_range
            
            mapping = get_baqarah_page_range(page_num, qiraat_id)
            if mapping:
                start_ayah, end_ayah = mapping
        
        # Generate ayah data
        page_data = {
            "pageNumber": page_num,
            "startAyah": start_ayah,
            "endAyah": end_ayah,
            "ayahs": []
        }
        
        for ayah_num in range(start_ayah, end_ayah + 1):
            page_data["ayahs"].append(generate_placeholder_ayah_data(surah_num, ayah_num))
        
        surah_pages.append(page_data)
    
    # Get correct ayah count
    total_ayahs = get_ayah_count_for_qiraat(surah_num, qiraat_id)
    
    # Determine start and end pages
    start_page = surah_pages[0]['pageNumber'] if surah_pages else surah['startPage']
    end_page = surah_pages[-1]['pageNumber'] if surah_pages else surah['endPage']
    
    return {
        "surahNumber": surah_num,
        "surahName": surah['name'],
        "surahNameArabic": surah['nameArabic'],
        "numberOfAyahs": total_ayahs,
        "startPage": start_page,
        "endPage": end_page,
        "qiraatId": qiraat_id,
        "pages": surah_pages
    }

def main():
    print("="*70)
    print("Regenerating Surah JSONs with Tanzil Data")
    print("="*70)
    
    # Load data
    print("\nLoading SURAHS data...")
    global SURAHS
    SURAHS = load_surahs_data()
    print(f"Loaded {len(SURAHS)} surahs")
    
    print("\nParsing Tanzil page data...")
    tanzil_pages = parse_tanzil_pages()
    print(f"Loaded {len(tanzil_pages)} page mappings")
    
    # Generate for both qiraats
    qiraats = ['asim_hafs', 'nafi_warsh']
    base_dir = Path(__file__).parent.parent / 'assets' / 'json' / 'bounds'
    
    for qiraat_id in qiraats:
        print(f"\n{'='*70}")
        print(f"Generating {qiraat_id}...")
        print(f"{'='*70}")
        
        qiraat_dir = base_dir / qiraat_id
        qiraat_dir.mkdir(parents=True, exist_ok=True)
        
        for surah in SURAHS:
            surah_json = generate_surah_json_with_tanzil(surah, qiraat_id, tanzil_pages)
            
            filename = f"surah_{surah['number']:03d}.json"
            filepath = qiraat_dir / filename
            
            with open(filepath, 'w', encoding='utf-8') as f:
                json.dump(surah_json, f, ensure_ascii=False, indent=2)
            
            pages_count = len(surah_json['pages'])
            print(f"  ✓ {filename} - {surah['nameArabic']} ({pages_count} pages)")
        
        print(f"\n✓ Completed {qiraat_id}")
    
    print(f"\n{'='*70}")
    print("✅ All surah JSONs regenerated with Tanzil data!")
    print(f"{'='*70}")

if __name__ == '__main__':
    main()
