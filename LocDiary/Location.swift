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
import MapKit

class Location: NSManagedObject,MKAnnotation {
    
    func getCLocation() -> CLLocation{
        let location = CLLocation(latitude: latitude, longitude: longitude)
        return location
    }
    
    var coordinate: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String?{
        let description = "\(entNum) diaries"
        return description
    }

}
