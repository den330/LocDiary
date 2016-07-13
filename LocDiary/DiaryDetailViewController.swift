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
            SaveButt.enabled = false
            locationLabel.text = "Searching Location...."
            handleOn()
        }else{
            handleOff()
            SaveButt.enabled = true
            locationLabel.text = "Cancelled"
        }
    }
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        if editingModeOn == false{
            let diaryEntity = NSEntityDescription.entityForName("Diary", inManagedObjectContext: managedContext)!
            let newDiary = Diary(entity: diaryEntity, insertIntoManagedObjectContext: managedContext)
            newDiary.content = contentView.text
            if titleView.text! == ""{
                newDiary.title = "No Title"
            }else{
                newDiary.title = titleView.text!
            }
            newDiary.diaryDate = NSDate()
        }else{
            currentDiary!.title = titleView.text!
            currentDiary!.content = contentView.text
            currentDiary!.diaryDate = NSDate()
        }
        try! managedContext.save()
        let hudView = HudView.hudInView(view, animated: true)
        hudView.text = "Saved"
        let delayInSeconds = 0.6
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds*Double(NSEC_PER_SEC)))
        dispatch_after(when, dispatch_get_main_queue()){
            self.navigationController?.popViewControllerAnimated(true)
        }
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
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    
    func handleOn(){
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined{
            locationManager.requestWhenInUseAuthorization()
            locationSwitch.on = false
            return
        }
        if authStatus == .Denied || authStatus == .Restricted{
            showLocationServiceDeniedAlert()
            locationSwitch.on = false
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func handleOff(){
        
    }
    
}
