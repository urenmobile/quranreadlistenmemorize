//
//  PrayerLocationMO+CoreDataProperties.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 3/2/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//
//

import Foundation
import CoreData


extension PrayerLocationMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PrayerLocationMO> {
        return NSFetchRequest<PrayerLocationMO>(entityName: "PrayerLocation")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var nameEnglish: String
    @NSManaged public var city: AppConfigurationMO?
    @NSManaged public var county: AppConfigurationMO?
    @NSManaged public var country: AppConfigurationMO?

}
