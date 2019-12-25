//
//  FYAboutMeVC.swift
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/16.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

class FYAboutMeVC: NSViewController {

	@IBOutlet weak var copyRight: NSTextField!
	@IBOutlet weak var verIfnoLabel: NSTextField!
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		let bundle = Bundle.main.infoDictionary!
		// CFBundleDisplayName
		//NSHumanReadableCopyright
		// CFBundleShortVersionString
//		CFBundleVersion
		
		guard let id = bundle["CFBundleShortVersionString"],
			let version = bundle["CFBundleVersion"],let copy = bundle["NSHumanReadableCopyright"] else {
				return;
		}
		copyRight.stringValue = copy as! String
		verIfnoLabel.stringValue = "Version \(id as! String) build \(version as! String)"
//		print(bundle)
    }
    
    @IBAction func openURL(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: URLCategory.commentOpenURL)!)

    }
}
