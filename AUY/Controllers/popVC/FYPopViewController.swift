//
//  FYPopViewController.swift
//  AUY
//
//  Created by Charlie on 2019/12/18.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

class FYPopViewController: NSViewController {

	let viewsub = FYOpenDragFileView(frame: NSRect(x: 0, y: 0, width: 170, height: 50))
    override func viewDidLoad() {
        super.viewDidLoad()
		view.wantsLayer = true
		view.layer?.backgroundColor = CGColor(gray: 0.6, alpha: 0.2)
		
		viewsub.setUp()
		view.addSubview(viewsub)
    }
	override func viewWillAppear() {
		viewsub .setupWithActive(active: false)
	}
	
}
