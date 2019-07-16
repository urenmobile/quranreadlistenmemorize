//
//  PrayerTimeMO+CoreDataProperties.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/27/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//
//

import Foundation
import CoreData


extension PrayerTimeMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PrayerTimeMO> {
        return NSFetchRequest<PrayerTimeMO>(entityName: "PrayerTime")
    }

    @NSManaged public var asrDate: Date
    @NSManaged public var dhuhrDate: Date
    @NSManaged public var fajrDate: Date
    @NSManaged public var gregorianDate: Date
    @NSManaged public var hijriDateString: String
    @NSManaged public var ishaDate: Date
    @NSManaged public var maghribDate: Date
    @NSManaged public var sunriseDate: Date

}
