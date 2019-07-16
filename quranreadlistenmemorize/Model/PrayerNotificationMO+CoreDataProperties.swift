//
//  PrayerNotificationMO+CoreDataProperties.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 3/4/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//
//

import Foundation
import CoreData


extension PrayerNotificationMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PrayerNotificationMO> {
        return NSFetchRequest<PrayerNotificationMO>(entityName: "PrayerNotification")
    }

    @NSManaged public var id: Int16
    @NSManaged public var minutesBefore: Int16
    @NSManaged public var name: String
    @NSManaged public var status: Bool
    @NSManaged public var sound: PrayerSoundMO

}
