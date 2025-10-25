#!/usr/bin/env python3
"""
Parse Tanzil page data and generate page-to-ayah mappings for both Hafs and Warsh.
Tanzil uses Hafs (Kufi) counting. Warsh (Madani) differs only in Al-Baqarah.
"""

import re
import json

# Read the Tanzil XML data
with open('/tmp/all-pages.txt', 'r') as f:
    lines = f.readlines()

# Parse the page data
page_data = []
for line in lines:
    match = re.search(r'index="(\d+)" sura="(\d+)" aya="(\d+)"', line)
    if match:
        page_num = int(match.group(1))
        sura_num = int(match.group(2))
        aya_num = int(match.group(3))
        # Add +1 to page number because Tanzil counts from page 1 = Al-Fatiha
        # but our Mushaf has page 1 = cover, page 2 = Al-Fatiha
        mushaf_page = page_num + 1
        page_data.append({
            'mushaf_page': mushaf_page,
            'tanzil_page': page_num,
            'sura': sura_num,
            'start_aya': aya_num
        })

# Calculate end ayah for each page (start of next page - 1)
for i in range(len(page_data) - 1):
    current = page_data[i]
    next_page = page_data[i + 1]
    
    if current['sura'] == next_page['sura']:
        # Same surah, end ayah is one before next page's start
        current['end_aya'] = next_page['start_aya'] - 1
    else:
        # Different surah, need to know the total ayahs in current surah
        # We'll handle this separately
        current['end_aya'] = None

# Add last page end (Surah 114, Ayah 6)
page_data[-1]['end_aya'] = 6

# Surah ayah counts for Hafs (from your SURAHS data)
HAFS_AYAH_COUNTS = {
    1: 7, 2: 286, 3: 200, 4: 176, 5: 120, 6: 165, 7: 206, 8: 75, 9: 129, 10: 109,
    11: 123, 12: 111, 13: 43, 14: 52, 15: 99, 16: 128, 17: 111, 18: 110, 19: 98, 20: 135,
    21: 112, 22: 78, 23: 118, 24: 64, 25: 77, 26: 227, 27: 93, 28: 88, 29: 69, 30: 60,
    31: 34, 32: 30, 33: 73, 34: 54, 35: 45, 36: 83, 37: 182, 38: 88, 39: 75, 40: 56,
    41: 54, 42: 53, 43: 89, 44: 59, 45: 37, 46: 35, 47: 38, 48: 29, 49: 18, 50: 45,
    51: 60, 52: 49, 53: 62, 54: 55, 55: 78, 56: 96, 57: 29, 58: 22, 59: 24, 60: 13,
    61: 14, 62: 11, 63: 11, 64: 18, 65: 12, 66: 12, 67: 30, 68: 52, 69: 52, 70: 44,
    71: 28, 72: 28, 73: 20, 74: 56, 75: 40, 76: 31, 77: 50, 78: 40, 79: 46, 80: 42,
    81: 29, 82: 19, 83: 36, 84: 25, 85: 22, 86: 17, 87: 19, 88: 26, 89: 30, 90: 20,
    91: 15, 92: 21, 93: 11, 94: 8, 95: 8, 96: 19, 97: 5, 98: 8, 99: 8, 100: 11,
    101: 11, 102: 8, 103: 3, 104: 9, 105: 5, 106: 4, 107: 7, 108: 3, 109: 6, 110: 3,
    111: 5, 112: 4, 113: 5, 114: 6
}

# Fill in missing end_aya values
for i, page in enumerate(page_data):
    if page['end_aya'] is None:
        page['end_aya'] = HAFS_AYAH_COUNTS[page['sura']]

# Print Al-Baqarah pages for Hafs (pages 3-50 in Mushaf numbering)
print("=" * 80)
print("HAFS (Kufi) - Al-Baqarah Page Mappings (Mushaf numbering)")
print("=" * 80)
baqarah_hafs = [p for p in page_data if p['sura'] == 2]
for page in baqarah_hafs:
    print(f"Page {page['mushaf_page']:3d}: Ayah {page['start_aya']:3d}-{page['end_aya']:3d}")

# Now generate Warsh mappings
# Warsh differs from Hafs only in Al-Baqarah:
# - Hafs has 286 ayahs, Warsh has 285 ayahs
# - The difference is on page 3: Hafs has ayah 5 but Warsh doesn't
# - So Warsh is shifted by -1 for all ayahs after page 3

print("\n" + "=" * 80)
print("WARSH (Madani) - Al-Baqarah Page Mappings (Mushaf numbering)")
print("=" * 80)

baqarah_warsh = []
for page in baqarah_hafs:
    warsh_page = page.copy()
    # First page of Baqarah (Mushaf page 3)
    if page['mushaf_page'] == 3:
        # Warsh starts at ayah 1 and ends at ayah 4 (one less than Hafs)
        warsh_page['end_aya'] = 4  # Hafs has 1-5, Warsh has 1-4
    else:
        # All subsequent pages: shift by -1
        warsh_page['start_aya'] = page['start_aya'] - 1
        warsh_page['end_aya'] = page['end_aya'] - 1
    baqarah_warsh.append(warsh_page)
    print(f"Page {warsh_page['mushaf_page']:3d}: Ayah {warsh_page['start_aya']:3d}-{warsh_page['end_aya']:3d}")

# Generate Python dictionary format for baqarah_mappings.py
print("\n" + "=" * 80)
print("Python Dictionary Format for baqarah_mappings.py")
print("=" * 80)

print("\nHAFS_BAQARAH_MAPPING = {")
for page in baqarah_hafs:
    print(f"    {page['mushaf_page']}: ({page['start_aya']}, {page['end_aya']}),")
print("}")

print("\nWARSH_BAQARAH_MAPPING = {")
for page in baqarah_warsh:
    print(f"    {page['mushaf_page']}: ({page['start_aya']}, {page['end_aya']}),")
print("}")

# Also save to JSON for reference
output_data = {
    'hafs_baqarah': {str(p['mushaf_page']): {'start': p['start_aya'], 'end': p['end_aya']} for p in baqarah_hafs},
    'warsh_baqarah': {str(p['mushaf_page']): {'start': p['start_aya'], 'end': p['end_aya']} for p in baqarah_warsh},
    'all_pages_hafs': {str(p['mushaf_page']): {'sura': p['sura'], 'start': p['start_aya'], 'end': p['end_aya']} for p in page_data}
}

with open('/Users/zeydajraou/Documents/Mushaf-Noor/tools/tanzil_page_mappings.json', 'w', encoding='utf-8') as f:
    json.dump(output_data, f, indent=2, ensure_ascii=False)

print("\n✅ Saved mappings to tanzil_page_mappings.json")
