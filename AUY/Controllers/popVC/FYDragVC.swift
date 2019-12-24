//
//  FYDragVC.swift
//  AUY
//
//  Created by Charlie on 2019/12/24.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

/// 弃用
class FYDragVC: NSViewController {

	let view2 = FYDragView()
	override func viewDidLoad() {
		super.viewDidLoad()
		view.wantsLayer = true
		if #available(OSX 10.15, *) {
			view.layer?.backgroundColor = CGColor(srgbRed: 0.5, green: 1, blue: 1, alpha: 1)
		} else {
			// Fallback on earlier versions
			view.layer?.backgroundColor = CGColor(red: 0.5, green: 1, blue: 1, alpha: 1);

		};
		view2.frame = NSRect(x: 0, y: 0, width: 200, height: 200)
	
		view.addSubview(view2)
		view2.config()
	}
    
}
