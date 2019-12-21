//
//  NSAlertCategory.swift
//  MToGifAndUpload
//
//  Created by fgy on 2019/12/17.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Foundation

extension NSAlert{
   class func show(msg:String,window:NSWindow){
        let alert = NSAlert()
        alert.messageText = msg
        alert.alertStyle = .informational
        alert.beginSheetModal(for: window)
    }
}
