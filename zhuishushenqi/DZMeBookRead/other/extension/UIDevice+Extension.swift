//
//  UIDevice+Extension.swift
//  DZMeBookRead
//
//  Created by 郑开心 on 2017/11/6.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit
extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
}
