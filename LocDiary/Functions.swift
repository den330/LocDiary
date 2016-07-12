//
//  Functions.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/12.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import Foundation


let dateFormatter: NSDateFormatter = {
    let dateform = NSDateFormatter()
    dateform.dateFormat = "MMM d, yyyy"
    return dateform
}()