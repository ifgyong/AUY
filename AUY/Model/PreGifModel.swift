//
//  PreGifModel.swift
//  MToGifAndUpload
//
//  Created by fgy on 2019/12/14.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Foundation
class PreGIfModel: NSObject {
    var imagesArray = [NSImage]()
    var fps = 1.0
    var loop = 10
    var zoom :Double = 1.0
    
    init(f:Double,images:[NSImage],loopInt:Int,zm:Double) {
        if f >= 0.1 && f <= 24 {
            fps = f
        }
        imagesArray = images
        loop = loopInt
        if zm >= 0.1 && zm <= 1 {
            zoom = zm;
        }
        super.init()
    }
    override init() {
        
    }
}
