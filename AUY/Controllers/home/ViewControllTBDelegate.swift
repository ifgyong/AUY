//
//  ViewControllTBDelegate.swift
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/16.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

/// 首页tb的代理
class ViewControllTBDelegate: NSObject,NSTableViewDataSource,NSTableViewDelegate {
	var dataArray: [URL]{
		didSet{
			reload()
		}
	};
	typealias ComplateTBClo = ()->Void
	typealias FreshDataArrayClo = ([URL])->Void
	var tb :NSTableView 
	var complate :ComplateTBClo?
	var freshData:FreshDataArrayClo?
	
	
	init(dbArray:[URL],tbsub:NSTableView,frushBlock:ComplateTBClo?,fresh:FreshDataArrayClo?) {
		freshData = fresh
		dataArray = dbArray
		tb = tbsub
		complate = frushBlock
		super.init()
	}
	func reload() -> Void{
		tb.reloadData()
		if complate != nil {
			complate!()
		}
	}
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		var view = tableView.makeView(withIdentifier: .init("cell1"), owner: self)
		if view==nil {
			view = FYImageCell(delComplate: { (index) in
				if self.dataArray.count >= row{
					self.dataArray.remove(at: row)
					self.reload()
				}
			})
			view?.identifier = .init("cell1")
			(view as! FYImageCell).addImage()
			
		}else{
			(view as! FYImageCell).delComplate = { (index) in
				if self.dataArray.count >= row{
					self.dataArray.remove(at: row)
					
					self.reload()
				}
			}
		}
		
		let da = try? Data(contentsOf: URL(string: self.dataArray[row].absoluteString)!)
		guard let subData = da else {
			return view
		}
		(view as! FYImageCell).imageView.image = NSImage(data: subData)
		(view as! FYImageCell).delBtn.tag = row
		return view
	}
	func numberOfRows(in tableView: NSTableView) -> Int {
		return self.dataArray.count
	}
	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 90
	}
	func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool{
		return false
	}
	func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
		return true
	}
	func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
		return true
	}
}
