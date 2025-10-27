class Surah {
  final int number;
  final String name;
  final String nameArabic;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final int startPage;
  final int endPage;

  const Surah({
    required this.number,
    required this.name,
    required this.nameArabic,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.startPage,
    required this.endPage,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'],
      name: json['name'],
      nameArabic: json['nameArabic'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      revelationType: json['revelationType'],
      numberOfAyahs: json['numberOfAyahs'],
      startPage: json['startPage'],
      endPage: json['endPage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'nameArabic': nameArabic,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'revelationType': revelationType,
      'numberOfAyahs': numberOfAyahs,
      'startPage': startPage,
      'endPage': endPage,
    };
  }

  // Helper method to get display name based on language
  String getDisplayName(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return nameArabic;
      case 'fr':
        return _getFrenchName();
      case 'es':
        return _getSpanishName();
      case 'hi':
        return _getHindiName();
      default:
        return englishName;
    }
  }
  
  // Helper method to get French translation
  String _getFrenchName() {
    final frenchNames = {
      1: 'L\'Ouverture', 2: 'La Vache', 3: 'La Famille d\'Imran', 4: 'Les Femmes',
      5: 'La Table Servie', 6: 'Les Bestiaux', 7: 'Les Murailles', 8: 'Le Butin',
      9: 'Le Repentir', 10: 'Jonas', 11: 'Hud', 12: 'Joseph',
      13: 'Le Tonnerre', 14: 'Abraham', 15: 'Al-Hijr', 16: 'Les Abeilles',
      17: 'Le Voyage Nocturne', 18: 'La Caverne', 19: 'Marie', 20: 'Ta-Ha',
      21: 'Les Prophètes', 22: 'Le Pèlerinage', 23: 'Les Croyants', 24: 'La Lumière',
      25: 'Le Discernement', 26: 'Les Poètes', 27: 'Les Fourmis', 28: 'Le Récit',
      29: 'L\'Araignée', 30: 'Les Romains', 31: 'Luqman', 32: 'La Prosternation',
      33: 'Les Coalisés', 34: 'Saba', 35: 'Le Créateur', 36: 'Ya-Sin',
      37: 'Les Rangés', 38: 'Sad', 39: 'Les Groupes', 40: 'Le Pardonneur',
      41: 'Les Versets Détaillés', 42: 'La Consultation', 43: 'L\'Ornement', 44: 'La Fumée',
      45: 'L\'Agenouillée', 46: 'Al-Ahqaf', 47: 'Muhammad', 48: 'La Victoire',
      49: 'Les Appartements', 50: 'Qaf', 51: 'Qui Éparpillent', 52: 'At-Tur',
      53: 'L\'Étoile', 54: 'La Lune', 55: 'Le Tout Miséricordieux', 56: 'L\'Événement',
      57: 'Le Fer', 58: 'La Discussion', 59: 'L\'Exode', 60: 'L\'Éprouvée',
      61: 'Le Rang', 62: 'Le Vendredi', 63: 'Les Hypocrites', 64: 'La Grande Perte',
      65: 'Le Divorce', 66: 'L\'Interdiction', 67: 'La Royauté', 68: 'La Plume',
      69: 'Celle qui Montre', 70: 'Les Voies d\'Ascension', 71: 'Noé', 72: 'Les Djinns',
      73: 'L\'Enveloppé', 74: 'Le Revêtu', 75: 'La Résurrection', 76: 'L\'Homme',
      77: 'Les Envoyés', 78: 'La Nouvelle', 79: 'Les Anges', 80: 'Il S\'est Renfrogné',
      81: 'L\'Obscurcissement', 82: 'La Rupture', 83: 'Les Fraudeurs', 84: 'La Déchirure',
      85: 'Les Constellations', 86: 'L\'Astre Nocturne', 87: 'Le Très-Haut', 88: 'L\'Enveloppante',
      89: 'L\'Aube', 90: 'La Cité', 91: 'Le Soleil', 92: 'La Nuit',
      93: 'Le Jour Montant', 94: 'L\'Ouverture', 95: 'Le Figuier', 96: 'L\'Adhérence',
      97: 'La Destinée', 98: 'La Preuve', 99: 'La Secousse', 100: 'Les Coursiers',
      101: 'Le Fracas', 102: 'La Course', 103: 'Le Temps', 104: 'Les Calomniateurs',
      105: 'L\'Éléphant', 106: 'Quraych', 107: 'L\'Ustensile', 108: 'L\'Abondance',
      109: 'Les Infidèles', 110: 'Les Secours', 111: 'Les Fibres', 112: 'Le Monothéisme',
      113: 'L\'Aube Naissante', 114: 'Les Hommes',
    };
    return frenchNames[number] ?? englishName;
  }
  
  // Helper method to get Spanish translation
  String _getSpanishName() {
    final spanishNames = {
      1: 'La Apertura', 2: 'La Vaca', 3: 'La Familia de Imran', 4: 'Las Mujeres',
      5: 'La Mesa Servida', 6: 'Los Rebaños', 7: 'Los Lugares Elevados', 8: 'El Botín',
      9: 'El Arrepentimiento', 10: 'Jonás', 11: 'Hud', 12: 'José',
      13: 'El Trueno', 14: 'Abraham', 15: 'Al-Hijr', 16: 'Las Abejas',
      17: 'El Viaje Nocturno', 18: 'La Caverna', 19: 'María', 20: 'Ta-Ha',
      21: 'Los Profetas', 22: 'La Peregrinación', 23: 'Los Creyentes', 24: 'La Luz',
      25: 'El Criterio', 26: 'Los Poetas', 27: 'Las Hormigas', 28: 'El Relato',
      29: 'La Araña', 30: 'Los Romanos', 31: 'Luqman', 32: 'La Prosternación',
      33: 'Los Coligados', 34: 'Saba', 35: 'El Creador', 36: 'Ya-Sin',
      37: 'Los Ordenados', 38: 'Sad', 39: 'Los Grupos', 40: 'El Perdonador',
      41: 'Los Detallados', 42: 'La Consulta', 43: 'El Ornamento', 44: 'El Humo',
      45: 'La Arrodillada', 46: 'Al-Ahqaf', 47: 'Muhammad', 48: 'La Victoria',
      49: 'Las Habitaciones', 50: 'Qaf', 51: 'Los que Esparcen', 52: 'At-Tur',
      53: 'La Estrella', 54: 'La Luna', 55: 'El Misericordioso', 56: 'El Evento',
      57: 'El Hierro', 58: 'La Discusión', 59: 'El Exilio', 60: 'La Examinada',
      61: 'La Fila', 62: 'El Viernes', 63: 'Los Hipócritas', 64: 'El Engaño',
      65: 'El Divorcio', 66: 'La Prohibición', 67: 'La Soberanía', 68: 'El Cálamo',
      69: 'La Inevitable', 70: 'Las Vías de Ascenso', 71: 'Noé', 72: 'Los Genios',
      73: 'El Arropado', 74: 'El Envuelto', 75: 'La Resurrección', 76: 'El Hombre',
      77: 'Los Enviados', 78: 'La Noticia', 79: 'Los Ángeles', 80: 'Frunció el Ceño',
      81: 'El Oscurecimiento', 82: 'La Hendidura', 83: 'Los Defraudadores', 84: 'El Resquebrajamiento',
      85: 'Las Constelaciones', 86: 'El Astro Nocturno', 87: 'El Altísimo', 88: 'La Envolvente',
      89: 'El Alba', 90: 'La Ciudad', 91: 'El Sol', 92: 'La Noche',
      93: 'La Mañana', 94: 'La Abertura', 95: 'La Higuera', 96: 'El Coágulo',
      97: 'El Decreto', 98: 'La Evidencia', 99: 'El Terremoto', 100: 'Los Corceles',
      101: 'La Calamidad', 102: 'El Afán', 103: 'El Tiempo', 104: 'El Difamador',
      105: 'El Elefante', 106: 'Quraish', 107: 'La Ayuda', 108: 'La Abundancia',
      109: 'Los Incrédulos', 110: 'El Auxilio', 111: 'Las Fibras', 112: 'La Pureza',
      113: 'El Alba Naciente', 114: 'La Gente',
    };
    return spanishNames[number] ?? englishName;
  }
  
  // Helper method to get Hindi translation
  String _getHindiName() {
    final hindiNames = {
      1: 'शुरुआत', 2: 'गाय', 3: 'इमरान का परिवार', 4: 'महिलाएं',
      5: 'मेज़', 6: 'मवेशी', 7: 'ऊंचाइयां', 8: 'लूट का माल',
      9: 'तौबा', 10: 'युनुस', 11: 'हूद', 12: 'यूसुफ़',
      13: 'गरज', 14: 'इब्राहीम', 15: 'अल-हिज्र', 16: 'मधुमक्खी',
      17: 'रात की यात्रा', 18: 'गुफा', 19: 'मरियम', 20: 'ता-हा',
      21: 'पैगंबर', 22: 'हज', 23: 'विश्वासी', 24: 'प्रकाश',
      25: 'कसौटी', 26: 'कवि', 27: 'चींटियां', 28: 'कहानी',
      29: 'मकड़ी', 30: 'रोमन', 31: 'लुक़मान', 32: 'सजदा',
      33: 'गठबंधन', 34: 'सबा', 35: 'निर्माता', 36: 'या-सीन',
      37: 'पंक्तिबद्ध', 38: 'साद', 39: 'समूह', 40: 'क्षमाशील',
      41: 'विस्तृत', 42: 'परामर्श', 43: 'अलंकरण', 44: 'धुआं',
      45: 'घुटने टेकना', 46: 'अल-अहक़ाफ़', 47: 'मुहम्मद', 48: 'विजय',
      49: 'कमरे', 50: 'क़ाफ़', 51: 'बिखेरने वाले', 52: 'अत-तूर',
      53: 'तारा', 54: 'चांद', 55: 'दयालु', 56: 'घटना',
      57: 'लोहा', 58: 'बहस', 59: 'निर्वासन', 60: 'परीक्षित',
      61: 'पंक्ति', 62: 'शुक्रवार', 63: 'कपटी', 64: 'धोखा',
      65: 'तलाक', 66: 'निषेध', 67: 'संप्रभुता', 68: 'कलम',
      69: 'अवश्यंभावी', 70: 'चढ़ाई के मार्ग', 71: 'नूह', 72: 'जिन्न',
      73: 'लिपटा हुआ', 74: 'ढका हुआ', 75: 'पुनरुत्थान', 76: 'मनुष्य',
      77: 'भेजे गए', 78: 'समाचार', 79: 'फ़रिश्ते', 80: 'वह भौंहें चढ़ाया',
      81: 'अंधकार', 82: 'फटना', 83: 'धोखेबाज', 84: 'विदारण',
      85: 'नक्षत्र', 86: 'रात का तारा', 87: 'सर्वोच्च', 88: 'घेरने वाला',
      89: 'भोर', 90: 'नगर', 91: 'सूर्य', 92: 'रात',
      93: 'सुबह', 94: 'खोलना', 95: 'अंजीर', 96: 'थक्का',
      97: 'भाग्य', 98: 'प्रमाण', 99: 'भूकंप', 100: 'घोड़े',
      101: 'आपदा', 102: 'जमाखोरी', 103: 'समय', 104: 'निंदक',
      105: 'हाथी', 106: 'क़ुरैश', 107: 'छोटी चीज़ें', 108: 'प्रचुरता',
      109: 'अविश्वासी', 110: 'सहायता', 111: 'रेशे', 112: 'शुद्धता',
      113: 'उभरती भोर', 114: 'मानवजाति',
    };
    return hindiNames[number] ?? englishName;
  }

  // Complete list of all 114 Surahs with corrected page numbers (+1 offset applied for cover page)
  static const List<Surah> allSurahs = [
    Surah(number: 1, name: 'Al-Fatiha', nameArabic: 'الفاتحة', englishName: 'The Opening', englishNameTranslation: 'The Opening', revelationType: 'Meccan', numberOfAyahs: 7, startPage: 2, endPage: 2),
    Surah(number: 2, name: 'Al-Baqarah', nameArabic: 'البقرة', englishName: 'The Cow', englishNameTranslation: 'The Cow', revelationType: 'Medinan', numberOfAyahs: 286, startPage: 3, endPage: 50),
    Surah(number: 3, name: 'Ali \'Imran', nameArabic: 'آل عمران', englishName: 'Family of Imran', englishNameTranslation: 'The Family of Imran', revelationType: 'Medinan', numberOfAyahs: 200, startPage: 51, endPage: 76),
    Surah(number: 4, name: 'An-Nisa', nameArabic: 'النساء', englishName: 'The Women', englishNameTranslation: 'The Women', revelationType: 'Medinan', numberOfAyahs: 176, startPage: 78, endPage: 106),
    Surah(number: 5, name: 'Al-Ma\'idah', nameArabic: 'المائدة', englishName: 'The Table Spread', englishNameTranslation: 'The Table', revelationType: 'Medinan', numberOfAyahs: 120, startPage: 107, endPage: 128),
    Surah(number: 6, name: 'Al-An\'am', nameArabic: 'الأنعام', englishName: 'The Cattle', englishNameTranslation: 'The Cattle', revelationType: 'Meccan', numberOfAyahs: 165, startPage: 129, endPage: 150),
    Surah(number: 7, name: 'Al-A\'raf', nameArabic: 'الأعراف', englishName: 'The Heights', englishNameTranslation: 'The Heights', revelationType: 'Meccan', numberOfAyahs: 206, startPage: 152, endPage: 176),
    Surah(number: 8, name: 'Al-Anfal', nameArabic: 'الأنفال', englishName: 'The Spoils of War', englishNameTranslation: 'The Spoils of War', revelationType: 'Medinan', numberOfAyahs: 75, startPage: 178, endPage: 186),
    Surah(number: 9, name: 'At-Tawbah', nameArabic: 'التوبة', englishName: 'The Repentance', englishNameTranslation: 'The Repentance', revelationType: 'Medinan', numberOfAyahs: 129, startPage: 188, endPage: 207),
    Surah(number: 10, name: 'Yunus', nameArabic: 'يونس', englishName: 'Jonah', englishNameTranslation: 'Jonah', revelationType: 'Meccan', numberOfAyahs: 109, startPage: 209, endPage: 220),
    Surah(number: 11, name: 'Hud', nameArabic: 'هود', englishName: 'Hud', englishNameTranslation: 'Hud', revelationType: 'Meccan', numberOfAyahs: 123, startPage: 222, endPage: 234),
    Surah(number: 12, name: 'Yusuf', nameArabic: 'يوسف', englishName: 'Joseph', englishNameTranslation: 'Joseph', revelationType: 'Meccan', numberOfAyahs: 111, startPage: 236, endPage: 248),
    Surah(number: 13, name: 'Ar-Ra\'d', nameArabic: 'الرعد', englishName: 'The Thunder', englishNameTranslation: 'The Thunder', revelationType: 'Medinan', numberOfAyahs: 43, startPage: 250, endPage: 254),
    Surah(number: 14, name: 'Ibrahim', nameArabic: 'إبراهيم', englishName: 'Abraham', englishNameTranslation: 'Abraham', revelationType: 'Meccan', numberOfAyahs: 52, startPage: 256, endPage: 261),
    Surah(number: 15, name: 'Al-Hijr', nameArabic: 'الحجر', englishName: 'The Rocky Tract', englishNameTranslation: 'The Rocky Tract', revelationType: 'Meccan', numberOfAyahs: 99, startPage: 263, endPage: 266),
    Surah(number: 16, name: 'An-Nahl', nameArabic: 'النحل', englishName: 'The Bee', englishNameTranslation: 'The Bee', revelationType: 'Meccan', numberOfAyahs: 128, startPage: 268, endPage: 281),
    Surah(number: 17, name: 'Al-Isra', nameArabic: 'الإسراء', englishName: 'The Night Journey', englishNameTranslation: 'The Night Journey', revelationType: 'Meccan', numberOfAyahs: 111, startPage: 283, endPage: 292),
    Surah(number: 18, name: 'Al-Kahf', nameArabic: 'الكهف', englishName: 'The Cave', englishNameTranslation: 'The Cave', revelationType: 'Meccan', numberOfAyahs: 110, startPage: 294, endPage: 304),
    Surah(number: 19, name: 'Maryam', nameArabic: 'مريم', englishName: 'Mary', englishNameTranslation: 'Mary', revelationType: 'Meccan', numberOfAyahs: 98, startPage: 306, endPage: 311),
    Surah(number: 20, name: 'Ta-Ha', nameArabic: 'طه', englishName: 'Ta-Ha', englishNameTranslation: 'Ta-Ha', revelationType: 'Meccan', numberOfAyahs: 135, startPage: 313, endPage: 321),
    Surah(number: 21, name: 'Al-Anbiya', nameArabic: 'الأنبياء', englishName: 'The Prophets', englishNameTranslation: 'The Prophets', revelationType: 'Meccan', numberOfAyahs: 112, startPage: 323, endPage: 331),
    Surah(number: 22, name: 'Al-Hajj', nameArabic: 'الحج', englishName: 'The Pilgrimage', englishNameTranslation: 'The Pilgrimage', revelationType: 'Medinan', numberOfAyahs: 78, startPage: 333, endPage: 341),
    Surah(number: 23, name: 'Al-Mu\'minun', nameArabic: 'المؤمنون', englishName: 'The Believers', englishNameTranslation: 'The Believers', revelationType: 'Meccan', numberOfAyahs: 118, startPage: 343, endPage: 349),
    Surah(number: 24, name: 'An-Nur', nameArabic: 'النور', englishName: 'The Light', englishNameTranslation: 'The Light', revelationType: 'Medinan', numberOfAyahs: 64, startPage: 351, endPage: 358),
    Surah(number: 25, name: 'Al-Furqan', nameArabic: 'الفرقان', englishName: 'The Criterion', englishNameTranslation: 'The Criterion', revelationType: 'Meccan', numberOfAyahs: 77, startPage: 360, endPage: 366),
    Surah(number: 26, name: 'Ash-Shu\'ara', nameArabic: 'الشعراء', englishName: 'The Poets', englishNameTranslation: 'The Poets', revelationType: 'Meccan', numberOfAyahs: 227, startPage: 368, endPage: 376),
    Surah(number: 27, name: 'An-Naml', nameArabic: 'النمل', englishName: 'The Ant', englishNameTranslation: 'The Ant', revelationType: 'Meccan', numberOfAyahs: 93, startPage: 378, endPage: 384),
    Surah(number: 28, name: 'Al-Qasas', nameArabic: 'القصص', englishName: 'The Stories', englishNameTranslation: 'The Stories', revelationType: 'Meccan', numberOfAyahs: 88, startPage: 386, endPage: 395),
    Surah(number: 29, name: 'Al-\'Ankabut', nameArabic: 'العنكبوت', englishName: 'The Spider', englishNameTranslation: 'The Spider', revelationType: 'Meccan', numberOfAyahs: 69, startPage: 397, endPage: 403),
    Surah(number: 30, name: 'Ar-Rum', nameArabic: 'الروم', englishName: 'The Romans', englishNameTranslation: 'The Romans', revelationType: 'Meccan', numberOfAyahs: 60, startPage: 405, endPage: 410),
    Surah(number: 31, name: 'Luqman', nameArabic: 'لقمان', englishName: 'Luqman', englishNameTranslation: 'Luqman', revelationType: 'Meccan', numberOfAyahs: 34, startPage: 412, endPage: 414),
    Surah(number: 32, name: 'As-Sajdah', nameArabic: 'السجدة', englishName: 'The Prostration', englishNameTranslation: 'The Prostration', revelationType: 'Meccan', numberOfAyahs: 30, startPage: 416, endPage: 417),
    Surah(number: 33, name: 'Al-Ahzab', nameArabic: 'الأحزاب', englishName: 'The Clans', englishNameTranslation: 'The Clans', revelationType: 'Medinan', numberOfAyahs: 73, startPage: 419, endPage: 427),
    Surah(number: 34, name: 'Saba', nameArabic: 'سبأ', englishName: 'Sheba', englishNameTranslation: 'Sheba', revelationType: 'Meccan', numberOfAyahs: 54, startPage: 429, endPage: 433),
    Surah(number: 35, name: 'Fatir', nameArabic: 'فاطر', englishName: 'Originator', englishNameTranslation: 'The Originator', revelationType: 'Meccan', numberOfAyahs: 45, startPage: 435, endPage: 439),
    Surah(number: 36, name: 'Ya-Sin', nameArabic: 'يس', englishName: 'Ya-Sin', englishNameTranslation: 'Ya-Sin', revelationType: 'Meccan', numberOfAyahs: 83, startPage: 441, endPage: 445),
    Surah(number: 37, name: 'As-Saffat', nameArabic: 'الصافات', englishName: 'Those who set the Ranks', englishNameTranslation: 'Those Ranged in Ranks', revelationType: 'Meccan', numberOfAyahs: 182, startPage: 447, endPage: 452),
    Surah(number: 38, name: 'Sad', nameArabic: 'ص', englishName: 'The Letter Sad', englishNameTranslation: 'The Letter Sad', revelationType: 'Meccan', numberOfAyahs: 88, startPage: 454, endPage: 457),
    Surah(number: 39, name: 'Az-Zumar', nameArabic: 'الزمر', englishName: 'The Troops', englishNameTranslation: 'The Groups', revelationType: 'Meccan', numberOfAyahs: 75, startPage: 459, endPage: 466),
    Surah(number: 40, name: 'Ghafir', nameArabic: 'غافر', englishName: 'The Forgiver', englishNameTranslation: 'The Forgiver', revelationType: 'Meccan', numberOfAyahs: 85, startPage: 468, endPage: 476),
    Surah(number: 41, name: 'Fussilat', nameArabic: 'فصلت', englishName: 'Explained in Detail', englishNameTranslation: 'Explained in Detail', revelationType: 'Meccan', numberOfAyahs: 54, startPage: 478, endPage: 482),
    Surah(number: 42, name: 'Ash-Shura', nameArabic: 'الشورى', englishName: 'The Consultation', englishNameTranslation: 'The Consultation', revelationType: 'Meccan', numberOfAyahs: 53, startPage: 484, endPage: 488),
    Surah(number: 43, name: 'Az-Zukhruf', nameArabic: 'الزخرف', englishName: 'The Ornaments of Gold', englishNameTranslation: 'The Gold Adornment', revelationType: 'Meccan', numberOfAyahs: 89, startPage: 490, endPage: 495),
    Surah(number: 44, name: 'Ad-Dukhan', nameArabic: 'الدخان', englishName: 'The Smoke', englishNameTranslation: 'The Smoke', revelationType: 'Meccan', numberOfAyahs: 59, startPage: 497, endPage: 498),
    Surah(number: 45, name: 'Al-Jathiyah', nameArabic: 'الجاثية', englishName: 'The Crouching', englishNameTranslation: 'The Kneeling', revelationType: 'Meccan', numberOfAyahs: 37, startPage: 500, endPage: 501),
    Surah(number: 46, name: 'Al-Ahqaf', nameArabic: 'الأحقاف', englishName: 'The Wind-Curved Sandhills', englishNameTranslation: 'The Curved Sand-Hills', revelationType: 'Meccan', numberOfAyahs: 35, startPage: 503, endPage: 506),
    Surah(number: 47, name: 'Muhammad', nameArabic: 'محمد', englishName: 'Muhammad', englishNameTranslation: 'Muhammad', revelationType: 'Medinan', numberOfAyahs: 38, startPage: 508, endPage: 510),
    Surah(number: 48, name: 'Al-Fath', nameArabic: 'الفتح', englishName: 'The Victory', englishNameTranslation: 'The Victory', revelationType: 'Medinan', numberOfAyahs: 29, startPage: 512, endPage: 514),
    Surah(number: 49, name: 'Al-Hujurat', nameArabic: 'الحجرات', englishName: 'The Rooms', englishNameTranslation: 'The Dwellings', revelationType: 'Medinan', numberOfAyahs: 18, startPage: 516, endPage: 517),
    Surah(number: 50, name: 'Qaf', nameArabic: 'ق', englishName: 'The Letter Qaf', englishNameTranslation: 'The Letter Qaf', revelationType: 'Meccan', numberOfAyahs: 45, startPage: 519, endPage: 520),
    Surah(number: 51, name: 'Adh-Dhariyat', nameArabic: 'الذاريات', englishName: 'The Winnowing Winds', englishNameTranslation: 'The Wind that Scatter', revelationType: 'Meccan', numberOfAyahs: 60, startPage: 521, endPage: 522),
    Surah(number: 52, name: 'At-Tur', nameArabic: 'الطور', englishName: 'The Mount', englishNameTranslation: 'The Mount', revelationType: 'Meccan', numberOfAyahs: 49, startPage: 524, endPage: 525),
    Surah(number: 53, name: 'An-Najm', nameArabic: 'النجم', englishName: 'The Star', englishNameTranslation: 'The Star', revelationType: 'Meccan', numberOfAyahs: 62, startPage: 527, endPage: 527),
    Surah(number: 54, name: 'Al-Qamar', nameArabic: 'القمر', englishName: 'The Moon', englishNameTranslation: 'The Moon', revelationType: 'Meccan', numberOfAyahs: 55, startPage: 529, endPage: 530),
    Surah(number: 55, name: 'Ar-Rahman', nameArabic: 'الرحمن', englishName: 'The Beneficent', englishNameTranslation: 'The Most Gracious', revelationType: 'Meccan', numberOfAyahs: 78, startPage: 532, endPage: 533),
    Surah(number: 56, name: 'Al-Waqi\'ah', nameArabic: 'الواقعة', englishName: 'The Inevitable', englishNameTranslation: 'The Event', revelationType: 'Meccan', numberOfAyahs: 96, startPage: 535, endPage: 536),
    Surah(number: 57, name: 'Al-Hadid', nameArabic: 'الحديد', englishName: 'The Iron', englishNameTranslation: 'The Iron', revelationType: 'Medinan', numberOfAyahs: 29, startPage: 538, endPage: 541),
    Surah(number: 58, name: 'Al-Mujadila', nameArabic: 'المجادلة', englishName: 'The Pleading Woman', englishNameTranslation: 'She That Disputes', revelationType: 'Medinan', numberOfAyahs: 22, startPage: 543, endPage: 544),
    Surah(number: 59, name: 'Al-Hashr', nameArabic: 'الحشر', englishName: 'The Exile', englishNameTranslation: 'The Gathering', revelationType: 'Medinan', numberOfAyahs: 24, startPage: 546, endPage: 548),
    Surah(number: 60, name: 'Al-Mumtahanah', nameArabic: 'الممتحنة', englishName: 'She that is to be examined', englishNameTranslation: 'The Examined One', revelationType: 'Medinan', numberOfAyahs: 13, startPage: 550, endPage: 550),
    Surah(number: 61, name: 'As-Saff', nameArabic: 'الصف', englishName: 'The Ranks', englishNameTranslation: 'The Row', revelationType: 'Medinan', numberOfAyahs: 14, startPage: 552, endPage: 552),
    Surah(number: 62, name: 'Al-Jumu\'ah', nameArabic: 'الجمعة', englishName: 'The Congregation', englishNameTranslation: 'Friday', revelationType: 'Medinan', numberOfAyahs: 11, startPage: 554, endPage: 554),
    Surah(number: 63, name: 'Al-Munafiqun', nameArabic: 'المنافقون', englishName: 'The Hypocrites', englishNameTranslation: 'The Hypocrites', revelationType: 'Medinan', numberOfAyahs: 11, startPage: 555, endPage: 555),
    Surah(number: 64, name: 'At-Taghabun', nameArabic: 'التغابن', englishName: 'The Mutual Disillusion', englishNameTranslation: 'The Mutual Loss and Gain', revelationType: 'Medinan', numberOfAyahs: 18, startPage: 557, endPage: 557),
    Surah(number: 65, name: 'At-Talaq', nameArabic: 'الطلاق', englishName: 'The Divorce', englishNameTranslation: 'The Divorce', revelationType: 'Medinan', numberOfAyahs: 12, startPage: 559, endPage: 559),
    Surah(number: 66, name: 'At-Tahrim', nameArabic: 'التحريم', englishName: 'The Prohibition', englishNameTranslation: 'The Prohibition', revelationType: 'Medinan', numberOfAyahs: 12, startPage: 561, endPage: 561),
    Surah(number: 67, name: 'Al-Mulk', nameArabic: 'الملك', englishName: 'The Sovereignty', englishNameTranslation: 'The Kingdom', revelationType: 'Meccan', numberOfAyahs: 30, startPage: 563, endPage: 563),
    Surah(number: 68, name: 'Al-Qalam', nameArabic: 'القلم', englishName: 'The Pen', englishNameTranslation: 'The Pen', revelationType: 'Meccan', numberOfAyahs: 52, startPage: 565, endPage: 565),
    Surah(number: 69, name: 'Al-Haqqah', nameArabic: 'الحاقة', englishName: 'The Reality', englishNameTranslation: 'The Inevitable Reality', revelationType: 'Meccan', numberOfAyahs: 52, startPage: 567, endPage: 567),
    Surah(number: 70, name: 'Al-Ma\'arij', nameArabic: 'المعارج', englishName: 'The Ascending Stairways', englishNameTranslation: 'The Ways of Ascent', revelationType: 'Meccan', numberOfAyahs: 44, startPage: 569, endPage: 569),
    Surah(number: 71, name: 'Nuh', nameArabic: 'نوح', englishName: 'Noah', englishNameTranslation: 'Noah', revelationType: 'Meccan', numberOfAyahs: 28, startPage: 571, endPage: 571),
    Surah(number: 72, name: 'Al-Jinn', nameArabic: 'الجن', englishName: 'The Jinn', englishNameTranslation: 'The Jinn', revelationType: 'Meccan', numberOfAyahs: 28, startPage: 573, endPage: 573),
    Surah(number: 73, name: 'Al-Muzzammil', nameArabic: 'المزمل', englishName: 'The Enshrouded One', englishNameTranslation: 'The Wrapped in Garments', revelationType: 'Meccan', numberOfAyahs: 20, startPage: 575, endPage: 575),
    Surah(number: 74, name: 'Al-Muddaththir', nameArabic: 'المدثر', englishName: 'The Cloaked One', englishNameTranslation: 'The One Covering Himself', revelationType: 'Meccan', numberOfAyahs: 56, startPage: 576, endPage: 576),
    Surah(number: 75, name: 'Al-Qiyamah', nameArabic: 'القيامة', englishName: 'The Resurrection', englishNameTranslation: 'The Day of Resurrection', revelationType: 'Meccan', numberOfAyahs: 40, startPage: 578, endPage: 578),
    Surah(number: 76, name: 'Al-Insan', nameArabic: 'الإنسان', englishName: 'The Man', englishNameTranslation: 'Man', revelationType: 'Medinan', numberOfAyahs: 31, startPage: 579, endPage: 579),
    Surah(number: 77, name: 'Al-Mursalat', nameArabic: 'المرسلات', englishName: 'The Emissaries', englishNameTranslation: 'Those Sent Forth', revelationType: 'Meccan', numberOfAyahs: 50, startPage: 581, endPage: 581),
    Surah(number: 78, name: 'An-Naba', nameArabic: 'النبأ', englishName: 'The Tidings', englishNameTranslation: 'The Great News', revelationType: 'Meccan', numberOfAyahs: 40, startPage: 583, endPage: 583),
    Surah(number: 79, name: 'An-Nazi\'at', nameArabic: 'النازعات', englishName: 'Those who drag forth', englishNameTranslation: 'Those Who Pull Out', revelationType: 'Meccan', numberOfAyahs: 46, startPage: 584, endPage: 584),
    Surah(number: 80, name: '\'Abasa', nameArabic: 'عبس', englishName: 'He Frowned', englishNameTranslation: 'He Frowned', revelationType: 'Meccan', numberOfAyahs: 42, startPage: 586, endPage: 586),
    Surah(number: 81, name: 'At-Takwir', nameArabic: 'التكوير', englishName: 'The Overthrowing', englishNameTranslation: 'The Folding Up', revelationType: 'Meccan', numberOfAyahs: 29, startPage: 587, endPage: 587),
    Surah(number: 82, name: 'Al-Infitar', nameArabic: 'الإنفطار', englishName: 'The Cleaving', englishNameTranslation: 'The Cleaving Asunder', revelationType: 'Meccan', numberOfAyahs: 19, startPage: 588, endPage: 588),
    Surah(number: 83, name: 'Al-Mutaffifin', nameArabic: 'المطففين', englishName: 'The Defrauding', englishNameTranslation: 'Those Who Give Short Measure', revelationType: 'Meccan', numberOfAyahs: 36, startPage: 588, endPage: 589),
    Surah(number: 84, name: 'Al-Inshiqaq', nameArabic: 'الإنشقاق', englishName: 'The Sundering', englishNameTranslation: 'The Splitting Asunder', revelationType: 'Meccan', numberOfAyahs: 25, startPage: 590, endPage: 590),
    Surah(number: 85, name: 'Al-Buruj', nameArabic: 'البروج', englishName: 'The Mansions of the Stars', englishNameTranslation: 'The Stars', revelationType: 'Meccan', numberOfAyahs: 22, startPage: 591, endPage: 591),
    Surah(number: 86, name: 'At-Tariq', nameArabic: 'الطارق', englishName: 'The Morning Star', englishNameTranslation: 'The Night-Comer', revelationType: 'Meccan', numberOfAyahs: 17, startPage: 592, endPage: 592),
    Surah(number: 87, name: 'Al-A\'la', nameArabic: 'الأعلى', englishName: 'The Most High', englishNameTranslation: 'The Most High', revelationType: 'Meccan', numberOfAyahs: 19, startPage: 592, endPage: 592),
    Surah(number: 88, name: 'Al-Ghashiyah', nameArabic: 'الغاشية', englishName: 'The Overwhelming', englishNameTranslation: 'The Overwhelming Event', revelationType: 'Meccan', numberOfAyahs: 26, startPage: 593, endPage: 593),
    Surah(number: 89, name: 'Al-Fajr', nameArabic: 'الفجر', englishName: 'The Dawn', englishNameTranslation: 'The Break of Day', revelationType: 'Meccan', numberOfAyahs: 30, startPage: 594, endPage: 594),
    Surah(number: 90, name: 'Al-Balad', nameArabic: 'البلد', englishName: 'The City', englishNameTranslation: 'The City', revelationType: 'Meccan', numberOfAyahs: 20, startPage: 595, endPage: 595),
    Surah(number: 91, name: 'Ash-Shams', nameArabic: 'الشمس', englishName: 'The Sun', englishNameTranslation: 'The Sun', revelationType: 'Meccan', numberOfAyahs: 15, startPage: 596, endPage: 596),
    Surah(number: 92, name: 'Al-Layl', nameArabic: 'الليل', englishName: 'The Night', englishNameTranslation: 'The Night', revelationType: 'Meccan', numberOfAyahs: 21, startPage: 596, endPage: 596),
    Surah(number: 93, name: 'Ad-Dhuha', nameArabic: 'الضحى', englishName: 'The Morning Hours', englishNameTranslation: 'The Glorious Morning Light', revelationType: 'Meccan', numberOfAyahs: 11, startPage: 597, endPage: 597),
    Surah(number: 94, name: 'Ash-Sharh', nameArabic: 'الشرح', englishName: 'The Relief', englishNameTranslation: 'The Expansion of Breast', revelationType: 'Meccan', numberOfAyahs: 8, startPage: 597, endPage: 597),
    Surah(number: 95, name: 'At-Tin', nameArabic: 'التين', englishName: 'The Fig', englishNameTranslation: 'The Fig', revelationType: 'Meccan', numberOfAyahs: 8, startPage: 598, endPage: 598),
    Surah(number: 96, name: 'Al-\'Alaq', nameArabic: 'العلق', englishName: 'The Clot', englishNameTranslation: 'The Clinging Clot', revelationType: 'Meccan', numberOfAyahs: 19, startPage: 598, endPage: 598),
    Surah(number: 97, name: 'Al-Qadr', nameArabic: 'القدر', englishName: 'The Power', englishNameTranslation: 'The Night of Decree', revelationType: 'Meccan', numberOfAyahs: 5, startPage: 599, endPage: 599),
    Surah(number: 98, name: 'Al-Bayyinah', nameArabic: 'البينة', englishName: 'The Clear Proof', englishNameTranslation: 'The Clear Evidence', revelationType: 'Medinan', numberOfAyahs: 8, startPage: 599, endPage: 599),
    Surah(number: 99, name: 'Az-Zalzalah', nameArabic: 'الزلزلة', englishName: 'The Earthquake', englishNameTranslation: 'The Earthquake', revelationType: 'Medinan', numberOfAyahs: 8, startPage: 600, endPage: 600),
    Surah(number: 100, name: 'Al-\'Adiyat', nameArabic: 'العاديات', englishName: 'The Courser', englishNameTranslation: 'Those That Run', revelationType: 'Meccan', numberOfAyahs: 11, startPage: 600, endPage: 600),
    Surah(number: 101, name: 'Al-Qari\'ah', nameArabic: 'القارعة', englishName: 'The Calamity', englishNameTranslation: 'The Striking Hour', revelationType: 'Meccan', numberOfAyahs: 11, startPage: 601, endPage: 601),
    Surah(number: 102, name: 'At-Takathur', nameArabic: 'التكاثر', englishName: 'The Rivalry in world increase', englishNameTranslation: 'The Piling Up', revelationType: 'Meccan', numberOfAyahs: 8, startPage: 601, endPage: 601),
    Surah(number: 103, name: 'Al-\'Asr', nameArabic: 'العصر', englishName: 'The Declining Day', englishNameTranslation: 'The Time', revelationType: 'Meccan', numberOfAyahs: 3, startPage: 602, endPage: 602),
    Surah(number: 104, name: 'Al-Humazah', nameArabic: 'الهمزة', englishName: 'The Traducer', englishNameTranslation: 'The Slanderer', revelationType: 'Meccan', numberOfAyahs: 9, startPage: 602, endPage: 602),
    Surah(number: 105, name: 'Al-Fil', nameArabic: 'الفيل', englishName: 'The Elephant', englishNameTranslation: 'The Elephant', revelationType: 'Meccan', numberOfAyahs: 5, startPage: 602, endPage: 602),
    Surah(number: 106, name: 'Quraysh', nameArabic: 'قريش', englishName: 'Quraysh', englishNameTranslation: 'The Quraish', revelationType: 'Meccan', numberOfAyahs: 4, startPage: 603, endPage: 603),
    Surah(number: 107, name: 'Al-Ma\'un', nameArabic: 'الماعون', englishName: 'The Small kindnesses', englishNameTranslation: 'The Small Kindnesses', revelationType: 'Meccan', numberOfAyahs: 7, startPage: 603, endPage: 603),
    Surah(number: 108, name: 'Al-Kawthar', nameArabic: 'الكوثر', englishName: 'The Abundance', englishNameTranslation: 'Abundance', revelationType: 'Meccan', numberOfAyahs: 3, startPage: 603, endPage: 603),
    Surah(number: 109, name: 'Al-Kafirun', nameArabic: 'الكافرون', englishName: 'The Disbelievers', englishNameTranslation: 'Those Who Deny the Truth', revelationType: 'Meccan', numberOfAyahs: 6, startPage: 604, endPage: 604),
    Surah(number: 110, name: 'An-Nasr', nameArabic: 'النصر', englishName: 'The Divine Support', englishNameTranslation: 'The Help', revelationType: 'Medinan', numberOfAyahs: 3, startPage: 604, endPage: 604),
    Surah(number: 111, name: 'Al-Masad', nameArabic: 'المسد', englishName: 'The Palm Fibre', englishNameTranslation: 'The Palm Fiber', revelationType: 'Meccan', numberOfAyahs: 5, startPage: 604, endPage: 604),
    Surah(number: 112, name: 'Al-Ikhlas', nameArabic: 'الإخلاص', englishName: 'The Sincerity', englishNameTranslation: 'The Purity of Faith', revelationType: 'Meccan', numberOfAyahs: 4, startPage: 605, endPage: 605),
    Surah(number: 113, name: 'Al-Falaq', nameArabic: 'الفلق', englishName: 'The Daybreak', englishNameTranslation: 'The Daybreak', revelationType: 'Meccan', numberOfAyahs: 5, startPage: 605, endPage: 605),
    Surah(number: 114, name: 'An-Nas', nameArabic: 'الناس', englishName: 'Mankind', englishNameTranslation: 'Mankind', revelationType: 'Meccan', numberOfAyahs: 6, startPage: 605, endPage: 605),
  ];
}