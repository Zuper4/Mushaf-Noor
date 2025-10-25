"""
Ayah Bounds Annotation Tool
This script helps create JSON files that map ayah positions on Mushaf pages.

Usage:
1. Prepare your Mushaf page images
2. For each page, annotate ayah boundaries
3. Export to JSON format compatible with the app

Requirements:
- Python 3.8+
- PIL (Pillow)
- tkinter (usually comes with Python)

Install dependencies:
pip install pillow

Run:
python ayah_bounds_annotator.py
"""

import json
import tkinter as tk
from tkinter import filedialog, messagebox
from PIL import Image, ImageTk
import os


class AyahBoundsAnnotator:
    def __init__(self, root):
        self.root = root
        self.root.title("Ayah Bounds Annotator")
        
        self.image_path = None
        self.image = None
        self.photo = None
        self.canvas = None
        
        self.qiraat_id = "asim_hafs"
        self.page_number = 1
        self.current_ayah = {"surah": 1, "ayah": 1}
        self.annotations = []
        
        self.rect_start = None
        self.current_rect = None
        
        self.setup_ui()
    
    def setup_ui(self):
        # Top frame for controls
        control_frame = tk.Frame(self.root)
        control_frame.pack(side=tk.TOP, fill=tk.X, padx=5, pady=5)
        
        # Load image button
        tk.Button(control_frame, text="Load Image", command=self.load_image).pack(side=tk.LEFT, padx=5)
        
        # Qiraat ID
        tk.Label(control_frame, text="Qiraat ID:").pack(side=tk.LEFT, padx=5)
        self.qiraat_entry = tk.Entry(control_frame, width=15)
        self.qiraat_entry.insert(0, self.qiraat_id)
        self.qiraat_entry.pack(side=tk.LEFT, padx=5)
        
        # Page number
        tk.Label(control_frame, text="Page:").pack(side=tk.LEFT, padx=5)
        self.page_entry = tk.Entry(control_frame, width=5)
        self.page_entry.insert(0, str(self.page_number))
        self.page_entry.pack(side=tk.LEFT, padx=5)
        
        # Current ayah
        tk.Label(control_frame, text="Surah:").pack(side=tk.LEFT, padx=5)
        self.surah_entry = tk.Entry(control_frame, width=5)
        self.surah_entry.insert(0, "1")
        self.surah_entry.pack(side=tk.LEFT, padx=5)
        
        tk.Label(control_frame, text="Ayah:").pack(side=tk.LEFT, padx=5)
        self.ayah_entry = tk.Entry(control_frame, width=5)
        self.ayah_entry.insert(0, "1")
        self.ayah_entry.pack(side=tk.LEFT, padx=5)
        
        # Undo button
        tk.Button(control_frame, text="Undo", command=self.undo_last).pack(side=tk.LEFT, padx=5)
        
        # Export button
        tk.Button(control_frame, text="Export JSON", command=self.export_json).pack(side=tk.LEFT, padx=5)
        
        # Canvas for image and drawing
        self.canvas = tk.Canvas(self.root, bg="gray")
        self.canvas.pack(fill=tk.BOTH, expand=True)
        
        # Bind mouse events
        self.canvas.bind("<Button-1>", self.on_mouse_down)
        self.canvas.bind("<B1-Motion>", self.on_mouse_drag)
        self.canvas.bind("<ButtonRelease-1>", self.on_mouse_up)
        
        # Instructions
        instructions = """
        Instructions:
        1. Load a Mushaf page image
        2. Set the Qiraat ID and Page number
        3. Set current Surah and Ayah numbers
        4. Click and drag to draw a bounding box around the ayah
        5. The ayah will be saved automatically
        6. Continue with the next ayah (increment ayah number)
        7. Click "Export JSON" when done with the page
        
        Tips:
        - For multi-line ayahs, draw multiple boxes (keep surah:ayah the same)
        - Use "Undo" to remove the last annotation
        - Boxes are drawn in red, completed boxes turn green
        """
        
        info_label = tk.Label(self.root, text=instructions, justify=tk.LEFT, bg="lightyellow")
        info_label.pack(side=tk.BOTTOM, fill=tk.X)
    
    def load_image(self):
        file_path = filedialog.askopenfilename(
            title="Select Mushaf Page Image",
            filetypes=[("Image files", "*.png *.jpg *.jpeg *.bmp")]
        )
        
        if file_path:
            self.image_path = file_path
            self.image = Image.open(file_path)
            
            # Resize if too large
            max_size = (1200, 1600)
            self.image.thumbnail(max_size, Image.Resampling.LANCZOS)
            
            self.photo = ImageTk.PhotoImage(self.image)
            self.canvas.config(width=self.image.width, height=self.image.height)
            self.canvas.create_image(0, 0, anchor=tk.NW, image=self.photo)
            
            # Redraw existing annotations
            self.redraw_annotations()
    
    def on_mouse_down(self, event):
        self.rect_start = (event.x, event.y)
        self.current_rect = None
    
    def on_mouse_drag(self, event):
        if self.rect_start:
            if self.current_rect:
                self.canvas.delete(self.current_rect)
            
            self.current_rect = self.canvas.create_rectangle(
                self.rect_start[0], self.rect_start[1],
                event.x, event.y,
                outline="red", width=2
            )
    
    def on_mouse_up(self, event):
        if self.rect_start and self.image:
            x1, y1 = self.rect_start
            x2, y2 = event.x, event.y
            
            # Ensure x1 < x2 and y1 < y2
            if x1 > x2:
                x1, x2 = x2, x1
            if y1 > y2:
                y1, y2 = y2, y1
            
            # Normalize coordinates
            width = self.image.width
            height = self.image.height
            
            annotation = {
                "surah": int(self.surah_entry.get()),
                "ayah": int(self.ayah_entry.get()),
                "x": x1 / width,
                "y": y1 / height,
                "width": (x2 - x1) / width,
                "height": (y2 - y1) / height,
                "lineNumber": 0  # You can add UI to set this if needed
            }
            
            self.annotations.append(annotation)
            
            # Change color to green for completed
            if self.current_rect:
                self.canvas.delete(self.current_rect)
            
            self.canvas.create_rectangle(
                x1, y1, x2, y2,
                outline="green", width=2
            )
            
            # Add label
            self.canvas.create_text(
                x1 + 5, y1 + 5,
                text=f"{annotation['surah']}:{annotation['ayah']}",
                anchor=tk.NW, fill="green", font=("Arial", 10, "bold")
            )
            
            # Auto-increment ayah
            current_ayah = int(self.ayah_entry.get())
            self.ayah_entry.delete(0, tk.END)
            self.ayah_entry.insert(0, str(current_ayah + 1))
            
            self.rect_start = None
            self.current_rect = None
    
    def undo_last(self):
        if self.annotations:
            self.annotations.pop()
            self.redraw_annotations()
    
    def redraw_annotations(self):
        if not self.image:
            return
        
        # Clear canvas and redraw image
        self.canvas.delete("all")
        self.canvas.create_image(0, 0, anchor=tk.NW, image=self.photo)
        
        # Redraw annotations
        width = self.image.width
        height = self.image.height
        
        for ann in self.annotations:
            x1 = ann["x"] * width
            y1 = ann["y"] * height
            x2 = x1 + (ann["width"] * width)
            y2 = y1 + (ann["height"] * height)
            
            self.canvas.create_rectangle(
                x1, y1, x2, y2,
                outline="green", width=2
            )
            
            self.canvas.create_text(
                x1 + 5, y1 + 5,
                text=f"{ann['surah']}:{ann['ayah']}",
                anchor=tk.NW, fill="green", font=("Arial", 10, "bold")
            )
    
    def export_json(self):
        if not self.annotations:
            messagebox.showwarning("No Annotations", "Please annotate at least one ayah before exporting.")
            return
        
        # Group annotations by surah:ayah
        ayah_groups = {}
        for ann in self.annotations:
            key = (ann["surah"], ann["ayah"])
            if key not in ayah_groups:
                ayah_groups[key] = []
            ayah_groups[key].append({
                "x": ann["x"],
                "y": ann["y"],
                "width": ann["width"],
                "height": ann["height"],
                "lineNumber": ann["lineNumber"]
            })
        
        # Build final JSON structure
        ayahs_list = []
        for (surah, ayah), positions in sorted(ayah_groups.items()):
            ayahs_list.append({
                "surahNumber": surah,
                "ayahNumber": ayah,
                "positions": positions
            })
        
        output = {
            "pageNumber": int(self.page_entry.get()),
            "qiraatId": self.qiraat_entry.get(),
            "ayahs": ayahs_list
        }
        
        # Save to file
        default_name = f"page_{output['pageNumber']}.json"
        file_path = filedialog.asksaveasfilename(
            title="Save JSON",
            defaultextension=".json",
            initialfile=default_name,
            filetypes=[("JSON files", "*.json")]
        )
        
        if file_path:
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(output, f, indent=2, ensure_ascii=False)
            
            messagebox.showinfo("Success", f"Exported to {file_path}")


if __name__ == "__main__":
    root = tk.Tk()
    app = AyahBoundsAnnotator(root)
    root.mainloop()
