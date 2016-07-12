//
//  FirstViewController.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/11.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import UIKit

class DiaryListViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension DiaryListViewController: UINavigationBarDelegate{
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

