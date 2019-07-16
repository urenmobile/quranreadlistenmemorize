//
//  PrayerNotificationViewModel.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/27/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//

import Foundation

class PrayerNotificationViewModel: BaseViewModel {
    var items = [[ViewModelItem]]()
    let state = Dynamic(State.loading)
    
    func titleFor(section: Int) -> String {
        return section == 0 ? LocalizedConstants.Prayer.ReminderBeforeTime : LocalizedConstants.Prayer.ReminderInTime
    }
    
    func getAlarms() {
        state.value = .loading
        let prayerNotifications = PersistentManager.shared.fetch(PrayerNotificationMO.self)
        let beforeTimeItems = prayerNotifications.sorted(by: {$0.id < $1.id}).filter({$0.minutesBefore > 0}).compactMap({PrayerNotificationViewModelItem(prayerNotification: $0)})
        let inTimeItems = prayerNotifications.sorted(by: {$0.id < $1.id}).filter({$0.minutesBefore == 0}).compactMap({PrayerNotificationViewModelItem(prayerNotification: $0)})
        
        // First Section Elements
        var firstSection = [ViewModelItem]()
        if let beforeTimeItem = beforeTimeItems.first {
            firstSection.append(PrayerSoundSelectionViewModelItem(beforeTimeItem.prayerNotification.sound))
        }
        beforeTimeItems.forEach( { firstSection.append($0) })
        
        // Second Section Elements
        var secondSection = [ViewModelItem]()
        if let inTimeItem = inTimeItems.first {
            secondSection.append(PrayerSoundSelectionViewModelItem(inTimeItem.prayerNotification.sound))
        }
        inTimeItems.forEach( { secondSection.append($0) } )
        
        items.append(firstSection)
        items.append(secondSection)
        state.value = .populate
    }
    
    func changeSound(prayerSound: PrayerSoundMO, section: Int) {
        items[section].compactMap( { $0 as? PrayerNotificationViewModelItem }).forEach({ $0.prayerNotification.sound = prayerSound })
        updateDataAndScheduleNotification()
    }
    
    func updateDataAndScheduleNotification() {
        PersistentManager.shared.saveContext()
        PersistentManager.shared.schedulePrayerTimesNotification()
    }
}

class PrayerNotificationViewModelItem: ViewModelItem {
    var type: PrayerTimeType
    var prayerNotification: PrayerNotificationMO
    
    var titleText: String {
        return type.localizedString()
    }
    
    var subtitleText: String {
        let minutesBefore = prayerNotification.minutesBefore
        return minutesBefore == 0 ? LocalizedConstants.Prayer.InTime : "\(minutesBefore) " + LocalizedConstants.Prayer.MinutesBefore
    }
    
    var isSelectable: Bool {
        return prayerNotification.minutesBefore == 0 ? false : true
    }
    
    init(prayerNotification: PrayerNotificationMO) {
        self.prayerNotification = prayerNotification
        self.type = PrayerTimeType.init(rawValue: prayerNotification.name) ?? .fajr
    }
}
