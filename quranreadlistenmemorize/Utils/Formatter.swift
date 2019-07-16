//
//  Formatter.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/17/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class Formatter {
    static let shared = Formatter()
    
    var currentDate: Date {
        return Date()
    }
    
    // GMT +3:00
    private let timeZone = TimeZone(secondsFromGMT: 60*60*24*3)
    
    lazy var isoDateFormatter: ISO8601DateFormatter = {
        let dateFormatter = ISO8601DateFormatter()
        if #available(iOS 11.0, *) {
            dateFormatter.formatOptions = [.withInternetDateTime,
                                           .withFractionalSeconds]
        } else {
            dateFormatter.formatOptions = [.withInternetDateTime]
        }
        dateFormatter.timeZone = timeZone
        return dateFormatter
    }()
    
    lazy var hourMinuteDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
    lazy var dateTextFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM EEEE"
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
    let dateComponentFormatter: DateComponentsFormatter = {
        let dateComponentFormatter = DateComponentsFormatter()
        dateComponentFormatter.unitsStyle = .positional // short 11:11:11
        dateComponentFormatter.allowedUnits = [.hour, .minute, .second]
        return dateComponentFormatter
    }()
    
    func getDateComponents(date: Date) -> DateComponents {
        let components: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
        return Calendar.current.dateComponents(components, from: date)
    }
    
    func getTimeInterval(_ prayerTime: PrayerTimeMO, _ prayerTimeType: PrayerTimeType) -> TimeInterval {
        return prayerTime.getDateWith(prayerTimeType: prayerTimeType).timeIntervalSinceNow
    }
    
    func getDateFrom(_ prayerTime: PrayerTime, _ prayerTimeType: PrayerTimeType) -> Date {
        
        if let isoDateString = convertTimeToIsoDateString(prayerTime, prayerTimeType) {
            return isoDateFormatter.date(from: isoDateString) ?? Date()
        }
        return Date()
    }
    
    
    func convertTimeToIsoDateString(_ prayerTime: PrayerTime, _ prayerTimeType: PrayerTimeType) -> String? {
        var timeString = "00:00"
        switch prayerTimeType {
        case .fajr:
            timeString = prayerTime.fajr
        case .sunrise:
            timeString = prayerTime.sunrise
        case .dhuhr:
            timeString = prayerTime.dhuhr
        case .asr:
            timeString = prayerTime.asr
        case .maghrib:
            timeString = prayerTime.maghrib
        case .isha:
            timeString = prayerTime.isha
        }
        
        if let prayerIsoDateString = prayerTime.gregorianDateIso8601 {
            return prayerIsoDateString.replacingOccurrences(of: "T00:00", with: "T\(timeString)")
        }
        return nil
    }
    
    
}
