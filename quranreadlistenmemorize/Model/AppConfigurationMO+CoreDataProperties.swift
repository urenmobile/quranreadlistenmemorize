//
//  AppConfigurationMO+CoreDataProperties.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 3/6/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//
//

import Foundation
import CoreData


extension AppConfigurationMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppConfigurationMO> {
        return NSFetchRequest<AppConfigurationMO>(entityName: "AppConfiguration")
    }

    @NSManaged public var prayerTimesExpireDate: Date?
    @NSManaged public var selectedAudioEditionId: String
    @NSManaged public var city: PrayerLocationMO?
    @NSManaged public var country: PrayerLocationMO?
    @NSManaged public var county: PrayerLocationMO?
    @NSManaged public var edition: EditionMO

}
