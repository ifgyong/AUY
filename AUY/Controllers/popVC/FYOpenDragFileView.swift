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

class FYOpenDragFileView: NSImageView {
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
//        if isDraging {
//            upload(sender: sender)
//        }
	}
	// 进入当前view
	override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
		isDraging = true
		setupWithActive(active: true)
//        let op = NSDragOperation.copy
		
        return [.copy]
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
		print("稍后复制data to app")
//        let pasted = sender.draggingPasteboard
        upload(sender: sender);
		return true
	}
    // MARK: clean up data
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        if sender != nil{
//            upload(sender: sender!)
        }
    }
    func upload(sender:NSDraggingInfo? ) -> Void{
        guard let sender2 = sender else {
            return;
        }
        guard let items = sender2.draggingPasteboard.propertyList(forType: .fileURL) else{
                    return
                }
        var datas = [Data]()
        let itemArr =  items as? String
        guard let itemNext = itemArr else {
            return
        }
        let url = URL(string: itemNext)!
        let data = try? Data(contentsOf : url)
        guard let next = data else {
            return
        }
        datas.append(next)
		QiniuUploadManger.uploadImage(nil, data: datas)
    }
	
	
}
