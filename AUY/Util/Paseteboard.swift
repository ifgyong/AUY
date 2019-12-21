//
//  Paseteboard.swift
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/12.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Foundation


//剪切板
extension NSPasteboard{
	/// MARK: 复制到剪切板
	@objc public func addUrlToPaste(msg:String,shouldClear: () -> Bool,complate:(()->Void)?) -> Void{
			let paste = NSPasteboard.general
			//第一次上传文件 清空剪切板
			if shouldClear() {
				paste.clearContents()
			}
		if complate != nil {
			complate!();
		}
			
			
			let str = paste.string(forType: .string)

		 
			guard var sub = str else {
				paste.setString(msg, forType: .string)
				return;
			}
		let yuming = QNModel.yuming()
		if yuming.count > 0 {
			
			if (sub.range(of: yuming) == nil) {
				paste.clearContents()
				sub = msg
			}else{
				sub =  "\(sub)\n\(msg)"
			}
		}
			
			paste.setString(sub, forType: .string)
		}
}
