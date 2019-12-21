//
//  PreVC.swift
//  MToGifAndUpload
//
//  Created by fgy on 2019/12/14.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa
import Foundation


class PreVC: NSViewController,NSWindowDelegate {
    var url:URL = URL(string: "file:/")!
    var model:PreGIfModel?
    
    @IBOutlet weak var imageV: NSImageView!
    

    
    @IBAction func upLoad(_ sender: Any) {
        save(sender)//先保存
        
    }
    
    @IBAction func save(_ sender: Any) {
        let savePen = NSSavePanel()
        savePen.allowedFileTypes=["GIF"]
        savePen.nameFieldStringValue = "动画"
        savePen.canCreateDirectories = true
        savePen.canSelectHiddenExtension = false
        savePen.prompt = "保存"
        savePen.message = "选择动图保存地址"
        savePen.title = "保存图片"
        savePen.isExtensionHidden = false
        savePen.showsTagField = true
        if savePen.runModal() == .OK{
            guard let name = savePen.url else {
                return
            }
            let imgData = getDataFromUrl(ur: url)
            if ((try? imgData?.write(to: name)) != nil){
                FYNotification.share().push(successMsg: "保存成功😁")
            }else{
                FYNotification.share().pushError(msg: "保存失败😢！")
            }
        }
    }
    
    func getDataFromUrl(ur:URL) -> Data? {
        let data = try? Data(contentsOf: ur)
        return data
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageV.setBackground(color: NSColor.white)
        self.title = "预览"
        let da = try? Data(contentsOf: url)
        imageV.image =  NSImage(data: da!)
		setUp()
    }
	func setUp(){
//		DataSettingCenter.default().setwindowSizeDidChange { [weak self] (size) in
//			if size.width > 700{
//				self?.view.frame = size
//				self?.view.layout()
//			}
//			
//			print("sub:\(size)")
//		}
	}

    @IBAction func pop(_ sender: Any) {
        self.dismiss(sender)
    }
	
}
