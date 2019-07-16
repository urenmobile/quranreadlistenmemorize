//
//  NotificationManager.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/20/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization(_ viewController: UIViewController) {
        notificationCenter.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                AlertController.showPrePermissionAlert(viewController, serviceType: .notification, handler: { (_) in
                    self.notificationCenter.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
                        //granted = yes, if app is authorized for all of the requested interaction types
                        //granted = no, if one or more interaction type is disallowed
                        if !granted {
                            AlertController.showAccessDeniedAlert(viewController, serviceType: .notification)
                        }
                    }
                })
            case .denied:
                AlertController.showAccessDeniedAlert(viewController, serviceType: .notification)
            default:
                return
            }
        }
    }
    
    func removeAllNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func scheduleLocal(prayerNotification: PrayerNotificationMO, prayerTime: PrayerTimeMO) {
        let county = PersistentManager.shared.appConfiguration.county
        let notifDate = getDate(prayerNotification, prayerTime)
        guard prayerNotification.status, notifDate > Formatter.shared.currentDate, let _ = county else { return }
        
        let content = UNMutableNotificationContent()
        content.body = getLocalizedMessage(prayerNotification)
        content.categoryIdentifier = Constants.Notification.CategoryId
        content.sound = UNNotificationSound.default
        
        if prayerNotification.sound.name != Constants.DefaultSoundName {
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: prayerNotification.sound.name))
        }
        
//        // sil
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 60*60*24*3)
//        dateFormatter.locale = Locale.current
//
//        print("Notif Gonderilecek mesaj: \(content.body) - \(dateFormatter.string(from: notifDate))")
        
        // TODO: ac
        let dateComponents = Formatter.shared.getDateComponents(date: notifDate)
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        
        //Notification Request
        let notificationId = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        
        //Scheduling the Notification
        notificationCenter.getNotificationSettings { (settings) in
            // Do not schedule notifications if not authorized.
            guard settings.authorizationStatus == .authorized else {return}
            
            self.notificationCenter.add(request) { (error) in
                if let error = error {
                    debugPrint("Notification center add error: \(error.localizedDescription)")
                } else {
                    debugPrint("Notification center add success")
                }
            }
        }
    }
    
    private func getLocalizedMessage(_ prayerNotification: PrayerNotificationMO) -> String {
        let message = ""
        guard let county = PersistentManager.shared.appConfiguration.county else { return message }
        
        let countyName = PersistentManager.shared.isTurkishLanguage ? county.name : county.nameEnglish
        
        let prayerTimeType = PrayerTimeType.init(rawValue: prayerNotification.name) ?? .fajr
        
        if prayerNotification.minutesBefore == 0 {
            let localizedFormat = LocalizedConstants.Notification.BodyInTime
            return String.localizedStringWithFormat(localizedFormat, countyName, prayerTimeType.localizedString())
        } else {
            let localizedFormat = LocalizedConstants.Notification.BodyBeforeTime
            return String.localizedStringWithFormat(localizedFormat, countyName, prayerTimeType.localizedString(), prayerNotification.minutesBefore)
        }
    }
    
    private func getDate(_ prayerNotification: PrayerNotificationMO, _ prayerTime: PrayerTimeMO) -> Date {
        let prayerTimeType = PrayerTimeType.init(rawValue: prayerNotification.name) ?? .fajr
        return prayerTime.getDateWith(prayerTimeType: prayerTimeType)
    }
}
