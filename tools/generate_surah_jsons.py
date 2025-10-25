#!/usr/bin/env python3
"""
Generate surah-based JSON files for ayah bounds.
Instead of one JSON per page, this creates one JSON per surah containing all pages.
"""

import json
import os
from pathlib import Path
from baqarah_mappings import get_baqarah_page_range

# Complete Surah data with page ranges
SURAHS = [
    {"number": 1, "name": "Al-Fatiha", "nameArabic": "الفاتحة", "numberOfAyahs": 7, "startPage": 2, "endPage": 2},
    {"number": 2, "name": "Al-Baqarah", "nameArabic": "البقرة", "numberOfAyahs": 286, "startPage": 3, "endPage": 50},
    {"number": 3, "name": "Ali 'Imran", "nameArabic": "آل عمران", "numberOfAyahs": 200, "startPage": 51, "endPage": 76},
    {"number": 4, "name": "An-Nisa", "nameArabic": "النساء", "numberOfAyahs": 176, "startPage": 78, "endPage": 106},
    {"number": 5, "name": "Al-Ma'idah", "nameArabic": "المائدة", "numberOfAyahs": 120, "startPage": 107, "endPage": 128},
    {"number": 6, "name": "Al-An'am", "nameArabic": "الأنعام", "numberOfAyahs": 165, "startPage": 129, "endPage": 150},
    {"number": 7, "name": "Al-A'raf", "nameArabic": "الأعراف", "numberOfAyahs": 206, "startPage": 152, "endPage": 176},
    {"number": 8, "name": "Al-Anfal", "nameArabic": "الأنفال", "numberOfAyahs": 75, "startPage": 178, "endPage": 186},
    {"number": 9, "name": "At-Tawbah", "nameArabic": "التوبة", "numberOfAyahs": 129, "startPage": 188, "endPage": 207},
    {"number": 10, "name": "Yunus", "nameArabic": "يونس", "numberOfAyahs": 109, "startPage": 209, "endPage": 220},
    {"number": 11, "name": "Hud", "nameArabic": "هود", "numberOfAyahs": 123, "startPage": 222, "endPage": 234},
    {"number": 12, "name": "Yusuf", "nameArabic": "يوسف", "numberOfAyahs": 111, "startPage": 236, "endPage": 248},
    {"number": 13, "name": "Ar-Ra'd", "nameArabic": "الرعد", "numberOfAyahs": 43, "startPage": 250, "endPage": 254},
    {"number": 14, "name": "Ibrahim", "nameArabic": "إبراهيم", "numberOfAyahs": 52, "startPage": 256, "endPage": 261},
    {"number": 15, "name": "Al-Hijr", "nameArabic": "الحجر", "numberOfAyahs": 99, "startPage": 263, "endPage": 266},
    {"number": 16, "name": "An-Nahl", "nameArabic": "النحل", "numberOfAyahs": 128, "startPage": 268, "endPage": 281},
    {"number": 17, "name": "Al-Isra", "nameArabic": "الإسراء", "numberOfAyahs": 111, "startPage": 283, "endPage": 292},
    {"number": 18, "name": "Al-Kahf", "nameArabic": "الكهف", "numberOfAyahs": 110, "startPage": 294, "endPage": 304},
    {"number": 19, "name": "Maryam", "nameArabic": "مريم", "numberOfAyahs": 98, "startPage": 306, "endPage": 311},
    {"number": 20, "name": "Ta-Ha", "nameArabic": "طه", "numberOfAyahs": 135, "startPage": 313, "endPage": 321},
    {"number": 21, "name": "Al-Anbiya", "nameArabic": "الأنبياء", "numberOfAyahs": 112, "startPage": 323, "endPage": 331},
    {"number": 22, "name": "Al-Hajj", "nameArabic": "الحج", "numberOfAyahs": 78, "startPage": 333, "endPage": 341},
    {"number": 23, "name": "Al-Mu'minun", "nameArabic": "المؤمنون", "numberOfAyahs": 118, "startPage": 343, "endPage": 349},
    {"number": 24, "name": "An-Nur", "nameArabic": "النور", "numberOfAyahs": 64, "startPage": 351, "endPage": 358},
    {"number": 25, "name": "Al-Furqan", "nameArabic": "الفرقان", "numberOfAyahs": 77, "startPage": 360, "endPage": 366},
    {"number": 26, "name": "Ash-Shu'ara", "nameArabic": "الشعراء", "numberOfAyahs": 227, "startPage": 368, "endPage": 376},
    {"number": 27, "name": "An-Naml", "nameArabic": "النمل", "numberOfAyahs": 93, "startPage": 378, "endPage": 384},
    {"number": 28, "name": "Al-Qasas", "nameArabic": "القصص", "numberOfAyahs": 88, "startPage": 386, "endPage": 395},
    {"number": 29, "name": "Al-'Ankabut", "nameArabic": "العنكبوت", "numberOfAyahs": 69, "startPage": 397, "endPage": 403},
    {"number": 30, "name": "Ar-Rum", "nameArabic": "الروم", "numberOfAyahs": 60, "startPage": 405, "endPage": 410},
    {"number": 31, "name": "Luqman", "nameArabic": "لقمان", "numberOfAyahs": 34, "startPage": 412, "endPage": 414},
    {"number": 32, "name": "As-Sajdah", "nameArabic": "السجدة", "numberOfAyahs": 30, "startPage": 416, "endPage": 417},
    {"number": 33, "name": "Al-Ahzab", "nameArabic": "الأحزاب", "numberOfAyahs": 73, "startPage": 419, "endPage": 427},
    {"number": 34, "name": "Saba", "nameArabic": "سبأ", "numberOfAyahs": 54, "startPage": 429, "endPage": 433},
    {"number": 35, "name": "Fatir", "nameArabic": "فاطر", "numberOfAyahs": 45, "startPage": 435, "endPage": 439},
    {"number": 36, "name": "Ya-Sin", "nameArabic": "يس", "numberOfAyahs": 83, "startPage": 441, "endPage": 445},
    {"number": 37, "name": "As-Saffat", "nameArabic": "الصافات", "numberOfAyahs": 182, "startPage": 447, "endPage": 452},
    {"number": 38, "name": "Sad", "nameArabic": "ص", "numberOfAyahs": 88, "startPage": 454, "endPage": 457},
    {"number": 39, "name": "Az-Zumar", "nameArabic": "الزمر", "numberOfAyahs": 75, "startPage": 459, "endPage": 466},
    {"number": 40, "name": "Ghafir", "nameArabic": "غافر", "numberOfAyahs": 85, "startPage": 468, "endPage": 476},
    {"number": 41, "name": "Fussilat", "nameArabic": "فصلت", "numberOfAyahs": 54, "startPage": 478, "endPage": 482},
    {"number": 42, "name": "Ash-Shura", "nameArabic": "الشورى", "numberOfAyahs": 53, "startPage": 484, "endPage": 488},
    {"number": 43, "name": "Az-Zukhruf", "nameArabic": "الزخرف", "numberOfAyahs": 89, "startPage": 490, "endPage": 495},
    {"number": 44, "name": "Ad-Dukhan", "nameArabic": "الدخان", "numberOfAyahs": 59, "startPage": 497, "endPage": 498},
    {"number": 45, "name": "Al-Jathiyah", "nameArabic": "الجاثية", "numberOfAyahs": 37, "startPage": 500, "endPage": 501},
    {"number": 46, "name": "Al-Ahqaf", "nameArabic": "الأحقاف", "numberOfAyahs": 35, "startPage": 503, "endPage": 506},
    {"number": 47, "name": "Muhammad", "nameArabic": "محمد", "numberOfAyahs": 38, "startPage": 508, "endPage": 510},
    {"number": 48, "name": "Al-Fath", "nameArabic": "الفتح", "numberOfAyahs": 29, "startPage": 512, "endPage": 514},
    {"number": 49, "name": "Al-Hujurat", "nameArabic": "الحجرات", "numberOfAyahs": 18, "startPage": 516, "endPage": 517},
    {"number": 50, "name": "Qaf", "nameArabic": "ق", "numberOfAyahs": 45, "startPage": 519, "endPage": 520},
    {"number": 51, "name": "Adh-Dhariyat", "nameArabic": "الذاريات", "numberOfAyahs": 60, "startPage": 521, "endPage": 522},
    {"number": 52, "name": "At-Tur", "nameArabic": "الطور", "numberOfAyahs": 49, "startPage": 524, "endPage": 525},
    {"number": 53, "name": "An-Najm", "nameArabic": "النجم", "numberOfAyahs": 62, "startPage": 527, "endPage": 527},
    {"number": 54, "name": "Al-Qamar", "nameArabic": "القمر", "numberOfAyahs": 55, "startPage": 529, "endPage": 530},
    {"number": 55, "name": "Ar-Rahman", "nameArabic": "الرحمن", "numberOfAyahs": 78, "startPage": 532, "endPage": 533},
    {"number": 56, "name": "Al-Waqi'ah", "nameArabic": "الواقعة", "numberOfAyahs": 96, "startPage": 535, "endPage": 536},
    {"number": 57, "name": "Al-Hadid", "nameArabic": "الحديد", "numberOfAyahs": 29, "startPage": 538, "endPage": 541},
    {"number": 58, "name": "Al-Mujadila", "nameArabic": "المجادلة", "numberOfAyahs": 22, "startPage": 543, "endPage": 544},
    {"number": 59, "name": "Al-Hashr", "nameArabic": "الحشر", "numberOfAyahs": 24, "startPage": 546, "endPage": 548},
    {"number": 60, "name": "Al-Mumtahanah", "nameArabic": "الممتحنة", "numberOfAyahs": 13, "startPage": 550, "endPage": 550},
    {"number": 61, "name": "As-Saff", "nameArabic": "الصف", "numberOfAyahs": 14, "startPage": 552, "endPage": 552},
    {"number": 62, "name": "Al-Jumu'ah", "nameArabic": "الجمعة", "numberOfAyahs": 11, "startPage": 554, "endPage": 554},
    {"number": 63, "name": "Al-Munafiqun", "nameArabic": "المنافقون", "numberOfAyahs": 11, "startPage": 555, "endPage": 555},
    {"number": 64, "name": "At-Taghabun", "nameArabic": "التغابن", "numberOfAyahs": 18, "startPage": 557, "endPage": 557},
    {"number": 65, "name": "At-Talaq", "nameArabic": "الطلاق", "numberOfAyahs": 12, "startPage": 559, "endPage": 559},
    {"number": 66, "name": "At-Tahrim", "nameArabic": "التحريم", "numberOfAyahs": 12, "startPage": 561, "endPage": 561},
    {"number": 67, "name": "Al-Mulk", "nameArabic": "الملك", "numberOfAyahs": 30, "startPage": 563, "endPage": 563},
    {"number": 68, "name": "Al-Qalam", "nameArabic": "القلم", "numberOfAyahs": 52, "startPage": 565, "endPage": 565},
    {"number": 69, "name": "Al-Haqqah", "nameArabic": "الحاقة", "numberOfAyahs": 52, "startPage": 567, "endPage": 567},
    {"number": 70, "name": "Al-Ma'arij", "nameArabic": "المعارج", "numberOfAyahs": 44, "startPage": 569, "endPage": 569},
    {"number": 71, "name": "Nuh", "nameArabic": "نوح", "numberOfAyahs": 28, "startPage": 571, "endPage": 571},
    {"number": 72, "name": "Al-Jinn", "nameArabic": "الجن", "numberOfAyahs": 28, "startPage": 573, "endPage": 573},
    {"number": 73, "name": "Al-Muzzammil", "nameArabic": "المزمل", "numberOfAyahs": 20, "startPage": 575, "endPage": 575},
    {"number": 74, "name": "Al-Muddaththir", "nameArabic": "المدثر", "numberOfAyahs": 56, "startPage": 576, "endPage": 576},
    {"number": 75, "name": "Al-Qiyamah", "nameArabic": "القيامة", "numberOfAyahs": 40, "startPage": 578, "endPage": 578},
    {"number": 76, "name": "Al-Insan", "nameArabic": "الإنسان", "numberOfAyahs": 31, "startPage": 579, "endPage": 579},
    {"number": 77, "name": "Al-Mursalat", "nameArabic": "المرسلات", "numberOfAyahs": 50, "startPage": 581, "endPage": 581},
    {"number": 78, "name": "An-Naba", "nameArabic": "النبأ", "numberOfAyahs": 40, "startPage": 583, "endPage": 583},
    {"number": 79, "name": "An-Nazi'at", "nameArabic": "النازعات", "numberOfAyahs": 46, "startPage": 584, "endPage": 584},
    {"number": 80, "name": "'Abasa", "nameArabic": "عبس", "numberOfAyahs": 42, "startPage": 586, "endPage": 586},
    {"number": 81, "name": "At-Takwir", "nameArabic": "التكوير", "numberOfAyahs": 29, "startPage": 587, "endPage": 587},
    {"number": 82, "name": "Al-Infitar", "nameArabic": "الإنفطار", "numberOfAyahs": 19, "startPage": 588, "endPage": 588},
    {"number": 83, "name": "Al-Mutaffifin", "nameArabic": "المطففين", "numberOfAyahs": 36, "startPage": 588, "endPage": 589},
    {"number": 84, "name": "Al-Inshiqaq", "nameArabic": "الإنشقاق", "numberOfAyahs": 25, "startPage": 590, "endPage": 590},
    {"number": 85, "name": "Al-Buruj", "nameArabic": "البروج", "numberOfAyahs": 22, "startPage": 591, "endPage": 591},
    {"number": 86, "name": "At-Tariq", "nameArabic": "الطارق", "numberOfAyahs": 17, "startPage": 592, "endPage": 592},
    {"number": 87, "name": "Al-A'la", "nameArabic": "الأعلى", "numberOfAyahs": 19, "startPage": 592, "endPage": 592},
    {"number": 88, "name": "Al-Ghashiyah", "nameArabic": "الغاشية", "numberOfAyahs": 26, "startPage": 593, "endPage": 593},
    {"number": 89, "name": "Al-Fajr", "nameArabic": "الفجر", "numberOfAyahs": 30, "startPage": 594, "endPage": 594},
    {"number": 90, "name": "Al-Balad", "nameArabic": "البلد", "numberOfAyahs": 20, "startPage": 595, "endPage": 595},
    {"number": 91, "name": "Ash-Shams", "nameArabic": "الشمس", "numberOfAyahs": 15, "startPage": 596, "endPage": 596},
    {"number": 92, "name": "Al-Layl", "nameArabic": "الليل", "numberOfAyahs": 21, "startPage": 596, "endPage": 596},
    {"number": 93, "name": "Ad-Dhuha", "nameArabic": "الضحى", "numberOfAyahs": 11, "startPage": 597, "endPage": 597},
    {"number": 94, "name": "Ash-Sharh", "nameArabic": "الشرح", "numberOfAyahs": 8, "startPage": 597, "endPage": 597},
    {"number": 95, "name": "At-Tin", "nameArabic": "التين", "numberOfAyahs": 8, "startPage": 598, "endPage": 598},
    {"number": 96, "name": "Al-'Alaq", "nameArabic": "العلق", "numberOfAyahs": 19, "startPage": 598, "endPage": 598},
    {"number": 97, "name": "Al-Qadr", "nameArabic": "القدر", "numberOfAyahs": 5, "startPage": 599, "endPage": 599},
    {"number": 98, "name": "Al-Bayyinah", "nameArabic": "البينة", "numberOfAyahs": 8, "startPage": 599, "endPage": 599},
    {"number": 99, "name": "Az-Zalzalah", "nameArabic": "الزلزلة", "numberOfAyahs": 8, "startPage": 600, "endPage": 600},
    {"number": 100, "name": "Al-'Adiyat", "nameArabic": "العاديات", "numberOfAyahs": 11, "startPage": 600, "endPage": 600},
    {"number": 101, "name": "Al-Qari'ah", "nameArabic": "القارعة", "numberOfAyahs": 11, "startPage": 601, "endPage": 601},
    {"number": 102, "name": "At-Takathur", "nameArabic": "التكاثر", "numberOfAyahs": 8, "startPage": 601, "endPage": 601},
    {"number": 103, "name": "Al-'Asr", "nameArabic": "العصر", "numberOfAyahs": 3, "startPage": 602, "endPage": 602},
    {"number": 104, "name": "Al-Humazah", "nameArabic": "الهمزة", "numberOfAyahs": 9, "startPage": 602, "endPage": 602},
    {"number": 105, "name": "Al-Fil", "nameArabic": "الفيل", "numberOfAyahs": 5, "startPage": 602, "endPage": 602},
    {"number": 106, "name": "Quraysh", "nameArabic": "قريش", "numberOfAyahs": 4, "startPage": 603, "endPage": 603},
    {"number": 107, "name": "Al-Ma'un", "nameArabic": "الماعون", "numberOfAyahs": 7, "startPage": 603, "endPage": 603},
    {"number": 108, "name": "Al-Kawthar", "nameArabic": "الكوثر", "numberOfAyahs": 3, "startPage": 603, "endPage": 603},
    {"number": 109, "name": "Al-Kafirun", "nameArabic": "الكافرون", "numberOfAyahs": 6, "startPage": 604, "endPage": 604},
    {"number": 110, "name": "An-Nasr", "nameArabic": "النصر", "numberOfAyahs": 3, "startPage": 604, "endPage": 604},
    {"number": 111, "name": "Al-Masad", "nameArabic": "المسد", "numberOfAyahs": 5, "startPage": 604, "endPage": 604},
    {"number": 112, "name": "Al-Ikhlas", "nameArabic": "الإخلاص", "numberOfAyahs": 4, "startPage": 605, "endPage": 605},
    {"number": 113, "name": "Al-Falaq", "nameArabic": "الفلق", "numberOfAyahs": 5, "startPage": 605, "endPage": 605},
    {"number": 114, "name": "An-Nas", "nameArabic": "الناس", "numberOfAyahs": 6, "startPage": 605, "endPage": 605},
]

