//
//  Constants.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

class Constants {
    static let MaxDhikrCount: Int16 = 99
    static let Suresi = " Sûresi"
    static let AppName = "Kuran Ezan"
    static let Hash = "#"
    static let AudioEditionId = "ar.alafasy"
    static let DefaultSoundName = "sms-received1.caf"
    
    struct Notification {
        static let CategoryId = "INVITATION"
    }
    
    
    struct Cache {
        static let DiskPath = "urenqurancache"
        static let MemoryCapacity = 1024 * 1024 * 20 // 20 MB
        static let DiskCapacity = 1024 * 1024 * 100 // 100 MB
        static let ExpireDay = 15
    }
    
    struct Language {
        static let Turkish = "tr"
        static let Arabic = "ar"
    }
    
    struct ADMOB {
        static let APP_ID = "ca-app-pub-7227467199436307~3412428339"
        // All Test, change real one
        static let BANNER_UNIT_ID = "ca-app-pub-3940256099942544/2934735716"
        static let INTERSTITIAL_UNIT_ID = "ca-app-pub-3940256099942544/4411468910"
        static let REWARDED_UNIT_ID = "ca-app-pub-3940256099942544/1712485313"
    }
    
    struct Bundle {
        struct Path {
            static let QuranEditionFolder = "QuranEdition"
            static let QuranEditions = "Quran.bundle/Data/quran-editions"
            
            static let QuranTypeQuranUthmani = "Quran.bundle/Data/quran-uthmani"
            static let QuranTypeDiyanet = "Quran.bundle/Data/tr.diyanet"
            static let QuranTypeTrTransliteration = "Quran.bundle/Data/tr.transliteration"
            static let QuranTypeEnTransliteration = "Quran.bundle/Data/en.transliteration"
            static let Dhikrs = "Quran.bundle/Data/dhikrs"
        }
        struct FileType {
            static let Json = "json"
            static let Mp3 = "mp3"
        }
    }
}
