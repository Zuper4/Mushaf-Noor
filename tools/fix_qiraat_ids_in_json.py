#!/usr/bin/env python3
"""
Fix qiraatId values inside JSON files to match folder names and qiraat provider IDs.
"""

import json
from pathlib import Path

# Mapping of old qiraatId to new qiraatId
ID_CORRECTIONS = {
    'asim_shuabah': 'asim_shuba',
    'ibn_amir_ibn_dhakwan': 'ibn_amir_dhakwan',
    'hamzah_khallad': 'hamzah_khalaad',
    'al_kisai_abu_harith': 'kisai_abu_harith',
    'al_kisai_duri': 'kisai_duri',
    'yaqub_rouh': 'yaqub_rawh',
}

def fix_json_files_in_directory(dir_path: Path, correct_id: str):
    """Fix all JSON files in a directory to have the correct qiraatId."""
    json_files = list(dir_path.glob('page_*.json'))
    
    if not json_files:
        print(f'  ⚠️  No JSON files found in {dir_path.name}')
        return
    
    print(f'  Fixing {len(json_files)} files...')
    
    for json_file in json_files:
        with open(json_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Update qiraatId
        data['qiraatId'] = correct_id
        
        # Write back
        with open(json_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f'  ✓ Fixed {len(json_files)} files with qiraatId: {correct_id}')

def main():
    """Fix qiraatId in all JSON files that need correction."""
    
    base_dir = Path(__file__).parent.parent / 'assets' / 'json' / 'bounds'
    
    print('='*70)
    print('Fixing qiraatId Values in JSON Files')
    print('='*70)
    
    for old_id, new_id in ID_CORRECTIONS.items():
        # The folder has already been renamed to match new_id
        folder = base_dir / new_id
        
        if not folder.exists():
            print(f'\n⚠️  Folder not found: {new_id}')
            continue
        
        print(f'\n{new_id}:')
        print(f'  Changing qiraatId from "{old_id}" to "{new_id}"')
        fix_json_files_in_directory(folder, new_id)
    
    print('\n' + '='*70)
    print('✓ All qiraatId values fixed!')
    print('='*70)

if __name__ == '__main__':
    main()
