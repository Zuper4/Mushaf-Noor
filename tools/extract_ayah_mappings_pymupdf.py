#!/usr/bin/env python3
"""
Extract Ayah-to-Page Mappings from Qiraat PDFs using PyMuPDF
Reads text directly from PDFs to determine which ayahs appear on which pages.
"""

import os
import re
import json
import fitz  # PyMuPDF
from pathlib import Path
import logging
from collections import defaultdict

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Arabic ayah number markers
ARABIC_NUMBERS = {
    '٠': 0, '١': 1, '٢': 2, '٣': 3, '٤': 4, '٥': 5, '٦': 6, '٧': 7, '٨': 8, '٩': 9
}

def arabic_to_int(arabic_num_str):
    """Convert Arabic numerals to integer."""
    result = 0
    for char in arabic_num_str:
        if char in ARABIC_NUMBERS:
            result = result * 10 + ARABIC_NUMBERS[char]
    return result

def extract_ayah_numbers_from_page(page):
    """
    Extract ayah numbers from a PDF page.
    Returns list of ayah numbers found on the page.
    """
    try:
        # Get text from the page
        text = page.get_text()
        
        # Find ayah numbers (Arabic numerals)
        ayah_numbers = set()
        
        # Look for Arabic numbers in the text
        matches = re.findall(r'[٠-٩]+', text)
        
        for match in matches:
            try:
                ayah_num = arabic_to_int(match)
                # Valid ayah range (1-286 for longest surah)
                if 1 <= ayah_num <= 286:
                    ayah_numbers.add(ayah_num)
            except:
                continue
        
        # Also check for common ayah marker patterns
        # Ayah markers often appear as decorative symbols followed by numbers
        marker_patterns = [
            r'[۝۞﴾﴿]\s*([٠-٩]+)',  # Markers followed by numbers
            r'([٠-٩]+)\s*[۝۞﴾﴿]',  # Numbers followed by markers
        ]
        
        for pattern in marker_patterns:
            matches = re.findall(pattern, text)
            for match in matches:
                try:
                    ayah_num = arabic_to_int(match)
                    if 1 <= ayah_num <= 286:
                        ayah_numbers.add(ayah_num)
                except:
                    continue
        
        return sorted(list(ayah_numbers))
        
    except Exception as e:
        logger.error(f"Error extracting from page: {e}")
        return []

def analyze_pdf_document(pdf_path, start_page=2, num_pages=None):
    """
    Analyze a PDF document to extract ayah-to-page mappings.
    
    Args:
        pdf_path: Path to the PDF file
        start_page: First page to analyze (1-indexed, default 2 to skip cover)
        num_pages: Number of pages to analyze (None = all pages)
        
    Returns:
        Dictionary mapping page numbers to ayah information
    """
    logger.info(f"Analyzing PDF: {pdf_path}")
    
    if not os.path.exists(pdf_path):
        logger.error(f"PDF not found: {pdf_path}")
        return {}
    
    page_mappings = {}
    
    try:
        # Open PDF
        doc = fitz.open(pdf_path)
        total_pages = len(doc)
        logger.info(f"PDF has {total_pages} pages")
        
        # Determine page range
        end_page = min(start_page + num_pages - 1, total_pages) if num_pages else total_pages
        
        logger.info(f"Analyzing pages {start_page} to {end_page}...")
        
        # Analyze each page
        for page_num in range(start_page - 1, end_page):  # PyMuPDF uses 0-indexed pages
            actual_page_num = page_num + 1  # Convert to 1-indexed for output
            
            page = doc[page_num]
            logger.info(f"Analyzing page {actual_page_num}...")
            
            # Extract ayah numbers
            ayah_numbers = extract_ayah_numbers_from_page(page)
            
            if ayah_numbers:
                page_mappings[actual_page_num] = {
                    'startAyah': min(ayah_numbers),
                    'endAyah': max(ayah_numbers),
                    'ayahsFound': ayah_numbers,
                    'count': len(ayah_numbers)
                }
                logger.info(f"  ✓ Page {actual_page_num}: Ayahs {min(ayah_numbers)}-{max(ayah_numbers)} ({len(ayah_numbers)} ayahs)")
            else:
                logger.warning(f"  ⚠ Page {actual_page_num}: No ayah numbers detected")
                # Try to get some text to see what's on the page
                text_sample = page.get_text()[:200]
                logger.debug(f"    Text sample: {text_sample}")
        
        doc.close()
        return page_mappings
        
    except Exception as e:
        logger.error(f"Error analyzing PDF: {e}")
        import traceback
        traceback.print_exc()
        return {}

