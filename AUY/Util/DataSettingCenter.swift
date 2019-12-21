//
//  DataSettingCenter.swift
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/16.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

public class DataSettingCenter: NSObject {

	
	static let ddSetting:DataSettingCenter = DataSettingCenter(size: NSRect(x:0,y:0,width: 700,height: 500))
	var rectDidchangeClo:rectDidChange?

	
	
	var windowSize:NSRect{
		didSet{
			if rectDidchangeClo != nil {
				rectDidchangeClo!(oldValue)
			}
		}
	}
	
	typealias rectDidChange = (_ rect:NSRect)->Void
	
	public class func `default`() -> DataSettingCenter{
		return ddSetting
	}
	fileprivate init(size:NSRect) {
		windowSize = size
		super.init()
	}
	func setwindowSizeDidChange(rectDidchangeClo:rectDidChange?)->Void{
		self.rectDidchangeClo = rectDidchangeClo
	}
	
	
	
	
	
	
	

	
}
