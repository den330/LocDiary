//
//  AnnotationDetailViewController.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/15.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import UIKit
import CoreData

class AnnotationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var managedContext: NSManagedObjectContext!
    weak var locationToEdit: Location?
    var diaries: NSOrderedSet?
    var isFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "DiaryCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "DiaryCell")
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension
        diaries = locationToEdit!.diaries
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.hidden = false
        if !isFirstTime{
            if let locationToEdit = locationToEdit{
                diaries = locationToEdit.diaries
                tableView.reloadData()
            }else{
                navigationController?.popViewControllerAnimated(true)
            }
        }else{
            isFirstTime = false
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries!.count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            let diary = diaries![indexPath.row] as! Diary
            if let location = diary.location{
                location.entNum -= 1
                if location.entNum == 0{
                    managedContext.deleteObject(location)
                }
            }
            managedContext.deleteObject(diary)
            try! managedContext.save()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiaryCell") as! DiaryCell
        let diary = diaries![indexPath.row] as! Diary
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = dateFormatter.stringFromDate(diary.diaryDate)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showThisOne", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showThisOne"{
            let detailVC = segue.destinationViewController as! DiaryDetailViewController
            detailVC.editingModeOn = true
            let path = sender as! NSIndexPath
            let diary = diaries![path.row] as! Diary
            detailVC.currentDiary = diary
            detailVC.managedContext = managedContext
        }
    }
}

