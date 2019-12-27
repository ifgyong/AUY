//
//  FYAboutView.swift
//  AUY
//
//  Created by Charlie on 2019/12/26.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

class FYAboutView: NSView {
//	let vc = FYAboutMeVC(nibName: "FYAboutMeVC", bundle: nil)
	var copyRight: NSTextField = NSTextField()
	var verIfnoLabel: NSTextField = NSTextField()
	var subIfnoLabel: NSTextField = NSTextField()

	
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
	func config() -> Void{
		let bundle = Bundle.main.infoDictionary!
				// CFBundleDisplayName
				//NSHumanReadableCopyright
				// CFBundleShortVersionString
		//		CFBundleVersion
				
				guard let id = bundle["CFBundleShortVersionString"],
					let version = bundle["CFBundleVersion"],let copy = bundle["NSHumanReadableCopyright"] else {
						return;
				}

		copyRight.textColor = NSColor.init(white: 0, alpha: 0.6)
		copyRight.frame = NSRect(x: 0, y: 10, width: 600, height: 20)
		copyRight.alignment = .center
		copyRight.isBordered = false
		copyRight.backgroundColor = nil
		copyRight.stringValue = copy as! String

		self.addSubview(copyRight)
		
		verIfnoLabel.textColor = NSColor.black
		verIfnoLabel.frame = NSRect(x: 0, y: 191, width: 600, height: 37)
		verIfnoLabel.alignment = .center
		verIfnoLabel.isBordered = false
		verIfnoLabel.backgroundColor = nil
		verIfnoLabel.font = NSFont.systemFont(ofSize: 31)
		self.addSubview(verIfnoLabel)
		verIfnoLabel.stringValue = "AUY"
		//subIfnoLabel
		subIfnoLabel.textColor = NSColor.init(white: 0, alpha: 0.6)
		subIfnoLabel.frame = NSRect(x: 0, y: 163, width: 600, height: 26)
		subIfnoLabel.alignment = .center
		subIfnoLabel.isBordered = false
		subIfnoLabel.backgroundColor = nil
		subIfnoLabel.font = NSFont.systemFont(ofSize: 22)
		subIfnoLabel.stringValue = "Version \(id as! String) build \(version as! String)"
		self.addSubview(subIfnoLabel)
		
		
		let btn = NSButton(title: "使用帮助", target: self, action: #selector(help))
		btn.frame = NSRect(x: 250, y: 30, width: 100, height: 30)
		self.addSubview(btn)
	}
	@objc func help() -> Void {
        NSWorkspace.shared.open(URL(string: URLCategory.commentOpenURL)!)
	}
 
	
}