def analyze_qiraat_mushaf(qiraat_id, pdf_path, output_file, num_pages=20):
    """
    Analyze a Mushaf PDF for a specific qiraat.
    
    Args:
        qiraat_id: Qiraat identifier (e.g., 'nafi_warsh')
        pdf_path: Path to the Mushaf PDF
        output_file: Where to save the mapping JSON
        num_pages: Number of pages to analyze (for testing, use small number)
    """
    logger.info(f"\n{'='*70}")
    logger.info(f"Analyzing Qiraat: {qiraat_id}")
    logger.info(f"PDF: {pdf_path}")
    logger.info(f"{'='*70}\n")
    
    # Analyze pages (start from page 2 to skip cover)
    mappings = analyze_pdf_document(pdf_path, start_page=2, num_pages=num_pages)
    
    if mappings:
        # Save to JSON
        result = {
            'qiraatId': qiraat_id,
            'pdfPath': str(pdf_path),
            'totalPagesAnalyzed': len(mappings),
            'pageMappings': mappings
        }
        
        os.makedirs(os.path.dirname(output_file), exist_ok=True)
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(result, f, ensure_ascii=False, indent=2)
        
        logger.info(f"\n✓ Saved mappings to: {output_file}")
        logger.info(f"  Total pages analyzed: {len(mappings)}")
        
        # Show summary
        logger.info("\nSummary of first few pages:")
        for page_num in sorted(list(mappings.keys()))[:5]:
            info = mappings[page_num]
            logger.info(f"  Page {page_num}: Ayahs {info['startAyah']}-{info['endAyah']}")
    else:
        logger.error("No mappings extracted!")
        logger.error("This could mean:")
        logger.error("  1. The PDF doesn't have extractable text")
        logger.error("  2. Ayah numbers are in images, not text")
        logger.error("  3. The ayah number format is different than expected")

def compare_qiraats(hafs_mapping_file, warsh_mapping_file):
    """Compare ayah distributions between two qiraats."""
    logger.info(f"\n{'='*70}")
    logger.info("Comparing Hafs and Warsh distributions")
    logger.info(f"{'='*70}\n")
    
    try:
        with open(hafs_mapping_file, 'r') as f:
            hafs = json.load(f)
        with open(warsh_mapping_file, 'r') as f:
            warsh = json.load(f)
        
        hafs_pages = hafs['pageMappings']
        warsh_pages = warsh['pageMappings']
        
        # Compare same pages
        common_pages = set(hafs_pages.keys()) & set(warsh_pages.keys())
        
        differences = []
        for page in sorted([int(p) for p in common_pages]):
            page_str = str(page)
            hafs_info = hafs_pages[page_str]
            warsh_info = warsh_pages[page_str]
            
            if hafs_info['count'] != warsh_info['count']:
                differences.append({
                    'page': page,
                    'hafs_ayahs': f"{hafs_info['startAyah']}-{hafs_info['endAyah']} ({hafs_info['count']})",
                    'warsh_ayahs': f"{warsh_info['startAyah']}-{warsh_info['endAyah']} ({warsh_info['count']})"
                })
        
        if differences:
            logger.info("Differences found:")
            for diff in differences:
                logger.info(f"  Page {diff['page']}: Hafs {diff['hafs_ayahs']} | Warsh {diff['warsh_ayahs']}")
        else:
            logger.info("No differences found in analyzed pages")
            
    except Exception as e:
        logger.error(f"Error comparing: {e}")

def main():
    """Analyze PDFs for different qiraats."""
    
    # Base directory
    base_dir = Path(__file__).parent.parent
    
    # Create output directory
    output_dir = base_dir / 'tools' / 'ayah_mappings'
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Qiraats to analyze
    qiraats = [
        {
            'id': 'asim_hafs',
            'pdf': base_dir / 'assets' / 'pdfs' / 'Asim' / 'Hafs.pdf',
            'output': output_dir / 'asim_hafs_mapping.json'
        },
        {
            'id': 'nafi_warsh',
            'pdf': base_dir / 'assets' / 'pdfs' / 'Nafi3' / 'Warsh.pdf',
            'output': output_dir / 'nafi_warsh_mapping.json'
        }
    ]
    
    # Analyze each qiraat (test with first 20 pages)
    for qiraat in qiraats:
        if qiraat['pdf'].exists():
            analyze_qiraat_mushaf(qiraat['id'], str(qiraat['pdf']), str(qiraat['output']), num_pages=20)
        else:
            logger.warning(f"PDF not found: {qiraat['pdf']}")
            logger.info(f"Expected location: {qiraat['pdf']}")
    
    # Compare if both mappings exist
    hafs_file = output_dir / 'asim_hafs_mapping.json'
    warsh_file = output_dir / 'nafi_warsh_mapping.json'
    if hafs_file.exists() and warsh_file.exists():
        compare_qiraats(str(hafs_file), str(warsh_file))
    
    logger.info("\n" + "="*70)
    logger.info("✓ Analysis complete!")
    logger.info(f"  Results saved in: {output_dir}")
    logger.info("="*70)

if __name__ == "__main__":
    main()
