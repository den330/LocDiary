//
//  FirstViewController.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/11.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import UIKit
import CoreData

class DiaryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var managedContext: NSManagedObjectContext!
    let fetchRequest = NSFetchRequest(entityName: "Diary")
    var fetchedResultController: NSFetchedResultsController!
    let sortDescripitor = NSSortDescriptor(key: "diaryDate", ascending: false)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "DiaryCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "DiaryCell")
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension
        fetchRequest.sortDescriptors = [sortDescripitor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        try! fetchedResultController.performFetch()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.hidden = false
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier  == "showDetail" || segue.identifier == "editDetail"{
            let detailCon = segue.destinationViewController as! DiaryDetailViewController
            detailCon.managedContext = managedContext
            if segue.identifier == "editDetail"{
                let path = sender as! NSIndexPath
                let diary = fetchedResultController.objectAtIndexPath(path) as! Diary
                detailCon.currentDiary = diary
                detailCon.editingModeOn = true
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete{
            let diary = fetchedResultController.objectAtIndexPath(indexPath) as! Diary
            if let location = diary.location{
               
                let diaries = location.diaries.mutableCopy() as! NSMutableOrderedSet
                diaries.removeObject(diary)
                location.diaries = diaries.copy() as! NSOrderedSet
                location.entNum -= 1
                if location.entNum == 0{
                    managedContext.deleteObject(location)
                }
            }
            managedContext.deleteObject(diary)
            try! managedContext.save()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultController.sections![section]
        let rowInfo = sectionInfo.numberOfObjects
        return rowInfo
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("editDetail", sender: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiaryCell") as! DiaryCell
        let diary = fetchedResultController.objectAtIndexPath(indexPath) as! Diary
        configureCell(diary, cell: cell)
        return cell
    }
    
    func configureCell(diary: Diary, cell: DiaryCell){
        cell.dateLabel.text = dateFormatter.stringFromDate(diary.diaryDate)
        cell.titleLabel.text = diary.title
    }
}

extension DiaryListViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type{
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! DiaryCell
            let diary = fetchedResultController.objectAtIndexPath(indexPath!) as! Diary
            configureCell(diary, cell: cell)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}

extension DiaryListViewController: UINavigationBarDelegate{
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

