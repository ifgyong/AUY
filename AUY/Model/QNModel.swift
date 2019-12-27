//
//  QNModel.swift
//  AUY
//
//  Created by Charlie on 2019/12/27.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

let kQiNiuKey = "kQiNiuKey";
let kQiNiuYuMingKey = "kQiNiuYuMingKey";

let kQiNiuaccessKey = "kQiNiuaccessKey";

let kQiNiusecretKey = "kQiNiusecretKey";

let kQiNiubuckName = "kQiNiubuckName";

let kOSS_ENDPOINT = "kOSS_ENDPOINT";


let kRegName = "kRegName";


class QNModel: NSObject,ModelActionProtocol {
	
	typealias ModelType = QNModel
	var accessKey = ""
	var secretKey = ""
	var buckName = ""
	var yuming = ""
	
	
	override static func getSaveModel() -> QNModel {
		let user = UserDefaults.standard
		user.dictionary(forKey: "kQiNiuKey")
		let m = QNModel()
		m.accessKey = user.string(forKey: kQiNiuaccessKey) ?? ""
		m.secretKey = user.string(forKey: kQiNiusecretKey) ?? ""
		m.buckName = user.string(forKey: kQiNiubuckName) ?? ""
		m.yuming = user.string(forKey: kOSS_ENDPOINT) ?? ""
		return m;
	}
	override static func saveModel(model: QNModel) {
		let user = UserDefaults.standard
		let dic = NSMutableDictionary();
		dic[kQiNiuaccessKey] = model.accessKey
		dic[kQiNiusecretKey] = model.secretKey
		dic[kQiNiubuckName] = model.buckName
		dic[kOSS_ENDPOINT]  = model.yuming
		user.set(dic, forKey: "kQiNiuKey")
		user.synchronize()
	}
}
