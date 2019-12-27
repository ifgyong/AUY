//
//  ModelProtocol.swift
//  AUY
//
//  Created by Charlie on 2019/12/27.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Foundation

protocol ModelActionProtocol  {
	associatedtype ModelType
	static func getSaveModel() -> ModelType
	static func saveModel(model:ModelType)
}
