//
//  AppDelegate.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/11.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import UIKit
import PasscodeLock

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()
    
    lazy var passcodeLockPresenter: PasscodeLockPresenter = {
        
        let configuration = PasscodeLockConfiguration()
        let presenter = PasscodeLockPresenter(mainWindow: self.window, configuration: configuration)
        return presenter
    }()
    
    func customizeAppearance(){
        window?.tintColor = UIColor.whiteColor()
        let barTintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        UINavigationBar.appearance().barTintColor = barTintColor
        UITabBar.appearance().barTintColor = UIColor.clearColor()
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        passcodeLockPresenter.presentPasscodeLock()
        customizeAppearance()
        let tabController = window?.rootViewController as! UITabBarController
        let navCon = tabController.viewControllers![0] as! UINavigationController
        let diaryListCon = navCon.topViewController as! DiaryListViewController
        diaryListCon.managedContext = coreDataStack.context
        
        let secondNavCon = tabController.viewControllers![1] as! UINavigationController
        let mapCon = secondNavCon.topViewController as! MapViewController
        mapCon.managedContext = coreDataStack.context
        return true
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        passcodeLockPresenter.presentPasscodeLock()
    }



}

