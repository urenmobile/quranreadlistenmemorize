//
//  EditionMO+CoreDataProperties.swift
//  quranreadlistenmemorize
//
//  Created by Remzi YILDIRIM on 3/6/19.
//  Copyright © 2019 Remzi YILDIRIM. All rights reserved.
//
//

import Foundation
import CoreData


extension EditionMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EditionMO> {
        return NSFetchRequest<EditionMO>(entityName: "Edition")
    }

    @NSManaged public var identifier: String
    @NSManaged public var language: String
    @NSManaged public var name: String
    @NSManaged public var englishName: String
    @NSManaged public var format: String
    @NSManaged public var type: String
    @NSManaged public var configuration: AppConfigurationMO?

}
