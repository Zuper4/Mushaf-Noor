#!/usr/bin/env python3
"""
Enhanced PDF to Image Converter for Multiple Qiraats
Converts PDF files for different qiraats to web-compatible JPG images
"""

import os
import sys
from pathlib import Path
from pdf2image import convert_from_path
from PIL import Image
import logging

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Configuration
QIRAATS_CONFIG = {
    'khalaf': {
        'pdf_path': 'assets/pdfs/Hamzah/Khalaf.pdf',
        'output_dir': 'assets/images/qiraats/hamzah_khalaf',
        'display_name': 'Khalaf \'an Hamzah'
    },
    'qunbul': {
        'pdf_path': 'assets/pdfs/Ibn_Kathir/Qunbul.pdf', 
        'output_dir': 'assets/images/qiraats/ibn_kathir_qunbul',
        'display_name': 'Qunbul \'an Ibn Kathir'
    },
    'ruwais': {
        'pdf_path': 'assets/pdfs/Ya3qub/Ruwais.pdf',
        'output_dir': 'assets/images/qiraats/yaqub_ruways', 
        'display_name': 'Ruwais \'an Ya\'qub'
    }
}

# Image settings
DPI = 150  # Good balance between quality and file size
IMAGE_QUALITY = 85  # JPEG quality (1-100)
IMAGE_FORMAT = 'JPEG'

def ensure_directory(path):
    """Create directory if it doesn't exist"""
    Path(path).mkdir(parents=True, exist_ok=True)
    logger.info(f"Directory ensured: {path}")

def convert_qiraat_pdf(qiraat_key, config):
    """Convert a single qiraat PDF to images"""
    pdf_path = config['pdf_path']
    output_dir = config['output_dir']
    display_name = config['display_name']
    
    logger.info(f"Starting conversion for {display_name}")
    logger.info(f"PDF: {pdf_path}")
    logger.info(f"Output: {output_dir}")
    
    # Check if PDF exists
    if not os.path.exists(pdf_path):
        logger.error(f"PDF file not found: {pdf_path}")
        return False
    
    # Create output directory
    ensure_directory(output_dir)
    
    try:
        # Convert PDF to images
        logger.info("Converting PDF pages to images...")
        pages = convert_from_path(pdf_path, dpi=DPI)
        total_pages = len(pages)
        logger.info(f"Found {total_pages} pages")
        
        # Check if we have the expected 606 pages
        if total_pages != 606:
            logger.warning(f"Expected 606 pages, got {total_pages} pages")
        
        # Save each page as JPG
        for i, page in enumerate(pages, 1):
            # Format page number with leading zeros (001, 002, etc.)
            page_num = f"{i:03d}"
            output_path = os.path.join(output_dir, f"page_{page_num}.jpg")
            
            # Convert and save with optimization
            page.save(output_path, IMAGE_FORMAT, quality=IMAGE_QUALITY, optimize=True)
            
            # Progress indicator
            if i % 50 == 0 or i == total_pages:
                logger.info(f"Processed {i}/{total_pages} pages ({i/total_pages*100:.1f}%)")
        
        logger.info(f"✅ Successfully converted {display_name}: {total_pages} pages")
        return True
        
    except Exception as e:
        logger.error(f"❌ Error converting {display_name}: {str(e)}")
        return False

def convert_all_qiraats():
    """Convert all configured qiraats"""
    logger.info("=== Starting Multiple Qiraats Conversion ===")
    
    successful = 0
    failed = 0
    
    for qiraat_key, config in QIRAATS_CONFIG.items():
        logger.info(f"\n--- Processing {qiraat_key.upper()} ---")
        
        if convert_qiraat_pdf(qiraat_key, config):
            successful += 1
        else:
            failed += 1
    
    logger.info(f"\n=== Conversion Summary ===")
    logger.info(f"✅ Successful: {successful}")
    logger.info(f"❌ Failed: {failed}")
    logger.info(f"📊 Total: {successful + failed}")
    
    if successful > 0:
        logger.info(f"\n🎉 Successfully converted {successful} qiraat(s)!")
        logger.info("The converted images are ready for use in your Flutter app.")
    
    return successful, failed

def convert_single_qiraat(qiraat_name):
    """Convert a single qiraat by name"""
    qiraat_name = qiraat_name.lower()
    
    if qiraat_name not in QIRAATS_CONFIG:
        logger.error(f"Unknown qiraat: {qiraat_name}")
        logger.info(f"Available qiraats: {', '.join(QIRAATS_CONFIG.keys())}")
        return False
    
    config = QIRAATS_CONFIG[qiraat_name]
    return convert_qiraat_pdf(qiraat_name, config)

def main():
    """Main function"""
    print("🕌 Mushaf Noor - Multiple Qiraats PDF Converter")
    print("=" * 50)
    
    # Check if specific qiraat was requested
    if len(sys.argv) > 1:
        qiraat_name = sys.argv[1]
        logger.info(f"Converting single qiraat: {qiraat_name}")
        success = convert_single_qiraat(qiraat_name)
        sys.exit(0 if success else 1)
    
    # Convert all qiraats
    successful, failed = convert_all_qiraats()
    
    # Exit with appropriate code
    sys.exit(0 if failed == 0 else 1)

if __name__ == "__main__":
    main()