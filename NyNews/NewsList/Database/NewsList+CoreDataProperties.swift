//
//  NewsList+CoreDataProperties.swift
//  NyTimes
//
//  Created by APPLE on 30/04/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//
//

import Foundation
import CoreData


extension NewsList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsList> {
        return NSFetchRequest<NewsList>(entityName: "NewsList")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var abstract: String?
    @NSManaged public var url: String?
    @NSManaged public var imgLink: String?
    @NSManaged public var favourite: Bool
}
