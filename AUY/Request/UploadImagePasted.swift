//
//  UploadImagePasted.swift
//  AUY
//
//  Created by Charlie on 2019/12/26.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Foundation


class UploadImagePasted: NSObject {
	class func uploadImageFromPasted() -> Void{
		let paste = NSPasteboard.general;
		let data = paste.data(forType: .png)
		UploadManger .share().imageIndex = 0;
		if (data == nil) {
			FYNotification.share().pushError(msg: "剪切板没有图片哦")
		} else{
			FYSourceManger.share().addImage(img: NSImage(data: data!)!)
			let ty = UserDefaults.standard.getUploadType()
			if ty == .Unknow {
				FYNotification.share().pushError(msg: "❌，请ISS作者哦！")

			}else{
				guard let next =  RequestConfig.config[ty]else {
					FYNotification.share().pushError(msg: "❌，请ISS作者哦！")
					return;
				}
				next.uploadDataFromPasted?()
			}
		}
		
		
	}
}
