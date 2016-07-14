//
//  StringExtension.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/13.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import Foundation

extension String {
    mutating func addText(text: String?, withSeparator separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}