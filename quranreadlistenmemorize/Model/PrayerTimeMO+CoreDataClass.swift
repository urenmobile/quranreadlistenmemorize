//
//  PrayerTimeMO+CoreDataClass.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/27/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//
//

import Foundation
import CoreData


public class PrayerTimeMO: NSManagedObject {

    func getDateWith(prayerTimeType: PrayerTimeType) -> Date {
        switch prayerTimeType {
        case .fajr:
            return fajrDate
        case .sunrise:
            return sunriseDate
        case .dhuhr:
            return dhuhrDate
        case .asr:
            return asrDate
        case .maghrib:
            return maghribDate
        case .isha:
            return ishaDate
        }
    }
}