def get_ayah_count_for_qiraat(surah_number, qiraat_id):
    """
    Get the correct ayah count for a surah in a specific qiraat.
    """
    # Al-Baqarah (Surah 2) is different between Warsh and Hafs
    if surah_number == 2:
        if qiraat_id == "nafi_warsh":
            return 285  # Warsh has 285 ayahs
        else:
            return 286  # Hafs has 286 ayahs
    
    # For all other surahs, use the standard count
    for surah in SURAHS:
        if surah["number"] == surah_number:
            return surah["numberOfAyahs"]
    
    return 0

def generate_placeholder_ayah_data(surah_number, ayah_number, page_number):
    """
    Generate placeholder ayah bound data.
    You'll need to replace this with actual ayah position data from your PDFs.
    """
    return {
        "surahNumber": surah_number,
        "ayahNumber": ayah_number,
        "positions": [
            {
                "x": 0.15,
                "y": 0.35 + (ayah_number % 10) * 0.08,
                "width": 0.7,
                "height": 0.08,
                "lineNumber": 0
            }
        ]
    }

def generate_surah_json(surah, qiraat_id):
    """
    Generate JSON structure for a single surah.
    Contains all pages that this surah spans with beginning and ending ayahs.
    """
    pages = []
    
    # Get the correct ayah count for this qiraat
    total_ayahs = get_ayah_count_for_qiraat(surah["number"], qiraat_id)
    
    # Create page entries for each page this surah spans
    for page_num in range(surah["startPage"], surah["endPage"] + 1):
        page_data = {
            "pageNumber": page_num,
            "startAyah": 1 if page_num == surah["startPage"] else None,
            "endAyah": total_ayahs if page_num == surah["endPage"] else None,
            "ayahs": []
        }
        
        # Special handling for Al-Baqarah (Surah 2)
        if surah["number"] == 2:
            # Try to get actual mapping from baqarah_mappings.py
            mapping = get_baqarah_page_range(page_num, qiraat_id)
            
            if mapping:
                # Use actual mapping
                start_ayah, end_ayah = mapping
            else:
                # Fall back to approximation for pages we don't have mappings for
                ayahs_per_page = max(1, total_ayahs // (surah["endPage"] - surah["startPage"] + 1))
                page_index = page_num - surah["startPage"]
                
                # Estimate based on the offset
                if qiraat_id == "nafi_warsh":
                    # Warsh: estimate with -1 offset throughout
                    start_ayah = 1 + page_index * ayahs_per_page
                else:
                    # Hafs: standard estimation
                    start_ayah = 1 + page_index * ayahs_per_page
                
                end_ayah = min(start_ayah + ayahs_per_page - 1, total_ayahs)
                
                if page_num == surah["endPage"]:
                    end_ayah = total_ayahs
            
            page_data["startAyah"] = start_ayah
            page_data["endAyah"] = end_ayah
            
            for ayah_num in range(start_ayah, end_ayah + 1):
                page_data["ayahs"].append(generate_placeholder_ayah_data(surah["number"], ayah_num, page_num))
        
        # Handle single-page surahs
        elif page_num == surah["startPage"] and page_num == surah["endPage"]:
            # Single page surah - all ayahs on one page
            for ayah_num in range(1, total_ayahs + 1):
                page_data["ayahs"].append(generate_placeholder_ayah_data(surah["number"], ayah_num, page_num))
            page_data["startAyah"] = 1
            page_data["endAyah"] = total_ayahs
        
        # Handle multi-page surahs (other than Al-Baqarah)
        else:
            # Multi-page surah - placeholder logic
            ayahs_per_page = max(1, total_ayahs // (surah["endPage"] - surah["startPage"] + 1))
            page_index = page_num - surah["startPage"]
            start_ayah = page_index * ayahs_per_page + 1
            end_ayah = min(start_ayah + ayahs_per_page - 1, total_ayahs)
            
            if page_num == surah["endPage"]:
                end_ayah = total_ayahs
            
            page_data["startAyah"] = start_ayah
            page_data["endAyah"] = end_ayah
            
            for ayah_num in range(start_ayah, end_ayah + 1):
                page_data["ayahs"].append(generate_placeholder_ayah_data(surah["number"], ayah_num, page_num))
        
        pages.append(page_data)
    
    # Get the correct ayah count for this qiraat
    total_ayahs = get_ayah_count_for_qiraat(surah["number"], qiraat_id)
    
    return {
        "surahNumber": surah["number"],
        "surahName": surah["name"],
        "surahNameArabic": surah["nameArabic"],
        "numberOfAyahs": total_ayahs,  # Use qiraat-specific count
        "startPage": surah["startPage"],
        "endPage": surah["endPage"],
        "qiraatId": qiraat_id,
        "pages": pages
    }

def main():
    """Generate surah-based JSON files for all qiraats."""
    
    # Base directory for bounds
    base_dir = Path(__file__).parent.parent / "assets" / "json" / "bounds"
    
    # Qiraats to generate for
    qiraats = ["asim_hafs", "nafi_warsh"]
    
    for qiraat in qiraats:
        qiraat_dir = base_dir / qiraat
        qiraat_dir.mkdir(parents=True, exist_ok=True)
        
        print(f"\nGenerating JSON files for {qiraat}...")
        
        # Generate a JSON file for each surah
        for surah in SURAHS:
            surah_json = generate_surah_json(surah, qiraat)
            
            # Create filename: surah_001.json, surah_002.json, etc.
            filename = f"surah_{surah['number']:03d}.json"
            filepath = qiraat_dir / filename
            
            # Write JSON file
            with open(filepath, 'w', encoding='utf-8') as f:
                json.dump(surah_json, f, ensure_ascii=False, indent=2)
            
            print(f"  ✓ Created {filename} - {surah['nameArabic']} ({surah['name']}) - Pages {surah['startPage']}-{surah['endPage']}")
        
        print(f"\n✓ Completed {qiraat}: {len(SURAHS)} surah files created")
    
    print("\n" + "="*70)
    print("✓ All JSON files generated successfully!")
    print("="*70)
    print("\nNOTE: The ayah position data is currently placeholder.")
    print("You'll need to:")
    print("1. Use your PDF analysis tool to get actual ayah positions")
    print("2. Determine which ayahs appear on which pages accurately")
    print("3. Update the JSON files with real position data")
    print("\nThe structure is now organized by surah, with each surah JSON")
    print("containing all its pages and their beginning/ending ayahs.")

if __name__ == "__main__":
    main()
