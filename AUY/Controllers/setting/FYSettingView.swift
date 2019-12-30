//
//  FYSettingView.swift
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/16.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

import Carbon
import CoreServices
import Foundation

class FYSettingView: NSView {
	
	typealias T = NSTextField
	
	
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
	var btn :NSButton = NSButton()
	var buckNameTextfile:T?
	var yumingTextfile:T?
	var accessKeyTextfile:T?
	var secretKeyTextfile:T?
	var regionNameTextfile:T?

	var accessKey:NSText?
	var secretKey:NSText?
	var selectedMenu:NSComboBox?
    
	var menuSelected:UploadType = .Unknow

	var tencentView:NSView = NSView()
	
	
	func configUI() {
		menuSelected = UserDefaults.standard.getUploadType()
		btn.target = self
		let width = self.frame.size.width - 200
		btn.frame = NSRect(x: 100, y: 20, width: width, height: 21)
		btn.title = "问题反馈"
		btn.action = #selector(openURL(_:))
		btn.bezelStyle = .rounded
		self.addSubview(btn)
		
		let saveBtn = NSButton(frame: CGRect(x: 100, y: 50, width: width, height: 21))
		saveBtn.target = self
		saveBtn.title = "保存配置"
		saveBtn.action = #selector(saveKeys)
		saveBtn.bezelStyle = .rounded
		self.addSubview(saveBtn)
		
		selectedMenu = NSComboBox(frame: CGRect(x: 20, y: 265, width: 85, height: 24))
//		selectedMenu
		selectedMenu!.addItem(withObjectValue: "七牛云")
		selectedMenu!.addItem(withObjectValue: "阿里云")
		selectedMenu!.addItem(withObjectValue: "腾讯云")
		selectedMenu!.addItem(withObjectValue: "又拍云")

		self.addSubview(selectedMenu!)
		let defaultSelIndex = UserDefaults.standard.getUploadType()
		selectedMenu?.selectItem(at: defaultSelIndex.raw())//默认七牛云
		selectedMenu!.delegate = self
		selectedMenu!.isEditable = false
		let y = 225
		let height = 30
		let labelyuming = getLabel(text: "域名:", y: y)
		self.addSubview(labelyuming)
		yumingTextfile = getTextField(placeholder: "栗子:http://blog.fgyong.cn", y: y)
		self.addSubview(yumingTextfile!)
		
		var accessKeyStr = "accessKey"
		if defaultSelIndex == .Tencent {
			accessKeyStr = "secretId"
		}
		accessKey = getLabel(text: "\(accessKeyStr):", y: y - height*1)
		self.addSubview(accessKey!)
		
		accessKeyTextfile = getTextField(placeholder: "\(accessKeyStr)", y: y - height*1)
		self.addSubview(accessKeyTextfile!)
		
		secretKey = getLabel(text: "secretKey:", y: y - height*2)
		self.addSubview(secretKey!)
		secretKeyTextfile = getTextField(placeholder: "secretKey", y: y - height*2)
		self.addSubview(secretKeyTextfile!)
		
		let buckName = getLabel(text: "buckName:", y: y - height*3)
		self.addSubview(buckName)
		buckNameTextfile = getTextField(placeholder: "栗子：fgyong", y: y - height*3)
		self.addSubview(buckNameTextfile!)
		
		//regionName
		tencentView.frame = NSRect(x: 0, y: y - height*5, width: 600, height: height * 2)
		let regionName = getLabel(text: "regionName:", y: height)
		tencentView.addSubview(regionName)
		regionNameTextfile = getTextField(placeholder: "栗子：ap-shanghai", y: height)
		tencentView.addSubview(regionNameTextfile!)
		self.addSubview(tencentView)
		
		if menuSelected != .Tencent {
			tencentView.isHidden = true
		}else{
			regionNameTextfile?.stringValue = QNModel.getSave().regName
		}
		
		setConfig(ty: menuSelected)//设置提示文字
		
		loadDataFromCache()
	}
	// MARK: 根据不同图床配置不同提示文字
	func setConfig(ty:UploadType) -> Void{
		tencentView.isHidden = true
		switch ty {
		case .UPYun:
			accessKey?.string = "操作员"
			accessKeyTextfile?.placeholderString = "操作员"
			secretKey?.string = "密码"
			secretKeyTextfile?.placeholderString = "32位密码"
		case .Tencent:
			tencentView.isHidden = false
			accessKey?.string = "secretId"
			accessKeyTextfile?.placeholderString = "secretId"
		default:
			secretKey?.string = "secretKey"
			secretKeyTextfile?.placeholderString = "secretKey"
			accessKey?.string = "accessKey"
			accessKeyTextfile?.placeholderString = "accessKey"
		}
	}
	
	func loadDataFromCache() -> Void {
//		selectedMenu?.delegate = self
		let ty = UserDefaults.standard.getUploadType().raw()
		selectedMenu?.selectItem(at: ty)
		let model =  QNModel.getSave()
		
		if model.accessKey.count  > 0{
			yumingTextfile?.stringValue = model.yuming
		    accessKeyTextfile?.stringValue = model.accessKey
		    secretKeyTextfile?.stringValue = model.secretKey
		    buckNameTextfile?.stringValue = model.buckName
		}
		
	}
	func getLabel(text:String,y:Int) -> NSText {
		let textLabel = NSText(frame: CGRect(x: 20, y: y, width: 87, height: 16))
		textLabel.backgroundColor = NSColor.defaultBackGroundColor
		textLabel.alignment = .right
		textLabel.string = text
		textLabel.isEditable = false
		return textLabel
	}
	
