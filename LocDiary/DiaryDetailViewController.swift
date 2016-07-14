//
//  DiaryDetailViewController.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/11.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var SaveButt: UIBarButtonItem!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var titleView: UITextField!
    @IBOutlet weak var contentView: UITextView!
    var managedContext: NSManagedObjectContext!
    var editingModeOn = false
    var currentDiary: Diary?
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var lastLocationError: NSError?
    let geoCoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverse = false
    var lastGeoCodeError: NSError?
    var newDiary: Diary!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        if let diary = currentDiary{
            titleView.text = diary.title
            contentView.text = diary.content
        }
        tabBarController?.tabBar.hidden = true
    }
    
    @IBAction func switchTurn(sender: UISwitch) {
        if locationSwitch.on{
            handleOn()
        }else{
            handleOff()
        }
    }
    
    func saveDiary(){
        if editingModeOn == false{
            let diaryEntity = NSEntityDescription.entityForName("Diary", inManagedObjectContext: managedContext)!
            newDiary = Diary(entity: diaryEntity, insertIntoManagedObjectContext: managedContext)
            newDiary.content = contentView.text
            if titleView.text! == ""{
                newDiary.title = "No Title"
            }else{
                newDiary.title = titleView.text!
            }
            newDiary.diaryDate = NSDate()
        }else{
            newDiary = currentDiary
            currentDiary!.title = titleView.text!
            currentDiary!.content = contentView.text
            currentDiary!.diaryDate = NSDate()
        }
        try! managedContext.save()
    }
    
    func presentHudView(){
        let hudView = HudView.hudInView(view, animated: true)
        hudView.text = "Saved"
        let delayInSeconds = 0.6
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds*Double(NSEC_PER_SEC)))
        dispatch_after(when, dispatch_get_main_queue()){
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func saveLocation(){
        let fetchRequest = NSFetchRequest(entityName: "Location")
        let locations = try! managedContext.executeFetchRequest(fetchRequest) as! [Location]
        let cLocations = locations.map{$0.getCLocation()}
        let distances = cLocations.map{$0.distanceFromLocation(location!)}
        let minDistance = distances.minElement()
        let rightLocation: Location
        if minDistance <= 20 && !locations.isEmpty{
            let index = distances.indexOf(minDistance!)!
            rightLocation = locations[index]
            rightLocation.entNum += 1
        }else{
            let locationEntity = NSEntityDescription.entityForName("Location", inManagedObjectContext: managedContext)!
            let newLocation = Location(entity: locationEntity, insertIntoManagedObjectContext: managedContext)
            newLocation.entNum = 1
            newLocation.latitude = location!.coordinate.latitude
            newLocation.longitude = location!.coordinate.longitude
            newLocation.name = locationLabel.text!
            rightLocation = newLocation
        }
        
        let modifyArray = rightLocation.diaries.mutableCopy() as! NSMutableOrderedSet
        modifyArray.addObject(newDiary)
        rightLocation.diaries = modifyArray.copy() as! NSOrderedSet
        
        try! managedContext.save()
    }
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        saveDiary()
        saveLocation()
        presentHudView()
    }
}


extension DiaryDetailViewController: CLLocationManagerDelegate{
    
    func showLocationServiceDeniedAlert(){
        let alert = UIAlertController(title: "Location Service Disabled", message: "Please Enable This Service In Settings", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last!
        print(newLocation)
        if newLocation.timestamp.timeIntervalSinceNow < -5{
            return
        }
        if newLocation.horizontalAccuracy < 0{
            return
        }
        var distance = CLLocationDistance(DBL_MAX)
        if let location = location{
            distance = newLocation.distanceFromLocation(location)
        }
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy{
            lastLocationError = nil
            location = newLocation
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy{
                stopUpdate()
                performingReverse = false
            }
            getRealLocation(location!)
        }else if distance < 1.0{
            let timeInterval = newLocation.timestamp.timeIntervalSinceDate(location!.timestamp)
            if timeInterval > 10{
                stopUpdate()
            }
        }
    }
    
    func getRealLocation(location: CLLocation){
        if performingReverse == false{
            performingReverse = true
            geoCoder.reverseGeocodeLocation(location){placemarks, error in
                self.lastGeoCodeError = error
                if error == nil, let p = placemarks where !p.isEmpty{
                    self.placemark = p.last!
                    let loc = self.stringFromPlacemark(self.placemark!)
                    self.locationLabel.text = loc
                }else{
                    self.placemark = nil
                    self.handleWrong()
                }
                self.SaveButt.enabled = true
            }
        }
    }
    
    func handleWrong(){
        locationSwitch.on = false
        locationLabel.text = "Something Wrong, Try Again Later!"
    }
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        var line1 = ""
        line1.addText(placemark.subThoroughfare)
        line1.addText(placemark.thoroughfare, withSeparator: " ")
        
        var line2 = ""
        line2.addText(placemark.locality)
        line2.addText(placemark.administrativeArea, withSeparator: " ")
        line2.addText(placemark.postalCode, withSeparator: " ")
        
        line1.addText(line2, withSeparator: "\n")
        return line1
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error.code == CLError.LocationUnknown.rawValue{
            return
        }
        lastLocationError = error
        handleWrong()
    }
    
    func stopUpdate(){
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    
    func handleOn(){
        SaveButt.enabled = false
        locationLabel.text = "Searching Location...."
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined{
            locationManager.requestWhenInUseAuthorization()
            handleWrong()
            return
        }
        if authStatus == .Denied || authStatus == .Restricted{
            showLocationServiceDeniedAlert()
            handleWrong()
            return
        }
        startUpdate()
    }
    
    func startUpdate(){
        location = nil
        performingReverse = false
        lastGeoCodeError = nil
        lastLocationError = nil
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }
    
    func handleOff(){
        stopUpdate()
        SaveButt.enabled = true
        locationLabel.text = "Cancelled"
    }
    
}
