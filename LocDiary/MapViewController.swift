//
//  SecondViewController.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/11.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var locations = [Location]()
    var managedContext: NSManagedObjectContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocations()
    }
    
    func updateLocations(){
        mapView.removeAnnotations(locations)
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: managedContext)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        locations = try! managedContext.executeFetchRequest(fetchRequest) as! [Location]
        mapView.addAnnotations(locations)
    }

    @IBAction func LocationButton(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func UserButton(sender: UIBarButtonItem) {
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
}


extension MapViewController: MKMapViewDelegate{
    
}

