#!/usr/bin/env python3
"""
Extract Ayah-to-Page Mappings from Qiraat PDFs
Analyzes PDFs to determine which ayahs appear on which pages for each qiraat.
"""

import os
import re
import json
from pathlib import Path
from pdf2image import convert_from_path
import pytesseract
from PIL import Image
import logging

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Arabic ayah number markers
ARABIC_NUMBERS = {
    '٠': 0, '١': 1, '٢': 2, '٣': 3, '٤': 4, '٥': 5, '٦': 6, '٧': 7, '٨': 8, '٩': 9
}

# Ayah marker symbols in Arabic text
AYAH_MARKERS = ['۝', '۞', '﴾', '﴿', '⁽', '⁾']

def arabic_to_int(arabic_num_str):
    """Convert Arabic numerals to integer."""
    result = 0
    for char in arabic_num_str:
        if char in ARABIC_NUMBERS:
            result = result * 10 + ARABIC_NUMBERS[char]
    return result

def extract_ayah_numbers_from_image(image):
    """
    Extract ayah numbers from a page image using OCR.
    Returns list of ayah numbers found on the page.
    """
    # Use Tesseract with Arabic language
    try:
        # Get text with Arabic
        text = pytesseract.image_to_string(image, lang='ara')
        
        # Find ayah numbers (they appear as Arabic numerals surrounded by markers)
        ayah_numbers = []
        
        # Look for patterns like ١ or ٢٠ etc between markers
        lines = text.split('\n')
        for line in lines:
            # Find Arabic numbers
            matches = re.findall(r'[٠-٩]+', line)
            for match in matches:
                try:
                    ayah_num = arabic_to_int(match)
                    if 1 <= ayah_num <= 286:  # Valid ayah range
                        ayah_numbers.append(ayah_num)
                except:
                    continue
        
        return sorted(list(set(ayah_numbers)))
    except Exception as e:
        logger.error(f"Error extracting ayah numbers: {e}")
        return []

def analyze_pdf_pages(pdf_path, start_page=1, end_page=None):
    """
    Analyze a PDF to extract ayah-to-page mappings.
    
    Args:
        pdf_path: Path to the PDF file
        start_page: First page to analyze (default 1)
        end_page: Last page to analyze (default None = all pages)
        
    Returns:
        Dictionary mapping page numbers to ayah information
    """
    logger.info(f"Analyzing PDF: {pdf_path}")
    
    if not os.path.exists(pdf_path):
        logger.error(f"PDF not found: {pdf_path}")
        return {}
    
    page_mappings = {}
    
    try:
        # Convert PDF pages to images
        logger.info("Converting PDF pages to images...")
        images = convert_from_path(
            pdf_path,
            dpi=150,  # Lower DPI for faster processing
            first_page=start_page,
            last_page=end_page
        )
        
        logger.info(f"Analyzing {len(images)} pages...")
        
        for idx, image in enumerate(images):
            page_num = start_page + idx
            logger.info(f"Analyzing page {page_num}...")
            
            # Extract ayah numbers from this page
            ayah_numbers = extract_ayah_numbers_from_image(image)
            
            if ayah_numbers:
                page_mappings[page_num] = {
                    'startAyah': min(ayah_numbers),
                    'endAyah': max(ayah_numbers),
                    'ayahsFound': ayah_numbers,
                    'count': len(ayah_numbers)
                }
                logger.info(f"  Page {page_num}: Ayahs {min(ayah_numbers)}-{max(ayah_numbers)} ({len(ayah_numbers)} found)")
            else:
                logger.warning(f"  Page {page_num}: No ayah numbers detected")
        
        return page_mappings
        
    except Exception as e:
        logger.error(f"Error analyzing PDF: {e}")
        return {}

def analyze_qiraat_mushaf(qiraat_id, pdf_path, output_file):
    """
    Analyze a complete Mushaf PDF for a specific qiraat.
    
    Args:
        qiraat_id: Qiraat identifier (e.g., 'nafi_warsh')
        pdf_path: Path to the Mushaf PDF
        output_file: Where to save the mapping JSON
    """
    logger.info(f"\n{'='*70}")
    logger.info(f"Analyzing Qiraat: {qiraat_id}")
    logger.info(f"PDF: {pdf_path}")
    logger.info(f"{'='*70}\n")
    
    # Analyze pages (skip page 1 which is usually the cover)
    mappings = analyze_pdf_pages(pdf_path, start_page=2, end_page=10)  # Test with first 10 pages
    
    if mappings:
        # Save to JSON
        result = {
            'qiraatId': qiraat_id,
            'pdfPath': pdf_path,
            'totalPages': len(mappings),
            'pageMappings': mappings
        }
        
        os.makedirs(os.path.dirname(output_file), exist_ok=True)
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(result, f, ensure_ascii=False, indent=2)
        
        logger.info(f"\n✓ Saved mappings to: {output_file}")
        logger.info(f"  Total pages analyzed: {len(mappings)}")
    else:
        logger.error("No mappings extracted!")

def main():
    """Analyze PDFs for different qiraats."""
    
    # Base directory
    base_dir = Path(__file__).parent.parent
    
    # Qiraats to analyze
    qiraats = [
        {
            'id': 'asim_hafs',
            'pdf': base_dir / 'assets' / 'pdfs' / 'Asim' / 'Hafs.pdf',
            'output': base_dir / 'tools' / 'ayah_mappings' / 'asim_hafs_mapping.json'
        },
        {
            'id': 'nafi_warsh',
            'pdf': base_dir / 'assets' / 'pdfs' / 'Nafi3' / 'Warsh.pdf',
            'output': base_dir / 'tools' / 'ayah_mappings' / 'nafi_warsh_mapping.json'
        }
    ]
    
    # Analyze each qiraat
    for qiraat in qiraats:
        if qiraat['pdf'].exists():
            analyze_qiraat_mushaf(qiraat['id'], str(qiraat['pdf']), str(qiraat['output']))
        else:
            logger.warning(f"PDF not found: {qiraat['pdf']}")
    
    logger.info("\n" + "="*70)
    logger.info("✓ Analysis complete!")
    logger.info("="*70)

if __name__ == "__main__":
    main()
