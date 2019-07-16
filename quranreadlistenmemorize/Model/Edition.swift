//
//  Edition.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class Edition: Encodable, Decodable {
    var identifier: String!
    var language: String!
    var name: String!
    var englishName: String!
    var format: String!
    var type: String!
}

class Surah: Encodable, Decodable {
    var number: Int!
    var name: String!
    var englishName: String!
    var englishNameTranslation: String!
    var revelationType: String!
    var ayahs: Array<Ayah>!
}

class Ayah: Encodable, Decodable {
    var number: Int!
    var text: String!
    var numberInSurah: Int!
    var juz: Int!
    var manzil: Int!
    var page: Int!
    var ruku: Int!
    var hizbQuarter: Int!
}

class ResponseEdition: Encodable, Decodable {
    var code: Int!
    var status: String!
    var data: Array<Edition>!
}

class ResponseQuran: Encodable, Decodable {
    var code: Int!
    var status: String!
    var data: Quran!
}

class Quran: Encodable, Decodable {
    var surahs: Array<Surah>!
    var edition: Edition!
}


class PrayerCountry: Encodable, Decodable {
    var name: String!
    var nameEnglish: String!
    var id: String!
    
    init(name: String, nameEnglish: String, id: String) {
        self.name = name
        self.nameEnglish = nameEnglish
        self.id = id
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "UlkeAdi"
        case nameEnglish = "UlkeAdiEn"
        case id = "UlkeID"
    }
}

class PrayerCity: Decodable {
    var name: String!
    var nameEnglish: String!
    var id: String!
    
    init(name: String, nameEnglish: String, id: String) {
        self.name = name
        self.nameEnglish = nameEnglish
        self.id = id
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "SehirAdi"
        case nameEnglish = "SehirAdiEn"
        case id = "SehirID"
    }
}

class PrayerCounty: Decodable {
    var name: String!
    var nameEnglish: String!
    var id: String!
    
    init(name: String, nameEnglish: String, id: String) {
        self.name = name
        self.nameEnglish = nameEnglish
        self.id = id
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "IlceAdi"
        case nameEnglish = "IlceAdiEn"
        case id = "IlceID"
    }
}

class PrayerTime: Decodable {
    /// imsak - fajr
    var fajr: String!
    var sunrise: String!
    /// ogle - dhuhr
    var dhuhr: String!
    /// ikindi - asr
    var asr: String!
    /// aksam - maghrib
    var maghrib: String!
    /// yatsi - isha
    var isha: String!
//    var moonShapeUrl: String!
    var gregorianDateShortIso8601: String!
    var gregorianDateIso8601: String!
//    var hijriDateShort: String!
    var hijriDate: String!
    
    enum CodingKeys: String, CodingKey {
        case fajr = "Imsak"
        case sunrise = "Gunes"
        case dhuhr = "Ogle"
        case asr = "Ikindi"
        case maghrib = "Aksam"
        case isha = "Yatsi"
//        case moonShapeUrl = "AyinSekliURL"
        case gregorianDateShortIso8601 = "MiladiTarihKisaIso8601"
        case gregorianDateIso8601 = "MiladiTarihUzunIso8601"
//        case hijriDateShort = "HicriTarihKisa"
        case hijriDate = "HicriTarihUzun"
    }
    
//    "Aksam": "18:58",
//    "AyinSekliURL": "http://namazvakti.diyanet.gov.tr/images/i3.gif",
//    "Gunes": "08:00",
//    "GunesBatis": "18:51",
//    "GunesDogus": "08:07",
//    "HicriTarihKisa": "9.6.1440",
//    "HicriTarihUzun": "9 Cemaziyelahir 1440",
//    "Ikindi": "16:30",
//    "Imsak": "06:38",
//    "KibleSaati": "11:14",
//    "MiladiTarihKisa": "14.02.2019",
//    "MiladiTarihKisaIso8601": "14.02.2019",
//    "MiladiTarihUzun": "14 Şubat 2019 Perşembe",
//    "MiladiTarihUzunIso8601": "2019-02-14T00:00:00.0000000+03:00",
//    "Ogle": "13:34",
//    "Yatsi": "20:15"
//
//    sabah namazı : salatül fecr : al-fajer / fajr
//    öğle namazı : salatüz zuhr : al-zohr / zuhr / thuhr
//    ikindi namazı : salatül asr : al-asr / aser
//    akşam namazı : salatül mağrib : al-maghreb / maghrib
//    yatsı namazı : salatül işa' : al-eshaa / isha
//    imsak : al-shorook
    
}

enum PrayerTimeType: String, CaseIterable {
    case fajr
    case sunrise
    case dhuhr
    case asr
    case maghrib
    case isha
    
    func localizedString() -> String {
        switch self {
        case .fajr:
            return LocalizedConstants.Prayer.Fajr
        case .sunrise:
            return LocalizedConstants.Prayer.Sunrise
        case .dhuhr:
            return LocalizedConstants.Prayer.Dhuhr
        case .asr:
            return LocalizedConstants.Prayer.Asr
        case .maghrib:
            return LocalizedConstants.Prayer.Maghrib
        case .isha:
            return LocalizedConstants.Prayer.Isha
        }
    }
    
    func iconName() -> String {
        switch self {
        case .fajr:
            return Icon.fajr.rawValue
        case .sunrise:
            return Icon.sunrise.rawValue
        case .dhuhr:
            return Icon.dhuhr.rawValue
        case .asr:
            return Icon.asr.rawValue
        case .maghrib:
            return Icon.maghrib.rawValue
        case .isha:
            return Icon.isha.rawValue
        }
    }
}

class PrayerTimeAlarm {
    var status: Bool!
    var timeBefore: Int!
}

class Dhikr: Decodable {
    var name: String!
    var reading: String!
    var meaning: String!
    var uthmani: String!
    var remainingCount: Int!
    var roundCount: Int!
}

// Deneme
class QuranShort: Encodable, Decodable {
    var surahs: Array<SurahShort>!
}

class SurahShort: Encodable, Decodable {
    var number: Int!
    var name: String!
    var englishName: String!
    var ayahs: Array<AyahShort>!
}

class AyahShort: Encodable, Decodable {
    var number: Int!
    var text: String!
    var juz: Int!
    
    init(number: Int, text: String, juz: Int) {
        self.number = number
        self.text = text
        self.juz = juz
    }
}
// Deneme
