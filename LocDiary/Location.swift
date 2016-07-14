//
//  Location.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/13.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class Location: NSManagedObject {

    func getCLocation() -> CLLocation{
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return location
    }

}
