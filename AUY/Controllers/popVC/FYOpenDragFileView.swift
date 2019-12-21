//
//  FYOpenDragFileView.swift
//  AUY
//
//  Created by Charlie on 2019/12/18.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

protocol FYOpenDragFileProtocol : NSObjectProtocol {
	func fileDraging()
	func fileDragEnd()
}

class FYOpenDragFileView: NSView {
	var isDraging:Bool = false;
	weak var delegate : FYOpenDragFileProtocol?
	
	
	var label:NSText = NSText(frame: NSRect(x: 0, y: 17, width: 170, height: 17))
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
		self .registerForDraggedTypes([.fileURL])
		
		NSColor.clear.set()
		dirtyRect.fill()
    }
	func setUp(){
//		拖至此处上传图床
		self.addSubview(label)
		setupWithActive(active: false)
		
		self.wantsLayer = true
		self.layer?.backgroundColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
	}
	func setupWithActive(active:Bool) ->Void{
		if active {
//			let an = NSAnimation.init(duration: 0.25, animationCurve: .easeIn)
			label.string = "松手开始上传图床";
			label.font = NSFont.boldSystemFont(ofSize: 17);
			// 27 167 242
			label.textColor = NSColor.init(calibratedRed: 27.0/255.0, green: 167.0/255.0, blue: 242.0/255.0, alpha: 1)
		}else{
			label.textColor = NSColor.white
			label.alignment = .center
			label.string = "拖至此处上传图床"
			label.isEditable = false
			label.backgroundColor = .clear
			label.font = NSFont.systemFont(ofSize: 15)
		}
	}
	override func draggingEnded(_ sender: NSDraggingInfo) {
		print("松手了")
		setupWithActive(active: false)
	}
	// 进入当前view
	override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
		isDraging = true
		setupWithActive(active: true)
//		let mask = sender.draggingSourceOperationMask
//		let cp = sender.draggingFormation
		
		
		return .copy
	}
	// 拖动结束
	override func draggingExited(_ sender: NSDraggingInfo?) {
		isDraging = false
		setupWithActive(active: false)
		print("draggingExited 进去又出来")
	}
	override func updateDraggingItemsForDrag(_ sender: NSDraggingInfo?) {
		guard let next = delegate else {
			return;
		}
		next.fileDraging()
		print("更新拖动文件")
	}
	override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
		
		guard let items = sender.draggingPasteboard.pasteboardItems else{
			return false
		}
		var datas = [Data]()
		for i in 0..<items.count{
			
			
			let item = items[i] .string(forType: .fileURL)
//			if item.types.contains([NSPasteboard.PasteboardType.fileURL]) {
//			}
			if item != nil {
                let url = URL(string: item!)!
                let da = try? Data(contentsOf : url)
				guard let next = da else {
					continue
				}
				datas.append(next)
			}
		}
		QiniuUploadManger.uploadImage(nil, data: datas)
		return true
	}
	
	
	
}
