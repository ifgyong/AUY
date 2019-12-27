//
//  FYSettingWindow2.swift
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/16.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

class FYSettingWindow: NSWindow,NSToolbarDelegate {
		
	
	var tool = NSToolbar(identifier: .init("toolbar"))
	var toolbarIdentifierArray:[NSToolbarItem.Identifier] = [NSToolbar.setting,NSToolbar.about]
	let aboutView = FYAboutView()
	var vcs :[NSToolbarItem.Identifier:NSView] = [NSToolbarItem.Identifier:NSView]()//
	func setup() -> Void {
		vcs[NSToolbar.setting] = FYSettingView()
		vcs[NSToolbar.about] = aboutView
		
		aboutView.config()
		self.hidesOnDeactivate = false
		tool.delegate = self
		self.toolbar = self.tool
		self.setFrame(RectCatory.kWindowSettingRect,
					  display: true)
		tool.selectedItemIdentifier = NSToolbar.setting ///默认选中 设置页面
		loadView(iden: NSToolbar.setting)
		self.isReleasedWhenClosed = false
		
		(vcs[NSToolbar.setting] as! FYSettingView) .configUI()
		
	}
	
	func loadView(iden:NSToolbarItem.Identifier){
		switch iden {
		case NSToolbar.about:
			let vc = vcs[iden]
			self.contentView = vc
		case NSToolbar.setting:
			let vc = vcs[iden] as! FYSettingView
//			vc.configUI()
			self.contentView = vc
		default: break
		}
		self.title = iden.rawValue
	}
	
	@objc func click0() -> Void {
		loadView(iden: NSToolbar.setting)
	}
	@objc func click1() -> Void {
		loadView(iden: NSToolbar.about)
	}
	
	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return self.toolbarDefaultItemIdentifiers(toolbar)
	}
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return toolbarIdentifierArray
	}
	func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		return self.toolbarDefaultItemIdentifiers(toolbar)
	}
	func toolbarWillAddItem(_ notification: Notification) {
		print("toolbarWillAddItem")
	}
	private func toolbarDidRemoveItem(notification: NSNotification)
	{
		print("toolbarDidRemoveItem")
	}
	
	
	func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		switch itemIdentifier {
		case NSToolbar.about:
			
			let item0 = NSToolbarItem(itemIdentifier: itemIdentifier)
			item0.action = #selector(click1)
			item0.image = NSImage(named: NSImage.infoName) //NSImage(named: "about")
			item0.target = self
			item0.toolTip = "关于"
			item0.label = "关于"
			item0.tag = 1;
			return item0
		case NSToolbar.setting:
			let item1 = NSToolbarItem(itemIdentifier: itemIdentifier)
			item1.action = #selector(click0)
			item1.image = NSImage(named: NSImage.advancedName)// NSActionTemplate
			item1.toolTip = "设置"
			item1.label = "设置"
			item1.target = self
			item1.tag = 0
			return item1
		default: break
			
		}
		return nil
	}
	deinit {
		print("window \(self) deinit")
	}
}
