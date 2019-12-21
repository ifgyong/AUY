//
//  AppDelegate.swift
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/6.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    static let NotifiCationName = "didlounchwithkyes"
	
	@IBOutlet weak var statusMenu: NSMenu!
	let statusItem = NSStatusBar.system.statusItem(withLength: 40)
	var popIsShow = false
	var viewFromPop :NSView? //
    var changeCount =  0//上次拖动计数
	// icon 状态栏显示
	var popover :NSPopover?
// MARK: 打开设置界面
	@IBAction func openSettingWindow(_ sender: NSMenuItem) {
		let wn = FYSettingWindow(contentRect: RectCatory.kWindowSettingRect,
								 styleMask: [.titled,.closable],
								 backing: .buffered,
								 defer: false)
		wn.setup()
		let wc = NSWindowController(window: wn)
		wc.showWindow(nil)
	}

	func addEventLisen(){
		
		// MARK: 监听鼠标 文件移动
		let _ = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged) { (ev) in
            let pb = NSPasteboard.init(name: .drag)
            let numsDic = pb.propertyList(forType: .fileURL)
            
            if  numsDic != nil && self.changeCount != pb.changeCount{
                self.changeCount = pb.changeCount
                    self.showPopVC()
            }
		}
		
		
		let _ = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseUp) { (ev) in
			self.closePopVC()
		}
		
//		let _ = NSEvent.addLocalMonitorForEvents(matching: .leftMouseDragged, handler: { (ev) -> NSEvent? in
//			print(ev)
//			return ev
//		})
	}
	func setupPopVC(){
		if popover == nil {
			popover = NSPopover()
			let vc = FYPopViewController(nibName: "FYPopViewController", bundle: nil)
			vc.viewsub.delegate = self
			popover?.contentViewController = vc
			self.popover?.behavior = .transient
			self.popover?.delegate = self
		}
	}
	func closePopVC() -> Void {
		self.popIsShow = false
		self.popover?.close()
	}
	// MARK: 显示popVC
	func showPopVC(){
		self.popIsShow  = true
		guard let vc = viewFromPop else {
			let views = NSApp.windows
			for i in views {
				if i.isKind(of: NSClassFromString("NSStatusBarWindow")!) {
					viewFromPop = i.contentView
					break
				}
			}
			
			self.popover?.show(relativeTo: .zero,
							   of: (viewFromPop!),
							   preferredEdge: NSRectEdge.maxY)
			return
		}
		self.popover?.show(relativeTo: .zero,
						   of: (vc),
						   preferredEdge: NSRectEdge.maxY)
		
	}
	@IBAction func openPopVC(_ sender: NSMenuItem) {
		self.popIsShow = !self.popIsShow
		if self.popIsShow {
			showPopVC()
		}else{
			self.popover?.close()
		}
	}
	@IBAction func killSelf(_ sender: NSMenuItem) {
		kill()
	}
	func setupMenuItem() -> Void {
		statusItem.menu = statusMenu
		statusItem.button?.image = NSImage(named: "statusicon")
	}
	@IBAction func uploadImageFromPase(_ sender: NSMenuItem) {
		QiniuUploadManger.uploadPasetedImage()
	}
	/// 获取剪切板历史记录的最后一条
	@IBAction func copyURL(_ sender: NSMenuItem) {
		let str = FYSourceManger.share().lastCopyURL()
		if str.count == 0 {
			FYNotification.share().pushError(msg: "剪切板为空哦😢！")
		}else{
			NSPasteboard.general.setString(str,
										   forType: .string)
		}
	}
	
	func setwindowSize() -> Void {
		let window = NSApplication.shared.keyWindow
		window?.maxSize = RectCatory.kKeyWinDowMaxSize
        window?.minSize = RectCatory.kKeyWinDowMinSize
		window?.contentMaxSize = RectCatory.kKeyWinDowContentMaxSize
		window?.contentMinSize = RectCatory.kKeyWinDowContentMinSize
	}
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		setupMenuItem()
//		createService()
		setupPopVC()
		setwindowSize()
		addEventLisen()
	}
	func createService() -> Void {
		let v = FYReceivedMsgObj.addRunLoopPort()
		if v {
			print("本地服务 创建成功")
		}else{
			print("本地服务 创建失败")
		}
	}
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
		print("杀死 进程")
    }
	func applicationWillResignActive(_ notification: Notification) {
		closePopVC()
//		print(notification.object)
	}
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return false
	}
    /// :MARK 再次点击reopen window
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
       
        let wind = sender.orderedWindows[0]
        wind.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        return true
    }
	// MARK: dock menu
	func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
		return self.statusMenu
	}
	// MARK: 退出app
	func kill() -> Void {
//		let bid = Bundle.main.bundleIdentifier!
		let exBundleID = "cn.auy.macos"

		
		let apps = NSWorkspace .shared.runningApplications
		for app in apps {
			if app.bundleIdentifier?.contains(exBundleID) ?? false {
				let killAll = "kill -s 9 \(app.processIdentifier)";
				let task = NSUserAppleScriptTask()
				task.execute(withAppleEvent: NSAppleEventDescriptor(string: killAll)) { (desc, erro) in
					print("desc:\(desc.debugDescription) error:\(String(describing: erro))")
				}
			}
		}
//		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
//			let killAll = "pluginkit -e use -i \(exBundleID)"
//			print(killAll)
//			let task = NSUserAppleScriptTask()
//			task.execute(withAppleEvent: NSAppleEventDescriptor(string: killAll)) { (desc, erro) in
////				print("desc:\(desc.debugDescription) error:\(String(describing: erro))")
//			}
//		}
	}
}
extension AppDelegate:NSPopoverDelegate,FYOpenDragFileProtocol{
	func popoverWillClose(_ notification: Notification) {
		self.popIsShow = false
	}
	
	func fileDraging() {
		if self.popIsShow == false{
			self.popIsShow  = true
			self.showPopVC()
		}
	}
	func fileDragEnd() {
		closePopVC()
	}
}
