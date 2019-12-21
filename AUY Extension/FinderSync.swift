//
//  SafariExtensionHandler.swift
//  MToGifAndUpload Extension
//
//  Created by Charlie on 2019/12/6.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa
import FinderSync
import Foundation
import AppKit


import UserNotifications



class FinderSync: FIFinderSync {
//"/Users/Shared/MySyncExtension Documents"
	
	
	let finderController = FIFinderSyncController.default()
	let preferences = Preferences.sharedInstance
	let defaultImageIcon = NSImage(named: "yun") ?? NSImage(named: NSImage.cautionName)!
	let task = Process();//进程
	override init() {
		super.init()
//        createService()
        NSLog("FinderSync() 初始化： %@", Bundle.main.bundlePath as NSString)

		// as a safe initial fallback, start off using / as our only root directory
		// /Users/Shared/MySyncExtension Documents
		finderController.directoryURLs = [ URL(fileURLWithPath: "/") ]
		
		
		
        FIFinderSyncController.default().setBadgeImage(defaultImageIcon,
													   label: "Status One" ,
													   forBadgeIdentifier: "One")
//        FIFinderSyncController.default().setBadgeImage(NSImage(named: NSImage.cautionName)!, label: "Status Two", forBadgeIdentifier: "Two")
		_ = VolumeManager.shared
		
		
		
		// set up our notification observer
		NotificationCenter.default.addObserver(forName: VolumeManager.VolumesDidChangeNotification,
											   object: nil,
											   queue: OperationQueue.current!)
		{ (notification) in
			// set ourselves as “watching” everything by setting each volume as our root
//            if letnil
            self.finderController.directoryURLs = Set(notification.object as? [URL] ?? [ URL(fileURLWithPath: "/") ])
//            print("notiifcation post success")
		}
	}

	override var toolbarItemName: String{
			return "AUY"
		}
		override var toolbarItemImage: NSImage{
			return defaultImageIcon
		}
		override var toolbarItemToolTip: String {
			return "剪切板自动上传云盘"
		}
		override func menu(for menu: FIMenuKind) -> NSMenu {
			let ment = NSMenu(title: "")
			
			let uploadImage = ment.addItem(withTitle: "上传",
										   action: #selector(uploadYun(_:)),
										   keyEquivalent: "")
			uploadImage.target = self
			uploadImage.image =  defaultImageIcon
			return ment
		}
		override func beginObservingDirectory(at url: URL) {
//			VolumeManager.shared.updateVolumes()
			#if DEBUG
			print("start\(url.path):")
			#endif
		}
		override func endObservingDirectory(at url: URL) {
			#if DEBUG
			print("end url:\(url.path)")
			#endif
		}
	//切换文件夹 回调
		override func requestBadgeIdentifier(for url: URL) {
			
			let joinsType = ["png","jpg","jpeg","pdf","gif"]
			if joinsType.contains(url.pathExtension) {
				let badgeIdentifier = "One"//为每一行符合要求文件设置 icon
				FIFinderSyncController.default().setBadgeIdentifier(badgeIdentifier,
				for: url)
				print(url.pathExtension)
			}
		}
}
extension FinderSync{
    @objc func uploadYun(_ sender:AnyObject?) {
		print("uploadYun click")
		
		let target = FIFinderSyncController.default().targetedURL()
		   let items = FIFinderSyncController.default().selectedItemURLs()
		   var files:[String] = Array()
		if items?.count == 0 {
			FYNotification.share().pushError(msg: "请选择文件哦")
		}else{
			let item = sender as! NSMenuItem
			NSLog("item: %@, target = %@, items = ", item.title as NSString, target!.path as NSString)
            
            let types = ["mp4","png","gif","jpg","jpeg","bitmap","HEIC","HEIF"]
            
			for obj in items! {
				print("选中文件路径: \(obj.absoluteString)")
                if types.contains(obj.pathExtension){
                    files.append(obj.absoluteString)
                }
			}
			
//			if files.count > 0{
//				uploadImage(urls: files)
//			}else{
//				FYNotification.share().pushError(msg: "请选择正确文件格式哦")
//			}
		}
		uploadImage(urls: files)
	}
    func uploadImage(urls:[String]) -> Void {
//		postMsgFinal(urls);
	}
}
