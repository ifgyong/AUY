//
//  UploadSetting.swift
//  AUY
//
//  Created by Charlie on 2019/12/26.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Foundation
enum UploadType:Int {
	case QiNiu = 0
	case AliYun = 1
	case Tencent = 2
	case Unknow = 3
	static func raw(_ raw:Int) -> UploadType {
		var ty = UploadType.Unknow
		switch raw {
		case 0:ty = .QiNiu
		case 1:ty = .AliYun
		case 2:ty = .Tencent
		case 3:ty = .Unknow

		default:
			break;
		}
		return ty
	}
	func raw() -> Int{
		switch self {
		case .QiNiu:return 0
			case .AliYun:return 1
			case .Tencent:return 2
			case .Unknow:return 3
		}
	}
}
