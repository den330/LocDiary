//
//  Diary+CoreDataProperties.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/11.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Diary {
    @NSManaged var title: String
    @NSManaged var diaryDate: NSDate
    @NSManaged var content: String
}
