//
//  LocalizedConstants.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/5/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class LocalizedConstants {
    static let Yes = NSLocalizedString("Yes", comment: "")
    static let No = NSLocalizedString("No", comment: "")
    static let Ok = NSLocalizedString("Ok", comment: "")
    static let Cancel = NSLocalizedString("Cancel", comment: "")
    static let Settings = NSLocalizedString("Settings", comment: "")
    static let UnknownError = NSLocalizedString("UnknownError", comment: "")
    static let Error = NSLocalizedString("Error", comment: "")
    static let Warning = NSLocalizedString("Warning", comment: "")
    static let DefaultError = NSLocalizedString("DefaultError", comment: "")
    static let Loading = NSLocalizedString("Loading", comment: "")
    static let Download = NSLocalizedString("Download", comment: "")
    static let Downloading = NSLocalizedString("Downloading", comment: "")
    static let Send = NSLocalizedString("Send", comment: "")
    
    struct Permission {
        static let Notification = NSLocalizedString("PermissionNotification", comment: "")
        static let Location = NSLocalizedString("PermissionLocation", comment: "")
        static let NotNow = NSLocalizedString("PermissionNotNow", comment: "")
        static let GiveAccess = NSLocalizedString("PermissionGiveAccess", comment: "")
        // Location Permission
        static let GiveAccessLocationTitle = NSLocalizedString("PermissionGiveAccessLocationTitle", comment: "")
        static let GiveAccessLocationBody = NSLocalizedString("PermissionGiveAccessLocationBody", comment: "")
        static let AccessDisableLocationTitle = NSLocalizedString("PermissionAccessDisableLocationTitle", comment: "")
        static let AccessDisableLocationBody = NSLocalizedString("PermissionAccessDisableLocationBody", comment: "")
        // Notification Permission
        static let GiveAccessNotificationTitle = NSLocalizedString("PermissionGiveAccessNotificationTitle", comment: "")
        static let GiveAccessNotificationBody = NSLocalizedString("PermissionGiveAccessNotificationBody", comment: "")
        static let AccessDisableNotificationTitle = NSLocalizedString("PermissionAccessDisableNotificationTitle", comment: "")
        static let AccessDisableNotificationBody = NSLocalizedString("PermissionAccessDisableNotificationBody", comment: "")
    }
    
    struct Network {
        static let NoInternetConnection        = NSLocalizedString("NoInternetConnection", comment: "")
        static let NoInternetConnectionMessage = NSLocalizedString("NoInternetConnectionMessage", comment: "")
    }
    
    struct Surah {
        static let Surahs = NSLocalizedString("SurahSurahs", comment: "")
        static let Quran = NSLocalizedString("SurahQuran", comment: "")
        static let Ayahs = NSLocalizedString("SurahAyahs", comment: "")
    }
    
    struct Edition {
        static let Translations = NSLocalizedString("EditionTranslations", comment: "")
        static let SelectTranslation = NSLocalizedString("EditionSelectTranslation", comment: "")
        static let SelectedTranslation = NSLocalizedString("EditionSelectedTranslation", comment: "")
        static let DownloadTranslationMessage  = NSLocalizedString("DownloadTranslationMessage", comment: "")
        static let DownloadContinueTranslationMessage  = NSLocalizedString("DownloadContinueTranslationMessage", comment: "")
    }
    
    struct Prayer {
        static let SetAlarm             = NSLocalizedString("PrayerSetAlarm", comment: "")
        static let PrayerTimes          = NSLocalizedString("PrayerTimes", comment: "")
        static let Countries            = NSLocalizedString("PrayerCountries", comment: "")
        static let Fajr                 = NSLocalizedString("PrayerFajr", comment: "")
        static let Sunrise              = NSLocalizedString("PrayerSunrise", comment: "")
        static let Dhuhr                = NSLocalizedString("PrayerDhuhr", comment: "")
        static let Asr                  = NSLocalizedString("PrayerAsr", comment: "")
        static let Maghrib              = NSLocalizedString("PrayerMaghrib", comment: "")
        static let Isha                 = NSLocalizedString("PrayerIsha", comment: "")
        static let RemainingTime        = NSLocalizedString("PrayerRemainingTime", comment: "")
        static let SelectLocationHeader = NSLocalizedString("PrayerSelectLocationHeader", comment: "")
        static let SelectLocation       = NSLocalizedString("PrayerSelectLocation", comment: "")
        static let SelectLocationFooter = NSLocalizedString("PrayerSelectLocationFooter", comment: "")
        static let TodayLocationFooter  = NSLocalizedString("PrayerTodayLocationFooter", comment: "")
        static let MonthlyPrayerTimes   = NSLocalizedString("PrayerMonthlyPrayerTimes", comment: "")
        static let AlarmSettings        = NSLocalizedString("PrayerAlarmSettings", comment: "")
        static let InTime               = NSLocalizedString("PrayerInTime", comment: "")
        static let MinutesBefore        = NSLocalizedString("PrayerMinutesBefore", comment: "")
        static let ReminderBeforeTime   = NSLocalizedString("PrayerReminderBeforeTime", comment: "")
        static let ReminderInTime       = NSLocalizedString("PrayerReminderInTime", comment: "")
        static let AlarmSound           = NSLocalizedString("PrayerAlarmSound", comment: "")
        static let DefaultSound         = NSLocalizedString("PrayerSoundDefault", comment: "")
    }
    
    struct More {
        static let Qibla          = NSLocalizedString("MoreQibla", comment: "")
        static let Dhikr          = NSLocalizedString("MoreDhikr", comment: "")
        static let HolyDayMessage = NSLocalizedString("MoreHolyDayMessage", comment: "")
        static let MoreDhikrReset = NSLocalizedString("MoreDhikrReset", comment: "")
    }
    
    struct Notification {
        static let BodyInTime     = NSLocalizedString("NotificationBodyInTime", comment: "")
        static let BodyBeforeTime = NSLocalizedString("NotificationBodyBeforeTime", comment: "")
    }
}
