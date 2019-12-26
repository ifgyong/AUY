//
//  UserDefaultCategory.swift
//  AUY
//
//  Created by Charlie on 2019/12/26.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Foundation

let kUserDefaultUploadType = "kUserDefaultUploadType";

// 配置 参数设置
extension UserDefaults{
	func setUploadType( ty:UploadType) -> Void {
		self .set(ty, forKey: kUserDefaultUploadType)
		self.synchronize()
	}
	
	func getUploadType() -> UploadType {
		let ty  = self.integer(forKey: kUserDefaultUploadType)
		return UploadType(rawValue: ty)!
	}
	
}
