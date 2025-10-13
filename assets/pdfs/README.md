# PDF Assets Structure - 10 Qaris with their Rawis

This folder contains the Quran PDF files organized by the traditional 10 Qaris, each with their 2 Rawis.

## Folder Organization (10 Qaris):

### `Nafi3/` (Imam Nafi' from Madinah)
- **Rawi 1**: `Qaloon.pdf` - Qaloon 'an Nafi'
- **Rawi 2**: `Warsh.pdf` - Warsh 'an Nafi'

### `Ibn_Kathir/` (Ibn Kathir from Makkah)
- **Rawi 1**: `Al_Buzzi.pdf` - Al-Buzzi 'an Ibn Kathir
- **Rawi 2**: `Qunbul.pdf` - Qunbul 'an Ibn Kathir

### `Abu_Amr/` (Abu 'Amr from Basra)
- **Rawi 1**: `Al_Douri.pdf` - Al-Douri 'an Abu 'Amr
- **Rawi 2**: `Al_Sousi.pdf` - As-Sousi 'an Abu 'Amr

### `Ibn_Amir/` (Ibn 'Amir from Damascus)
- **Rawi 1**: `Hisham.pdf` - Hisham 'an Ibn 'Amir
- **Rawi 2**: `Ibn_Dhakwan.pdf` - Ibn Dhakwan 'an Ibn 'Amir

### `Asim/` (Asim from Kufa)
- **Rawi 1**: `Shu3bah.pdf` - Shu'bah 'an 'Asim
- **Rawi 2**: `Hafs.pdf` - Hafs 'an 'Asim (Most common)

### `Hamzah/` (Hamzah from Kufa)
- **Rawi 1**: `Khalaf.pdf` - Khalaf 'an Hamzah
- **Rawi 2**: `Khallad.pdf` - Khallad 'an Hamzah

### `Al-Kisai/` (Al-Kisa'i from Kufa)
- **Rawi 1**: `Abu_Al_Harith.pdf` - Abu al-Harith 'an al-Kisa'i
- **Rawi 2**: `Al_Douri.pdf` - Al-Douri 'an al-Kisa'i

### `Abu_Jafar/` (Abu Ja'far from Madinah)
- **Rawi 1**: `Ibn_Wardan.pdf` - Ibn Wardan 'an Abu Ja'far
- **Rawi 2**: `Ibn_Jammaz.pdf` - Ibn Jammaz 'an Abu Ja'far

### `Ya3qub/` (Ya'qub from Basra)
- **Rawi 1**: `Ruways.pdf` - Ruways 'an Ya'qub
- **Rawi 2**: `Rawh.pdf` - Rawh 'an Ya'qub

### `Khalaf/` (Khalaf al-'Ashir)
- **Rawi 1**: `Ishaq.pdf` - Ishaq 'an Khalaf
- **Rawi 2**: `Idris.pdf` - Idris 'an Khalaf

## File Requirements:

1. **Format**: PDF files only
2. **Naming**: Use exact names as shown above (case-sensitive)
3. **Quality**: High resolution for clear text display
4. **Size**: Optimize for mobile viewing while maintaining readability
5. **Pages**: Should be properly ordered and numbered (typically 604 pages)

## Example Structure:
```
assets/pdfs/
├── Asim/
│   ├── Hafs.pdf          ← Most common recitation
│   └── Shu3bah.pdf
├── Nafi3/
│   ├── Qaloon.pdf
│   └── Warsh.pdf         ← Common in North Africa
├── Ibn_Kathir/
│   ├── Al_Buzzi.pdf
│   └── Qunbul.pdf
├── Abu_Amr/
│   ├── Al_Douri.pdf
│   └── Al_Sousi.pdf
├── Ibn_Amir/
│   ├── Hisham.pdf
│   └── Ibn_Dhakwan.pdf
├── Hamzah/
│   ├── Khalaf.pdf
│   └── Khallad.pdf
├── Al-Kisai/
│   ├── Abu_Al_Harith.pdf
│   └── Al_Douri.pdf
├── Abu_Jafar/
│   ├── Ibn_Wardan.pdf
│   └── Ibn_Jammaz.pdf
├── Ya3qub/
│   ├── Ruways.pdf
│   └── Rawh.pdf
└── Khalaf/
    ├── Ishaq.pdf
    └── Idris.pdf
```

## Notes:
- This follows the traditional classification of the 10 Qaris
- Each Qari has exactly 2 Rawis (narrators)
- Hafs 'an 'Asim is the most widely used today
- The app will detect and organize qiraats by Qari and Rawi
- Page mappings may vary between different qiraats
- All 20 recitations (10 Qaris × 2 Rawis) are supported