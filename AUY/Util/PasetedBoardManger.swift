//
//  PasetedBoardManger.swift
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/11.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Foundation
public class FYSourceManger:NSObject{
	
	@objc public var array = [String]()
	@objc public var arrayImage = [NSImage]()
	static let manger = FYSourceManger()
	@objc public static func share() -> FYSourceManger{
		return manger
	}
	@objc public override init() {
		
	}
	@objc public func addURL(url:String) ->Void{
		if array.count > 50 {
			array.remove(at: 0)
		}
		array.append(url)
	}
	@objc public func addImage(img:NSImage) ->Void{
		if arrayImage.count > 50 {
			arrayImage.remove(at: 0)
		}
		arrayImage.append(img)
	}
	@objc public func lastCopyURL()->String{
		guard let str = array.last else{
			return ""
		}
		return str
	}
	@objc public func lastImage()->NSImage?{
		return arrayImage.last
	}
}
