//
//  DhikrMO+CoreDataProperties.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 2/27/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//
//

import Foundation
import CoreData


extension DhikrMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DhikrMO> {
        return NSFetchRequest<DhikrMO>(entityName: "Dhikr")
    }

    @NSManaged public var name: String
    @NSManaged public var reading: String
    @NSManaged public var meaning: String
    @NSManaged public var uthmani: String
    @NSManaged public var remainingCount: Int16
    @NSManaged public var roundCount: Int16
    @NSManaged public var totalCount: Int16
    @NSManaged public var isSoundOn: Bool
}
