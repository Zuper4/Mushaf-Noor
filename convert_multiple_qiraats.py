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

# Configuration for all 20 Qiraats (10 Qaris × 2 Rawis each)
QIRAATS_CONFIG = {
    # Nafi' from Madinah
    'nafi_qalun': {
        'pdf_path': 'assets/pdfs/Nafi3/Qalun.pdf',
        'output_dir': 'assets/images/qiraats/nafi_qalun',
        'display_name': 'Qalun \'an Nafi\'',
        'qari': 'Nafi\'',
        'rawi': 'Qalun'
    },
    'nafi_warsh': {
        'pdf_path': 'assets/pdfs/Nafi3/Warsh.pdf',
        'output_dir': 'assets/images/qiraats/nafi_warsh',
        'display_name': 'Warsh \'an Nafi\'',
        'qari': 'Nafi\'',
        'rawi': 'Warsh'
    },
    
    # Ibn Kathir from Makkah
    'ibn_kathir_bazzi': {
        'pdf_path': 'assets/pdfs/Ibn_Kathir/Al-Bazzi.pdf',
        'output_dir': 'assets/images/qiraats/ibn_kathir_bazzi',
        'display_name': 'Al-Bazzi \'an Ibn Kathir',
        'qari': 'Ibn Kathir',
        'rawi': 'Al-Bazzi'
    },
    'ibn_kathir_qunbul': {
        'pdf_path': 'assets/pdfs/Ibn_Kathir/Qunbul.pdf',
        'output_dir': 'assets/images/qiraats/ibn_kathir_qunbul',
        'display_name': 'Qunbul \'an Ibn Kathir',
        'qari': 'Ibn Kathir',
        'rawi': 'Qunbul'
    },
    
    # Abu 'Amr from Basra
    'abu_amr_duri': {
        'pdf_path': 'assets/pdfs/Abu_Amr/Ad-Duri.pdf',
        'output_dir': 'assets/images/qiraats/abu_amr_duri',
        'display_name': 'Ad-Duri \'an Abu \'Amr',
        'qari': 'Abu \'Amr',
        'rawi': 'Ad-Duri'
    },
    'abu_amr_sussi': {
        'pdf_path': 'assets/pdfs/Abu_Amr/As-Sussi.pdf',
        'output_dir': 'assets/images/qiraats/abu_amr_sussi',
        'display_name': 'As-Sussi \'an Abu \'Amr',
        'qari': 'Abu \'Amr',
        'rawi': 'As-Sussi'
    },
    
    # Ibn 'Amir from Damascus
    'ibn_amir_hisham': {
        'pdf_path': 'assets/pdfs/Ibn_Amir/Hisham.pdf',
        'output_dir': 'assets/images/qiraats/ibn_amir_hisham',
        'display_name': 'Hisham \'an Ibn \'Amir',
        'qari': 'Ibn \'Amir',
        'rawi': 'Hisham'
    },
    'ibn_amir_dhakwan': {
        'pdf_path': 'assets/pdfs/Ibn_Amir/Ibn_Dhakwan.pdf',
        'output_dir': 'assets/images/qiraats/ibn_amir_dhakwan',
        'display_name': 'Ibn Dhakwan \'an Ibn \'Amir',
        'qari': 'Ibn \'Amir',
        'rawi': 'Ibn Dhakwan'
    },
    
    # 'Asim from Kufa
    'asim_shuba': {
        'pdf_path': 'assets/pdfs/Asim/Shu3ba.pdf',
        'output_dir': 'assets/images/qiraats/asim_shuba',
        'display_name': 'Shu\'ba \'an \'Asim',
        'qari': '\'Asim',
        'rawi': 'Shu\'ba'
    },
    'asim_hafs': {
        'pdf_path': 'assets/pdfs/Asim/Hafs.pdf',
        'output_dir': 'assets/images/qiraats/asim_hafs',
        'display_name': 'Hafs \'an \'Asim',
        'qari': '\'Asim',
        'rawi': 'Hafs'
    },
    
    # Hamzah from Kufa
    'hamzah_khalaad': {
        'pdf_path': 'assets/pdfs/Hamzah/Khalaad.pdf',
        'output_dir': 'assets/images/qiraats/hamzah_khalaad',
        'display_name': 'Khalaad \'an Hamzah',
        'qari': 'Hamzah',
        'rawi': 'Khalaad'
    },
    'hamzah_khalaf': {
        'pdf_path': 'assets/pdfs/Hamzah/Khalaf.pdf',
        'output_dir': 'assets/images/qiraats/hamzah_khalaf',
        'display_name': 'Khalaf \'an Hamzah',
        'qari': 'Hamzah',
        'rawi': 'Khalaf'
    },
    
    # Al-Kisa'i from Kufa
    'kisai_abu_harith': {
        'pdf_path': 'assets/pdfs/Al-Kisai/Abu_Al-Harith.pdf',
        'output_dir': 'assets/images/qiraats/kisai_abu_harith',
        'display_name': 'Abu al-Harith \'an al-Kisa\'i',
        'qari': 'Al-Kisa\'i',
        'rawi': 'Abu al-Harith'
    },
    'kisai_duri': {
        'pdf_path': 'assets/pdfs/Al-Kisai/Ad-Duri.pdf',
        'output_dir': 'assets/images/qiraats/kisai_duri',
        'display_name': 'Ad-Duri \'an al-Kisa\'i',
        'qari': 'Al-Kisa\'i',
        'rawi': 'Ad-Duri'
    },
    
    # Abu Ja'far from Madinah
    'abu_jafar_ibn_wardan': {
        'pdf_path': 'assets/pdfs/Abu_Jafar/Ibn_Wardaan.pdf',
        'output_dir': 'assets/images/qiraats/abu_jafar_ibn_wardan',
        'display_name': 'Ibn Wardan \'an Abu Ja\'far',
        'qari': 'Abu Ja\'far',
        'rawi': 'Ibn Wardan'
    },
    'abu_jafar_ibn_jammaz': {
        'pdf_path': 'assets/pdfs/Abu_Jafar/Ibn_Jammaaz.pdf',
        'output_dir': 'assets/images/qiraats/abu_jafar_ibn_jammaz',
        'display_name': 'Ibn Jammaz \'an Abu Ja\'far',
        'qari': 'Abu Ja\'far',
        'rawi': 'Ibn Jammaz'
    },
    
    # Ya'qub from Basra
    'yaqub_ruways': {
        'pdf_path': 'assets/pdfs/Ya3qub/Ruwais.pdf',
        'output_dir': 'assets/images/qiraats/yaqub_ruways',
        'display_name': 'Ruways \'an Ya\'qub',
        'qari': 'Ya\'qub',
        'rawi': 'Ruways'
    },
    'yaqub_rawh': {
        'pdf_path': 'assets/pdfs/Ya3qub/Rawh.pdf',
        'output_dir': 'assets/images/qiraats/yaqub_rawh',
        'display_name': 'Rawh \'an Ya\'qub',
        'qari': 'Ya\'qub',
        'rawi': 'Rawh'
    },
    
    # Khalaf al-'Ashir
    'khalaf_ishaq': {
        'pdf_path': 'assets/pdfs/Khalaf/Ishaq.pdf',
        'output_dir': 'assets/images/qiraats/khalaf_ishaq',
        'display_name': 'Ishaq \'an Khalaf',
        'qari': 'Khalaf',
        'rawi': 'Ishaq'
    },
    'khalaf_idris': {
        'pdf_path': 'assets/pdfs/Khalaf/Idris.pdf',
        'output_dir': 'assets/images/qiraats/khalaf_idris',
        'display_name': 'Idris \'an Khalaf',
        'qari': 'Khalaf',
        'rawi': 'Idris'
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
    logger.info("=== Starting ALL Qiraats Conversion (20 Recitations) ===")
    logger.info("Converting 10 Qaris × 2 Rawis = 20 total recitations")
    
    successful = 0
    failed = 0
    
    # Group qiraats by Qari for better organization
    qaris = {}
    for qiraat_key, config in QIRAATS_CONFIG.items():
        qari = config['qari']
        if qari not in qaris:
            qaris[qari] = []
        qaris[qari].append((qiraat_key, config))
    
    # Process each Qari's recitations
    for qari_name, qiraat_list in qaris.items():
        logger.info(f"\n🕌 === Processing {qari_name} ({len(qiraat_list)} recitations) ===")
        
        for qiraat_key, config in qiraat_list:
            logger.info(f"\n--- Converting {config['rawi']} 'an {config['qari']} ---")
            
            if convert_qiraat_pdf(qiraat_key, config):
                successful += 1
            else:
                failed += 1
    
    logger.info(f"\n=== Final Conversion Summary ===")
    logger.info(f"✅ Successful: {successful}/20 qiraats")
    logger.info(f"❌ Failed: {failed}/20 qiraats")
    logger.info(f"📊 Success Rate: {successful/20*100:.1f}%")
    
    if successful > 0:
        logger.info(f"\n🎉 Successfully converted {successful} qiraat(s)!")
        logger.info("The converted images are ready for use in your Flutter app.")
        logger.info("All 10 Qaris with their respective Rawis are now available.")
    
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
    print("🕌 Mushaf Noor - Complete Qiraats PDF Converter")
    print("📖 Converting All 20 Qiraats (10 Qaris × 2 Rawis)")
    print("=" * 60)
    
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