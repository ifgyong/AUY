//
//  UploadTencentManger.swift
//  AUY
//
//  Created by Charlie on 2019/12/27.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa
import QCloudCore
import QCloudCOSXML

class UploadTencentManger: NSObject,UploadMangerProtocol {
	
	static var manger:UploadTencentManger = UploadTencentManger.init()
	var model :QNModel?
	
	class func `default`() -> UploadTencentManger {
		return UploadTencentManger.manger
	}
	func config() -> Void{
		
		let config = QCloudServiceConfiguration.init();
		config.signatureProvider = self
//		config.appID = "appId";
		let endpoint = QCloudCOSXMLEndPoint.init();
		endpoint.regionName = model!.regName;
		endpoint.useHTTPS = true;
		config.endpoint = endpoint;
		QCloudCOSXMLService.registerDefaultCOSXML(with: config);
		QCloudCOSTransferMangerService.registerDefaultCOSTransferManger(with: config);
	}
	
	static func uploadTestAsync(_ data: Data, model: QNModel, complate: @escaping ComplateCallback, faild: @escaping ComplateCallback) {
		let manger =  UploadTencentManger.default()
        
		manger.model = model
		manger.config()
		self .uploadDatasAsync([data], model: model, complate: complate, faild: faild)
	}
	static func uploadDatasAsync(_ datas: [Data], model: QNModel, complate: @escaping ComplateCallback, faild: @escaping ComplateCallback) {
		if (model.regName.count  == 0) {
			FYNotification.share().pushError(msg: "请先设置图床平台！")
			return;
		}
		if (datas.count == 0) {
			FYNotification.share().pushError(msg: "图片为空哦！")
			return;
		}
        let manger =  UploadTencentManger.default()
        
        manger.model = model
        manger.config()
        
		//重置当前索引
		UploadManger.share().imageIndex = 0// = 0;
		UploadManger.share().filesCount = datas.count;
		for i in 0..<datas.count{
            let dataBody:NSData? = datas[i] as NSData
            let uploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>.init();
            uploadRequest.body = dataBody!;
            uploadRequest.bucket = model.buckName;
            uploadRequest.object = QiniuUploadManger.getNameWith(datas[i]);
            //设置上传参数
            //		uploadRequest.initMultipleUploadFinishBlock = {(multipleUploadInitResult,resumeData) in
            //			//在初始化分块上传完成以后会回调该 block，在这里可以获取 resumeData，并且可以通过 resumeData 生成一个分块上传的请求
            //			let resumeUploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>.init(request: resumeData as Data?);
            //		}
            uploadRequest.sendProcessBlock = {(bytesSent , totalBytesSent , totalBytesExpectedToSend) in
                print("progress:\(Double(totalBytesSent)/Double(totalBytesExpectedToSend))")
            }
            uploadRequest.setFinish { (result, error) in
                if error != nil{
                    print(error!)
                    DispatchQueue.main.async {
                        faild("\(error!)")
                    }
                    
                }else{
                    //从 result 中获取请求的结果
                    print(result!);
                    let key = "![](\(model.yuming)/\(result!.key))"
                    DispatchQueue.main.async {
                        complate(key)
                    }
                }}
            
            QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(uploadRequest);
		}
		

//		//•••在完成了初始化，并且上传没有完成前
//		var error:NSError?;
//			//这里是主动调用取消，并且产生 resumetData 的例子
//		do {
//			let resumedData = try uploadRequest.cancel(byProductingResumeData: &error);
//				var resumeUploadRequest:QCloudCOSXMLUploadObjectRequest<AnyObject>?;
//					 resumeUploadRequest = QCloudCOSXMLUploadObjectRequest<AnyObject>.init(request: resumedData as Data?);
//					 //生成的用于恢复上传的请求可以直接上传
//			if resumeUploadRequest != nil {
//				QCloudCOSTransferMangerService.defaultCOSTransferManager().uploadObject(resumeUploadRequest!);
//			}
//
//		} catch  {
//			print("resumeData 为空");
//			return;
//		}
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
extension UploadTencentManger:QCloudSignatureProvider{
	// MARK: 生成签名
	func signature(with fileds: QCloudSignatureFields!, request: QCloudBizHTTPRequest!, urlRequest urlRequst: NSMutableURLRequest!, compelete continueBlock: QCloudHTTPAuthentationContinueBlock!) {
		let cre = QCloudCredential.init();
	
		  cre.secretID = model?.accessKey  //"COS_SECRETID";
		  cre.secretKey =  model?.secretKey //"COS_SECRETKEY";
		  let auth = QCloudAuthentationV5Creator.init(credential: cre);
		  let signature = auth?.signature(forData: urlRequst)
		  continueBlock(signature,nil);
	}
	
	
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

