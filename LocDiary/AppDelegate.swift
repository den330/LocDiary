//
//  AppDelegate.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/11.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let tabController = window?.rootViewController as! UITabBarController
        let navCon = tabController.viewControllers![0] as! UINavigationController
        let diaryListCon = navCon.topViewController as! DiaryListViewController
        diaryListCon.managedContext = coreDataStack.context
        return true
    }



}

