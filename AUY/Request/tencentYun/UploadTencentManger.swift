//
//  UploadTencentManger.swift
//  AUY
//
//  Created by Charlie on 2019/12/27.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

class UploadTencentManger: NSObject,UploadMangerProtocol {

	
	static func uploadTestAsync(_ data: Data, model: QNModel, complate: @escaping ComplateCallback, faild: @escaping ComplateCallback) {
		
	}
	static func uploadDatasAsync(_ datas: [Data], model: QNModel, complate: @escaping ComplateCallback, faild: @escaping ComplateCallback) {
		
	}
	static func uploadDataFromPasted() {
		let paste = NSPasteboard.general;
		let data = paste.data(forType: .png);
		UploadManger.share().imageIndex = 0;
		if (data == nil) {
			FYNotification.share().pushError(msg: "剪切板没有图片哦");
		} else{
			FYSourceManger.share().addImage(img: NSImage(data: data!)!)
			let model = QNModel.getSave();
			Self.uploadDatasAsync([data!],
								  model: model,
								  complate: { (url) in
									UploadManger.share().complate(url);
			}) { (error) in
				UploadManger.share().faild(error);
			}
		}
	}

}
extension UploadMangerProtocol{
//	func uploadDataFromPasted() {
//		let paste = NSPasteboard.general;
//		let data = paste.data(forType: .png);
//		UploadManger.share().imageIndex = 0;
//		if (data == nil) {
//			FYNotification.share().pushError(msg: "剪切板没有图片哦");
//		} else{
//			FYSourceManger.share().addImage(img: NSImage(data: data!)!)
//			let model = QNModel.getSave();
//			Self.uploadDatasAsync([data!],
//												model: model,
//												complate: { (url) in
//													UploadManger.share().complate(url);
//			}) { (error) in
//				UploadManger.share().faild(error);
//			}
//		}
//	}
 
}

