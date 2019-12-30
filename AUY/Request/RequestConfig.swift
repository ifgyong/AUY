//
//  RequestConfig.swift
//  AUY
//
//  Created by Charlie on 2019/12/27.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

/// 存放 遵守 上传协议的类型
struct RequestConfig {

	static var config : [UploadType : UploadMangerProtocol.Type] = [UploadType.QiNiu:QiniuUploadManger.self,
															 UploadType.AliYun:AliYunUploadMangre.self,
															 UploadType.Tencent:UploadTencentManger.self,
															 UploadType.UPYun:UPYunManger.self]
	
}
