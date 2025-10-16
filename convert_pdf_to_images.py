#!/usr/bin/env python3
"""
Convert PDF pages to JPG images for web display
"""

import os
from pdf2image import convert_from_path
from PIL import Image
import sys

def convert_pdf_to_images(pdf_path, output_dir, qiraat_name):
    """
    Convert PDF to images and save them in the specified directory
    """
    print(f"Converting {pdf_path} for qiraat: {qiraat_name}")
    
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    try:
        # Convert PDF to images
        print("Converting PDF pages to images...")
        images = convert_from_path(pdf_path, dpi=150, fmt='jpeg')
        
        print(f"Found {len(images)} pages in PDF")
        
        # Save each page as a separate image
        for i, image in enumerate(images):
            page_num = i + 1
            filename = f"page_{page_num:03d}.jpg"
            filepath = os.path.join(output_dir, filename)
            
            # Optimize image for web display
            # Resize if too large (max width 1200px)
            width, height = image.size
            if width > 1200:
                ratio = 1200 / width
                new_width = 1200
                new_height = int(height * ratio)
                image = image.resize((new_width, new_height), Image.Resampling.LANCZOS)
            
            # Save with good quality but optimized size
            image.save(filepath, 'JPEG', quality=85, optimize=True)
            print(f"Saved page {page_num} as {filename}")
            
        print(f"Successfully converted {len(images)} pages!")
        return len(images)
        
    except Exception as e:
        print(f"Error converting PDF: {e}")
        return 0

def main():
    # Define the mappings for all qiraats except asim_hafs (which we keep as is)
    pdf_mappings = [
        # Nafi3
        {
            'pdf_path': 'assets/pdfs/Nafi3/Warsh.pdf',
            'output_dir': 'assets/images/qiraats/nafi_warsh',
            'qiraat_name': 'nafi_warsh'
        },
        {
            'pdf_path': 'assets/pdfs/Nafi3/Qalun.pdf',
            'output_dir': 'assets/images/qiraats/nafi_qalun',
            'qiraat_name': 'nafi_qalun'
        },
        # Asim - Only Shu3ba (skip Hafs as requested)
        {
            'pdf_path': 'assets/pdfs/Asim/Shu3ba.pdf',
            'output_dir': 'assets/images/qiraats/asim_shuba',
            'qiraat_name': 'asim_shuba'
        },
        # Abu Amr
        {
            'pdf_path': 'assets/pdfs/Abu_Amr/Ad-Duri.pdf',
            'output_dir': 'assets/images/qiraats/abu_amr_duri',
            'qiraat_name': 'abu_amr_duri'
        },
        {
            'pdf_path': 'assets/pdfs/Abu_Amr/As-Sussi.pdf',
            'output_dir': 'assets/images/qiraats/abu_amr_sussi',
            'qiraat_name': 'abu_amr_sussi'
        },
        # Ibn Kathir
        {
            'pdf_path': 'assets/pdfs/Ibn_Kathir/Al-Bazzi.pdf',
            'output_dir': 'assets/images/qiraats/ibn_kathir_bazzi',
            'qiraat_name': 'ibn_kathir_bazzi'
        },
        {
            'pdf_path': 'assets/pdfs/Ibn_Kathir/Qunbul.pdf',
            'output_dir': 'assets/images/qiraats/ibn_kathir_qunbul',
            'qiraat_name': 'ibn_kathir_qunbul'
        },
        # Ibn Amir
        {
            'pdf_path': 'assets/pdfs/Ibn_Amir/Hisham.pdf',
            'output_dir': 'assets/images/qiraats/ibn_amir_hisham',
            'qiraat_name': 'ibn_amir_hisham'
        },
        {
            'pdf_path': 'assets/pdfs/Ibn_Amir/Ibn_Dhakwan.pdf',
            'output_dir': 'assets/images/qiraats/ibn_amir_dhakwan',
            'qiraat_name': 'ibn_amir_dhakwan'
        },
        # Al-Kisai
        {
            'pdf_path': 'assets/pdfs/Al-Kisai/Abu_Al-Harith.pdf',
            'output_dir': 'assets/images/qiraats/kisai_harith',
            'qiraat_name': 'kisai_harith'
        },
        {
            'pdf_path': 'assets/pdfs/Al-Kisai/Ad-Duri.pdf',
            'output_dir': 'assets/images/qiraats/kisai_duri',
            'qiraat_name': 'kisai_duri'
        },
        # Hamzah
        {
            'pdf_path': 'assets/pdfs/Hamzah/Khalaad.pdf',
            'output_dir': 'assets/images/qiraats/hamzah_khalaad',
            'qiraat_name': 'hamzah_khalaad'
        },
        {
            'pdf_path': 'assets/pdfs/Hamzah/Khalaf.pdf',
            'output_dir': 'assets/images/qiraats/hamzah_khalaf',
            'qiraat_name': 'hamzah_khalaf'
        },
        # Abu Jafar
        {
            'pdf_path': 'assets/pdfs/Abu_Jafar/Ibn_Jammaaz.pdf',
            'output_dir': 'assets/images/qiraats/abu_jafar_jammaaz',
            'qiraat_name': 'abu_jafar_jammaaz'
        },
        {
            'pdf_path': 'assets/pdfs/Abu_Jafar/Ibn_Wardaan.pdf',
            'output_dir': 'assets/images/qiraats/abu_jafar_wardaan',
            'qiraat_name': 'abu_jafar_wardaan'
        },
        # Khalaf
        {
            'pdf_path': 'assets/pdfs/Khalaf/Idris.pdf',
            'output_dir': 'assets/images/qiraats/khalaf_idris',
            'qiraat_name': 'khalaf_idris'
        },
        {
            'pdf_path': 'assets/pdfs/Khalaf/Ishaq.pdf',
            'output_dir': 'assets/images/qiraats/khalaf_ishaq',
            'qiraat_name': 'khalaf_ishaq'
        },
        # Ya3qub
        {
            'pdf_path': 'assets/pdfs/Ya3qub/Rawh.pdf',
            'output_dir': 'assets/images/qiraats/yaqub_rawh',
            'qiraat_name': 'yaqub_rawh'
        },
        {
            'pdf_path': 'assets/pdfs/Ya3qub/Ruwais.pdf',
            'output_dir': 'assets/images/qiraats/yaqub_ruwais',
            'qiraat_name': 'yaqub_ruwais'
        }
    ]
    
    base_dir = os.path.dirname(os.path.abspath(__file__))
    
    for mapping in pdf_mappings:
        pdf_path = os.path.join(base_dir, mapping['pdf_path'])
        output_dir = os.path.join(base_dir, mapping['output_dir'])
        
        if os.path.exists(pdf_path):
            pages_converted = convert_pdf_to_images(pdf_path, output_dir, mapping['qiraat_name'])
            if pages_converted > 0:
                print(f"✅ {mapping['qiraat_name']}: {pages_converted} pages converted")
            else:
                print(f"❌ {mapping['qiraat_name']}: conversion failed")
        else:
            print(f"⚠️  PDF not found: {pdf_path}")

if __name__ == "__main__":
    main()