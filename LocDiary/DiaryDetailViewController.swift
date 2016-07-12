//
//  DiaryDetailViewController.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/11.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import UIKit
import CoreData

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleView: UITextField!
    @IBOutlet weak var contentView: UITextView!
    var managedContext: NSManagedObjectContext!
    var editingModeOn = false
    var currentDiary: Diary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        if let diary = currentDiary{
            titleView.text = diary.title
            contentView.text = diary.content
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
        navigationController?.popViewControllerAnimated(true)
    }


}
