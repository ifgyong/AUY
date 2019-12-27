//
//  TencentModel.swift
//  AUY
//
//  Created by Charlie on 2019/12/27.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa


class TencentModel: QNModel {

	var regionName = ""
	class func getTencentSave() -> TencentModel {
		let model = TencentModel.init();
		let user = UserDefaults.standard.dictionary(forKey: kQiNiuKey)
		if (user?.count == 0) {
			return model;
		}
		
		model.accessKey = user?[kQiNiuaccessKey] as? String  ?? "";
		model.secretKey = user?[kQiNiusecretKey] as? String ?? "";
		model.buckName = user?[kQiNiubuckName] as? String ?? ""; //@"fgyongblog";
		model.yuming =  user?[kOSS_ENDPOINT] as? String ?? "" //[user objectForKey:kOSS_ENDPOINT];
		model.regionName = user?[kRegName] as? String  ?? ""
		return model;
	}
	class func saveTencent(_ model: TencentModel) {
		var dic = [String:String]()
		if model.regionName.count > 0 {
			dic[kRegName] = model.regionName
		}
		 if model.yuming.count > 0 {
			 dic[kOSS_ENDPOINT] = model.yuming
		 }
		if model.buckName.count > 0 {
			dic[kQiNiubuckName] = model.buckName
		}
		if model.secretKey.count > 0 {
			dic[kQiNiusecretKey] = model.secretKey
		}
		if model.accessKey.count > 0 {
			dic[kQiNiuaccessKey] = model.accessKey
		}
		UserDefaults.standard.setValue(dic, forKey: kQiNiuKey)
		UserDefaults.standard.synchronize()
	}
	
}
