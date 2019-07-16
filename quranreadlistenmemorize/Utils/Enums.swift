//
//  Enums.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//


enum Icon: String {
    case alarm = "icon-alarm"
    case speaker = "icon-speaker"
    case speakerLandscape = "icon-speaker-landscape"
    case asr = "icon-asr"
    case back = "icon-back"
    case dhikr = "icon-dhikr"
    case dhuhr = "icon-dhuhr"
    case fajr = "icon-fajr"
    case forward = "icon-forward"
    case isha = "icon-isha"
    case maghrib = "icon-maghrib"
    case message = "icon-message"
    case place = "icon-place"
    case play = "icon-play"
    case prayerTimes = "icon-prayer-times"
    case qibla = "icon-qibla"
    case quran = "icon-quran"
    case sunrise = "icon-sunrise"
}


enum State {
    case loading
    case populate
    case empty
    case error
}

enum QuranType {
    case quranUthmani
    case diyanet
    case englishTransliteration
    case turkishTransliteration
    
    func identifier() -> String {
        switch self {
        case .quranUthmani:
            return "quran-uthmani"
        case .diyanet:
            return "tr.diyanet"
        case .englishTransliteration:
            return "en.transliteration"
        case .turkishTransliteration:
            return "tr.transliteration"
        }
    }
    
    func resourceName() -> String {
        switch self {
        case .quranUthmani:
            return Constants.Bundle.Path.QuranTypeQuranUthmani
        case .turkishTransliteration:
            return Constants.Bundle.Path.QuranTypeTrTransliteration
        case .englishTransliteration:
            return Constants.Bundle.Path.QuranTypeEnTransliteration
        case .diyanet:
            return Constants.Bundle.Path.QuranTypeDiyanet
        }
    }
}
