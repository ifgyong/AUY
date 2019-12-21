//
//  FYImageCell.swift
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/13.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

class FYImageCell: NSView {
typealias delClo = (NSInteger)->Void
	public lazy var imageView:NSImageView = {
		var imageV = NSImageView()
		imageV.imageAlignment = .alignCenter
		imageV.imageScaling = .scaleProportionallyUpOrDown//按照高地缩小
		imageV.frame = NSRect(x: 49, y: 5, width: 390, height: 80)
        imageV.isEditable = true
		return imageV
	}()
	
	public lazy var delBtn :NSButton = {
		var del = NSButton(image: NSImage(named: "del")!,
						   target: self,
						   action: #selector(del(_:)))
		
		return del
	}()
	public var delComplate: delClo
	
	
	init( delComplate:@escaping delClo) {
		self.delComplate = delComplate
		super.init(frame: NSRect())
		
	}
	func bundsChange() -> Void {
		var bund = self.bounds
		bund.origin.x = 49
		bund.origin.y = 5
		bund.size.width = bund.size.width - 49 - 10
		bund.size.height = bund.size.height - 10
		imageView.frame = bund
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func del(_ item:NSButton) -> Void{
		delComplate(item.tag)
	}
	
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
		bundsChange()
        // Drawing code here.
    }
	func addImage() -> Void {
		self.delBtn.frame = NSRect(x: 3, y: 25, width: 60, height: 60)
		self.addSubview(delBtn)
		self.addSubview(imageView)
		
//		imageView.image = NSImage(named: "back")
	}
	
}
extension NSView{
	public func setBackground(color:NSColor?){
		self.wantsLayer = true
		self.layer?.backgroundColor = color?.cgColor
	}
}
