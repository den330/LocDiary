//
//  Location+CoreDataProperties.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/14.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var entNum: Int32
    @NSManaged var name: String
    @NSManaged var diaries: NSOrderedSet

}
