//
//  PassCodeLockConfig.swift
//  LocDiary
//
//  Created by Yaxin Yuan on 16/7/17.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

import Foundation
import PasscodeLock

struct PasscodeLockConfiguration: PasscodeLockConfigurationType {
    
    let repository: PasscodeRepositoryType
    let passcodeLength = 4
    var isTouchIDAllowed = true
    let shouldRequestTouchIDImmediately = true
    let maximumInccorectPasscodeAttempts = -1
    
    init(repository: PasscodeRepositoryType) {
        
        self.repository = repository
    }
    
    init() {
        self.repository = UserDefaultsPasscodeRepository()
    }
}
