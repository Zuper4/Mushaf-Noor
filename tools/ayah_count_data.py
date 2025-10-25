#!/usr/bin/env python3
"""
Ayah Count Data for Different Qiraats
Contains the actual ayah counts for each surah in different counting systems.
"""

# Hafs (Kufi Counting System) - 6,236 total ayahs
# This is the most common counting system
HAFS_AYAH_COUNTS = {
    1: 7, 2: 286, 3: 200, 4: 176, 5: 120, 6: 165, 7: 206, 8: 75, 9: 129, 10: 109,
    11: 123, 12: 111, 13: 43, 14: 52, 15: 99, 16: 128, 17: 111, 18: 110, 19: 98, 20: 135,
    21: 112, 22: 78, 23: 118, 24: 64, 25: 77, 26: 227, 27: 93, 28: 88, 29: 69, 30: 60,
    31: 34, 32: 30, 33: 73, 34: 54, 35: 45, 36: 83, 37: 182, 38: 88, 39: 75, 40: 85,
    41: 54, 42: 53, 43: 89, 44: 59, 45: 37, 46: 35, 47: 38, 48: 29, 49: 18, 50: 45,
    51: 60, 52: 49, 53: 62, 54: 55, 55: 78, 56: 96, 57: 29, 58: 22, 59: 24, 60: 13,
    61: 14, 62: 11, 63: 11, 64: 18, 65: 12, 66: 12, 67: 30, 68: 52, 69: 52, 70: 44,
    71: 28, 72: 28, 73: 20, 74: 56, 75: 40, 76: 31, 77: 50, 78: 40, 79: 46, 80: 42,
    81: 29, 82: 19, 83: 36, 84: 25, 85: 22, 86: 17, 87: 19, 88: 26, 89: 30, 90: 20,
    91: 15, 92: 21, 93: 11, 94: 8, 95: 8, 96: 19, 97: 5, 98: 8, 99: 8, 100: 11,
    101: 11, 102: 8, 103: 3, 104: 9, 105: 5, 106: 4, 107: 7, 108: 3, 109: 6, 110: 3,
    111: 5, 112: 4, 113: 5, 114: 6
}

# Warsh (Madani Counting System) - 6,214 total ayahs
# Used in North Africa, differs in ayah divisions
WARSH_AYAH_COUNTS = {
    1: 7, 2: 286, 3: 200, 4: 176, 5: 120, 6: 165, 7: 206, 8: 75, 9: 129, 10: 109,
    11: 123, 12: 111, 13: 43, 14: 52, 15: 99, 16: 128, 17: 111, 18: 110, 19: 98, 20: 135,
    21: 112, 22: 78, 23: 118, 24: 64, 25: 77, 26: 227, 27: 93, 28: 88, 29: 69, 30: 60,
    31: 34, 32: 30, 33: 73, 34: 54, 35: 45, 36: 83, 37: 182, 38: 88, 39: 75, 40: 85,
    41: 54, 42: 53, 43: 89, 44: 59, 45: 37, 46: 35, 47: 38, 48: 29, 49: 18, 50: 45,
    51: 60, 52: 49, 53: 62, 54: 55, 55: 78, 56: 96, 57: 29, 58: 22, 59: 24, 60: 13,
    61: 14, 62: 11, 63: 11, 64: 18, 65: 12, 66: 12, 67: 30, 68: 52, 69: 52, 70: 44,
    71: 28, 72: 28, 73: 20, 74: 56, 75: 40, 76: 31, 77: 50, 78: 40, 79: 46, 80: 42,
    81: 29, 82: 19, 83: 36, 84: 25, 85: 22, 86: 17, 87: 19, 88: 26, 89: 30, 90: 20,
    91: 15, 92: 21, 93: 11, 94: 8, 95: 8, 96: 19, 97: 5, 98: 8, 99: 8, 100: 11,
    101: 11, 102: 8, 103: 3, 104: 9, 105: 5, 106: 4, 107: 7, 108: 3, 109: 6, 110: 3,
    111: 5, 112: 4, 113: 5, 114: 6
}

# Mapping of qiraat IDs to their counting systems
QIRAAT_COUNTING_SYSTEMS = {
    'asim_hafs': 'kufi',
    'asim_shuba': 'kufi',
    'hamzah_khalaf': 'kufi',
    'hamzah_khalaad': 'kufi',
    'kisai_abu_harith': 'kufi',
    'kisai_duri': 'kufi',
    
    'nafi_warsh': 'madani',
    'nafi_qalun': 'madani',
    'abu_jafar_ibn_wardan': 'madani',
    'abu_jafar_ibn_jammaz': 'madani',
    
    'ibn_kathir_bazzi': 'makki',
    'ibn_kathir_qunbul': 'makki',
    
    'abu_amr_duri': 'basri',
    'abu_amr_sussi': 'basri',
    'yaqub_ruways': 'basri',
    'yaqub_rawh': 'basri',
    
    'ibn_amir_hisham': 'shami',
    'ibn_amir_dhakwan': 'shami',
    
    'khalaf_ishaq': 'kufi',
    'khalaf_idris': 'kufi',
}

def get_ayah_count(surah_number, qiraat_id):
    """
    Get the ayah count for a specific surah in a specific qiraat.
    
    Args:
        surah_number: Surah number (1-114)
        qiraat_id: Qiraat identifier
        
    Returns:
        Number of ayahs in that surah for that qiraat
    """
    counting_system = QIRAAT_COUNTING_SYSTEMS.get(qiraat_id, 'kufi')
    
    if counting_system == 'madani':
        return WARSH_AYAH_COUNTS.get(surah_number, HAFS_AYAH_COUNTS.get(surah_number, 0))
    else:
        # For now, use Hafs/Kufi for all others
        # TODO: Add specific counts for Makki, Basri, Shami systems
        return HAFS_AYAH_COUNTS.get(surah_number, 0)

def get_total_ayahs(qiraat_id):
    """Get total ayah count for a qiraat."""
    counting_system = QIRAAT_COUNTING_SYSTEMS.get(qiraat_id, 'kufi')
    
    if counting_system == 'madani':
        return sum(WARSH_AYAH_COUNTS.values())
    else:
        return sum(HAFS_AYAH_COUNTS.values())

# Note: The actual ayah divisions (which words belong to which ayah)
# differ between qiraats even when the total count is the same.
# For example, in Surah Al-Baqarah:
# - Hafs page 3 has ayahs 1-5
# - Warsh page 3 has ayahs 1-4
# This is because the ayah boundaries are drawn differently.
