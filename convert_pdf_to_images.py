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
    # Define the mappings
    pdf_mappings = [
        {
            'pdf_path': 'assets/pdfs/Nafi3/Warsh.pdf',
            'output_dir': 'assets/images/qiraats/nafi_warsh',
            'qiraat_name': 'nafi_warsh'
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