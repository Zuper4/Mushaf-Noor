#!/usr/bin/env python3
"""
Copy bounds JSON files from asim_hafs to all other qiraats.
This ensures all riwayats have the same ayah coordinates for audio playback,
so that audio only plays ayahs present on each page.
"""

import json
import shutil
from pathlib import Path

# All qiraat IDs based on the folder structure and provider
QIRAAT_IDS = [
    'nafi_qalun',
    'nafi_warsh',
    'ibn_kathir_bazzi',
    'ibn_kathir_qunbul',
    'abu_amr_duri',
    'abu_amr_sussi',
    'ibn_amir_hisham',
    'ibn_amir_ibn_dhakwan',
    'asim_hafs',  # Source - already exists
    'asim_shuabah',
    'hamzah_khalaf',
    'hamzah_khallad',
    'al_kisai_duri',
    'al_kisai_abu_harith',
    'abu_jafar_ibn_wardan',
    'abu_jafar_ibn_jammaz',
    'yaqub_ruways',
    'yaqub_rouh',
    'khalaf_ishaq',
    'khalaf_idris',
]

def copy_bounds_to_qiraat(source_dir: Path, target_qiraat: str, base_dir: Path):
    """Copy all page JSON files from source to target qiraat, updating qiraatId."""
    
    # Create target directory
    target_dir = base_dir / target_qiraat
    target_dir.mkdir(parents=True, exist_ok=True)
    
    # Get all page JSON files from source
    page_files = sorted(source_dir.glob('page_*.json'))
    
    print(f'\nCopying {len(page_files)} pages to {target_qiraat}...')
    
    for page_file in page_files:
        # Read source JSON
        with open(page_file, 'r', encoding='utf-8') as f:
            page_data = json.load(f)
        
        # Update qiraatId
        page_data['qiraatId'] = target_qiraat
        
        # Write to target
        target_file = target_dir / page_file.name
        with open(target_file, 'w', encoding='utf-8') as f:
            json.dump(page_data, f, ensure_ascii=False, indent=2)
    
    print(f'✓ Completed {target_qiraat}: {len(page_files)} files created')

def main():
    """Copy bounds from asim_hafs to all other qiraats."""
    
    # Base directory for bounds
    base_dir = Path(__file__).parent.parent / 'assets' / 'json' / 'bounds'
    source_dir = base_dir / 'asim_hafs'
    
    if not source_dir.exists():
        print(f'ERROR: Source directory not found: {source_dir}')
        return
    
    print('='*70)
    print('Copying Ayah Bounds to All Qiraats')
    print('='*70)
    print(f'\nSource: {source_dir}')
    print(f'Target qiraats: {len([q for q in QIRAAT_IDS if q != "asim_hafs"])}')
    
    # Copy to each qiraat (except source)
    for qiraat_id in QIRAAT_IDS:
        if qiraat_id == 'asim_hafs':
            print(f'\nSkipping {qiraat_id} (source)')
            continue
        
        copy_bounds_to_qiraat(source_dir, qiraat_id, base_dir)
    
    print('\n' + '='*70)
    print('✓ All bounds copied successfully!')
    print('='*70)
    print('\nNOTE: These coordinates are copied from Hafs.')
    print('You may need to adjust them later for qiraats with different layouts.')

if __name__ == '__main__':
    main()
