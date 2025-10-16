# Mushaf Noor - Qiraats Feature Guide

## 📚 What Are Qiraats?

Qiraats are the different authentic methods of reciting the Quran, each transmitted through a chain of narration from the Prophet Muhammad (peace be upon him). This app supports all **20 canonical qiraats** (10 Qaris × 2 Rawis each).

## 🌟 Available Qiraats

### The 10 Qaris and Their Rawis

1. **Nafi' (Madinah)**
   - قالون عن نافع (Qalun 'an Nafi')
   - ورش عن نافع (Warsh 'an Nafi')

2. **Ibn Kathir (Makkah)**
   - البزي عن ابن كثير (Al-Bazzi 'an Ibn Kathir)
   - قنبل عن ابن كثير (Qunbul 'an Ibn Kathir)

3. **Abu 'Amr (Basra)**
   - الدوري عن أبي عمرو (Ad-Duri 'an Abu 'Amr)
   - السوسي عن أبي عمرو (As-Sussi 'an Abu 'Amr)

4. **Ibn 'Amir (Damascus)**
   - هشام عن ابن عامر (Hisham 'an Ibn 'Amir)
   - ابن ذكوان عن ابن عامر (Ibn Dhakwan 'an Ibn 'Amir)

5. **'Asim (Kufa)**
   - شعبة عن عاصم (Shu'ba 'an 'Asim)
   - حفص عن عاصم (Hafs 'an 'Asim) - **Most widely used today** ⭐

6. **Hamzah (Kufa)**
   - خلاد عن حمزة (Khalaad 'an Hamzah)
   - خلف عن حمزة (Khalaf 'an Hamzah)

7. **Al-Kisa'i (Kufa)**
   - أبو الحارث عن الكسائي (Abu al-Harith 'an al-Kisa'i)
   - الدوري عن الكسائي (Ad-Duri 'an al-Kisa'i)

8. **Abu Ja'far (Madinah)**
   - ابن وردان عن أبي جعفر (Ibn Wardan 'an Abu Ja'far)
   - ابن جماز عن أبي جعفر (Ibn Jammaz 'an Abu Ja'far)

9. **Ya'qub (Basra)**
   - رويس عن يعقوب (Ruways 'an Ya'qub)
   - روح عن يعقوب (Rawh 'an Ya'qub)

10. **Khalaf al-'Ashir**
    - إسحاق عن خلف (Ishaq 'an Khalaf)
    - إدريس عن خلف (Idris 'an Khalaf)

## 💡 How to Use Qiraats in the App

### Viewing Available Qiraats

1. **From Home Screen**: Tap the qiraat indicator in the top-right corner
2. **From Reading Screen**: Tap the book icon in the bottom controls

### Switching Between Qiraats

1. Open the qiraat selector
2. Browse the list of 20 qiraats
3. Tap on any qiraat to select it
4. If not downloaded, you'll see a download prompt
5. After downloading, the qiraat will load automatically

### Understanding Qiraat Status Icons

- ✓ **Check mark**: Currently selected qiraat
- ✓ **Green check**: Downloaded and available
- ⬇ **Download icon**: Not yet downloaded, tap to download

## 🌐 How Qiraats Are Delivered

### Hafs 'an 'Asim (Default)
- **Bundled with app** - Always available offline
- No internet required
- Fastest loading

### Other 19 Qiraats
- **Streamed from GitHub Pages** - `https://zuper4.github.io/mushaf-qiraats`
- Requires internet for first viewing
- Pages are cached locally for faster subsequent access
- No permanent storage required

## 📖 Reading with Different Qiraats

### Page Structure
- All qiraats follow the standard Mushaf page layout (606 pages)
- Same surah and ayah divisions
- Only the recitation method differs

### Visual Differences
- Each qiraat has a unique color identifier
- Page images show the text according to that specific qiraat
- Differences include vowel marks, letter forms, and word divisions

## 🔍 Comparing Qiraats

To compare different qiraats:

1. Read a page with one qiraat
2. Switch to another qiraat
3. Notice the differences in:
   - Vowel marks (harakat)
   - Letter shapes
   - Word divisions
   - Pauses (waqf marks)

## 💾 Storage and Offline Usage

### Storage Impact
- App with Hafs only: ~100MB
- Each additional qiraat (cached): ~50-100MB temporary cache
- Cache is cleared automatically by system when space is needed

### Offline Usage
- Hafs qiraat: **Full offline support** ✓
- Other qiraats: **Partial offline** (previously viewed pages are cached)

### Tips for Offline Use
1. Pre-load qiraats by viewing pages while connected
2. Previously viewed pages remain in cache
3. Clear app cache in settings if you need to free space

## ❓ Frequently Asked Questions

### Q: Why is Hafs bundled but others aren't?
A: Hafs 'an 'Asim is the most widely used qiraat globally (90%+ of Muslims). Bundling it ensures the app works perfectly offline for most users while keeping the app size reasonable.

### Q: How much data does streaming a qiraat use?
A: Each page is approximately 100-200KB. Viewing all 606 pages of one qiraat uses approximately 60-120MB of data.

### Q: Can I download a qiraat for permanent offline use?
A: Currently, qiraats (except Hafs) are streamed and cached. A future update may add permanent offline downloads.

### Q: Do I need to re-download after updating the app?
A: No! Cache persists across app updates. Only a full app reinstall clears the cache.

### Q: Why do some pages take longer to load?
A: First-time loading of a page requires internet. Subsequent views load from cache instantly.

## 🛠️ Technical Information

### Image Format
- Format: JPEG
- Resolution: High-quality for clear reading
- Naming: `page_001.jpg` to `page_606.jpg`

### Network Requirements
- Stable internet connection recommended
- 3G/4G/5G or WiFi
- No specific bandwidth requirement (images load progressively)

### Caching Strategy
- Uses `CachedNetworkImage` package
- Automatic cache management
- LRU (Least Recently Used) cache policy
- Cache survives app restarts

## 📚 Learning Resources

To learn more about Qiraats:
- Study with qualified teachers
- Reference books on the science of Qiraats ('Ilm al-Qira'at)
- Audio recordings of different Qaris
- Scholarly articles on variations between Qiraats

## 🙏 Credits

Qiraat images provided by the Mushaf Qiraats project:
- Repository: https://github.com/Zuper4/mushaf-qiraats
- Images courtesy of authentic Islamic sources
- Verified by scholars of Quranic sciences

---

**May Allah accept this effort and make it beneficial for all Muslims seeking to learn and appreciate the beautiful diversity of Quranic recitation methods.**

*"Indeed, We have sent it down as an Arabic Qur'an that you might understand."* - Quran 12:2
