//
//  PrayerSoundMO+CoreDataProperties.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 3/4/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//
//

import Foundation
import CoreData


extension PrayerSoundMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PrayerSoundMO> {
        return NSFetchRequest<PrayerSoundMO>(entityName: "PrayerSound")
    }

    @NSManaged public var localizedKey: String
    @NSManaged public var name: String
    @NSManaged public var notification: NSSet?

}

// MARK: Generated accessors for notification
extension PrayerSoundMO {

    @objc(addNotificationObject:)
    @NSManaged public func addToNotification(_ value: PrayerNotificationMO)

    @objc(removeNotificationObject:)
    @NSManaged public func removeFromNotification(_ value: PrayerNotificationMO)

    @objc(addNotification:)
    @NSManaged public func addToNotification(_ values: NSSet)

    @objc(removeNotification:)
    @NSManaged public func removeFromNotification(_ values: NSSet)

}
