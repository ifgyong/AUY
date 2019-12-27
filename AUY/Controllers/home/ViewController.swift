//
//  ViewController.swift
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/6.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa
import FinderSync
import Foundation
import SwiftUI
import UserNotifications



class ViewController: NSViewController,NSXPCListenerDelegate,NSWindowDelegate {
	
 /// MARK delegate
	
	func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
		return (NSApplication.shared.keyWindow?.contentView?.bounds.size)!
	}

	@IBOutlet weak var noDataLabel: NSTextField!
	@IBOutlet weak var zoomNumberTextField: NSTextField!
    @IBOutlet weak var fpsTextField: NSTextField!
	
	
    var dataArray = [URL]()
	func reload() -> Void {
		noDataLabel.isHidden = dataArray.count > 0 ? true:false
		self.tableView.reloadData()
	}

	
 
	@IBOutlet weak var tableView: NSTableView!
	var tbDelegate:ViewControllTBDelegate?
	
	static let VolumesDidChangeNotification = Notification.Name(rawValue: "VolumeManagerVolumesDidChangeNotification")
	@IBOutlet weak var desc: NSTextField!
	
	@IBAction func clearImags(_ sender: NSButton) {
        print ("clearImags")
        self.dataArray.removeAll()
        self.reload()
    }
	
	@IBAction func uploadFiles(_ sender: NSButton) {
		
		
	}
	@IBAction func importFIles(_ sender: NSButton) {
		let onPanel = NSOpenPanel.init()//打开文件
		onPanel.canChooseFiles = true
		onPanel.canChooseDirectories = false
		onPanel.canCreateDirectories = true
		onPanel.allowsMultipleSelection = true//多选
        onPanel.allowedFileTypes = ["png","gif","jpg","HEIC","HEIF","jpeg"]
		if onPanel.runModal() == .OK {
			let url = onPanel.urls
			for i in 0..<url.count{
				self.dataArray.append(url[i])
			}
			tbDelegate?.dataArray = self.dataArray
			print(onPanel.urls[0].absoluteURL.absoluteString)
		}
		
    }
	func urlToDatas(_ url:[String]) -> [Data] {
		var datas = [Data]()
		for i in 0..<url.count{
			let da = try? Data(contentsOf: URL(string: url[i])!)
			guard let dd = da else {
				continue
			}
			datas.append(dd)
		}
		return datas;
	}
    override func viewDidLoad() {
        super.viewDidLoad()
		setup()
    }
    
    //  MARK:  展示下个页面
    @IBAction func pushNextPageAndCreateIF(_ sender: NSButton) {
        
		self.view.window?.endEditing(for: nil)
		
        if fpsTextField.stringValue.count == 0 {
            fpsTextField.stringValue = String(fpsDefault)
        }
        if zoomNumberTextField.stringValue.count == 0 {
            zoomNumberTextField.stringValue = String(zoomDefault)
        }
        guard let fps = Double(fpsTextField.stringValue),
                           let zoom = Double(zoomNumberTextField.stringValue) else{
                            return;
        }
        let url = getGIFURL(fps: fps,zm:zoom)
        if url.have {
            let newURL = url.0!
            let vc = PreVC(nibName: "PreVC", bundle: nil)
            var imagesArray = [NSImage]()
            for i in 0..<self.dataArray.count{
                let im = NSImage(contentsOf: self.dataArray[i])!
                imagesArray.append(im)
            }

            let p = PreGIfModel(f: fps, images: imagesArray,loopInt: 1,zm: zoom)
            vc.model = p
            vc.url = newURL
            self.presentAsSheet(vc)
        }
    }
    func getGIFURL(fps:Double,zm:Double) -> (URL?,have:Bool) {
                if self.dataArray.count == 0 {
                    FYNotification.share().pushError(msg: "图片为选择哦")
                    return (nil,false)
                }else{
                    var datas = [NSImage]()
                    for i in 0..<self.dataArray.count {
                        let imag = NSImage(contentsOf: self.dataArray[i])!
                        datas.append(imag)
                    }
                    
               
                    
                    let url = self.compositionImage(self.dataArray, "demo",
                                                    fps: fps,
                                          loop: 1,
                                          zoom: zm)
                    return (url,true)
                }
    }
    
    /// MARK 初始化
	func setup() -> Void {
		
		
		NotificationCenter.default.addObserver(self,
											   selector: #selector(fileChange(obj:)),
											   name: NSNotification.Name(rawValue: kVCDidReceivedMsgNotificationName),
											   object: nil)
		tbDelegate = ViewControllTBDelegate(dbArray: self.dataArray, tbsub: tableView, frushBlock: {
			self.noDataLabel.isHidden = self.dataArray.count > 0 ? true :false

		}, fresh: { (data) in
			self.dataArray = data
		});
		tableView.delegate = tbDelegate
		tableView.dataSource = tbDelegate
		NotificationCenter.default.addObserver(self,
											   selector: #selector(NSWindowDidChagne(obj:)),
											   name: NSWindow.didResizeNotification,
											   object: nil)
        
	}
	@objc func NSWindowDidChagne(obj:Notification){
//		let frame = (obj.object as! NSWindow).contentView?.frame
//		guard let ff = frame else {
//			return
//		}
//		print(ff)
//		if ff.size.height < 100 {//过滤tabbar
//			return
//		}
//		DataSettingCenter.default().windowSize = ff
	}
	
	@objc func fileChange(obj:Notification){
        let fullURLs :[String] = obj.userInfo?["files"] as? Array<String> ?? [String]()
        var datas = [Data]()
         for i in 0..<fullURLs.count{
            let url = fullURLs[i]
            let da = try? Data(contentsOf: URL(string: url)!)
             guard let dd = da else {
                 continue
             }
             datas.append(dd)
         }
		if datas.count == 0 {
			FYNotification.share().pushError(msg: "请选中文件哦😯！")
			return;
		}
		
//        QiniuUploadManger.uploadImage(nil,data: datas)
//		DispatchQueue.main.async {[weak self]in
////            self?.label.stringValue = obj.userInfo?["url"] as? String ?? "无 file"
//		}
	}
	var  index = 0
	func test() -> Void {
		index += 1
	}

}