	func getTextField(placeholder:String,y:Int) -> T {
		let textLabel = T(frame: CGRect(x: 110, y: y-2, width: 460, height: 20))
		textLabel.alignment = .left
		textLabel.placeholderString = placeholder
		textLabel.isEditable = true
		textLabel.delegate = self
        textLabel.maximumNumberOfLines = 1
		return textLabel
	}
	// MARK: 取消输入状态
	override func touchesBegan(with event: NSEvent) {
		self.window?.endEditing(for: nil)
	}

	
	
	@objc func openURL(_ sender: NSButton) {
		NSWorkspace.shared.open(URL(string: URLCategory.commentOpenURL)!)
	}
	@objc func saveKeys(){
		self.window?.endEditing(for: nil)
		if checkInput() {
			let text = Bundle.main.url(forResource: "test.png", withExtension: nil)!
			let da = try? Data(contentsOf: text)
			menuSelected = UploadType.raw(selectedMenu!.indexOfSelectedItem)
		
			let model = QNModel()
			
			
			if menuSelected == .Tencent {
				model.regName = regionNameTextfile!.stringValue
			}
			model.accessKey = accessKeyTextfile!.stringValue
			model.secretKey = secretKeyTextfile!.stringValue
			model.buckName = buckNameTextfile!.stringValue
			model.yuming = yumingTextfile!.stringValue
			
			guard let data = da else{
				return;
			}
			if menuSelected == .Unknow {
				#if DEBUG
				print("未知选项")
				#endif
			}else{
				
				RequestConfig.config[menuSelected]?.uploadTestAsync(data,
																	model: model,
																	complate: { (url) in
					print(url)
					QNModel.save(model)
					
					UserDefaults.standard.setUploadType(ty: self.menuSelected)
					NSAlert.show(msg: "配置成功",window: self.window!)
				}) { (error) in
					NSAlert.show(msg: "配置失败,请确认秘钥是否正确",window: self.window!)
					print("error:\(error)")
				}
			}
		}
	}
	func checkInput()->Bool{
		if selectedMenu!.indexOfSelectedItem == -1 {
            NSAlert.show(msg: "请选择图床平台",window: self.window!)
			return false
		}else if (yumingTextfile?.stringValue ?? "").count == 0{
            NSAlert.show(msg: "请填写域名",window: self.window!)
			return false
		}else if (accessKeyTextfile?.stringValue ?? "").count == 0{
			if UserDefaults.standard.getUploadType() == .Tencent {
				NSAlert.show(msg: "请填写secretId",window: self.window!)
			}else{
				NSAlert.show(msg: "请填写accessKey",window: self.window!)
			}
			return false
		}else if (secretKeyTextfile?.stringValue ?? "").count == 0{
            NSAlert.show(msg: "请填写secretKey",window: self.window!)
			return false
		}else if (buckNameTextfile?.stringValue ?? "").count == 0{
            NSAlert.show(msg: "请填写buckName",window: self.window!)
			return false
		}
		return true
	}
}
extension FYSettingView : NSTextFieldDelegate,NSTextViewDelegate{
	
	override func keyUp(with event: NSEvent) {
//		print(event)
	}
	override func keyDown(with event: NSEvent) {
//		print(event)
	}
	//
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        print(commandSelector.description)
        let sel = Selector(("noop:"))
        if commandSelector == sel {
            guard let str = NSPasteboard.general.string(forType: .string)else{
                return true
            }
            textView.string = textView.string + str
        }else if commandSelector == #selector(NSStandardKeyBindingResponding.moveLeft(_:)){
            let location = textView.selectedRange().location
            if location > 0 {
                textView.setSelectedRange(NSRange(location: location-1, length: 0))
            }
        }//moveRight:
        else if commandSelector == #selector(NSStandardKeyBindingResponding.moveRight(_:)){
            let location = textView.selectedRange().location
            if location < textView.string.count {
                textView.setSelectedRange(NSRange(location: location+1, length: 0))
            }
        }else if commandSelector == #selector(NSStandardKeyBindingResponding.deleteBackward(_:)){
            let location = textView.selectedRange().location
            let width = textView.selectedRange().length
            let str = textView.string as NSString
            if location >= 0 {
				let tarLoc = location > 0 ?location-1:0
                if width == 0 {
                    textView.string = str.substring(to: tarLoc) + str.substring(from: location)
                }else if  width > 0{
                    textView.string = str.substring(to: tarLoc) + str.substring(from: location+width)
                }
                textView.setSelectedRange(NSRange(location: tarLoc, length: 0))
                if width == textView.string.count {
                    textView.string = ""
                    textView.setSelectedRange(NSRange(location: 0, length: 0))
                }
			}
        }
		else if commandSelector == #selector(NSStandardKeyBindingResponding.insertNewline(_:)){
			self.window?.endEditing(for: nil)
			return false
		}
        return true
    }
}
extension FYSettingView :NSComboBoxDelegate{
	func comboBoxSelectionDidChange(_ notification: Notification) {
		let box = notification.object as! NSComboBox
		print(box.indexOfSelectedItem)
		setConfig(ty: UploadType.raw(box.indexOfSelectedItem))
	}
}
