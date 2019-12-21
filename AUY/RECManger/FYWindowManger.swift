//
//  FYWindowManger.swift
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/17.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

class FYWindowManger: NSObject {
	static var `default` = FYWindowManger()
	

	var wn:FYSettingWindow? = FYSettingWindow(contentRect: RectCatory.kWindowSettingRect,
											  styleMask:  [.titled,.closable,.miniaturizable],
											  backing: NSWindow.BackingStoreType.buffered,
											  defer: false)
	
	func getWindow() -> FYSettingWindow {
		if wn != nil {
			return wn!
		}
		return  FYSettingWindow(contentRect: RectCatory.kWindowSettingRect,
								styleMask:  [.titled,.closable,.miniaturizable],
								backing: NSWindow.BackingStoreType.buffered,
								defer: false)
	}
	
}
