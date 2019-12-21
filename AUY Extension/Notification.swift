//
//  Notification.swift
//  MToGifAndUpload Extension
//
//  Created by Charlie on 2019/12/13.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Foundation
import UserNotifications
import AppKit


@available(OSX 10.14, *)
public class FYNotification: NSObject {

	@available(OSX 10.14, *)
	lazy var notification = UNUserNotificationCenter.current()
	static let n = FYNotification()
	@objc public static func share() -> FYNotification {
		return n
	}
	override init() {
		
	}
	@objc public func push(url:String) -> Void {
		let dic = ["url":url]
		
		FYNotification.share().push(title: "温馨提示",
									msg: "图片已经上传云端，请在在剪切板查看",
		userInfo: dic)
	}
	@objc public func pushError(msg:String) -> Void {
		let dic = ["url":""]
		
		FYNotification.share().push(title: "温馨提示",
									msg: msg,
		userInfo: dic)
	}
	

	public func push(title:String, msg:String , userInfo:[String:String]) -> Void {
		let content = UNMutableNotificationContent()
		  content.title = title
		  content.body = msg
		  
		  content.userInfo = userInfo
		  
		  content.sound = UNNotificationSound.default
		  content.categoryIdentifier = "NOTIFICATION_DEMO"
		  
		  let acceptAction = UNNotificationAction(identifier: "SHOW_ACTION",
												  title: "复制",
												  options: .init(rawValue: 0))
		  let declineAction = UNNotificationAction(identifier: "CLOSE_ACTION",
												   title: "关闭",
												   options: .init(rawValue: 0))
		  let testCategory = UNNotificationCategory(identifier: "NOTIFICATION_DEMO",
													actions: [acceptAction, declineAction],
													intentIdentifiers: [],
													hiddenPreviewsBodyPlaceholder: "",
													options: .customDismissAction)
		  
		  let request = UNNotificationRequest(identifier: "NOTIFICATION_DEMO_REQUEST",
											  content: content,
											  trigger: nil)
		  
		  // Schedule the request with the system.
		  let notificationCenter = UNUserNotificationCenter.current()
		  notificationCenter.delegate = self
		  notificationCenter.setNotificationCategories([testCategory])
		  notificationCenter.add(request) { (error) in
			  if error != nil {
				  // Handle any errors.
				print(error.debugDescription)
			  }
		  }
	}
}

@available(OSXApplicationExtension 10.14, *)
extension FYNotification: UNUserNotificationCenterDelegate{
	public func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
		
	}
	public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
        switch response.actionIdentifier {
        case "SHOW_ACTION":
			let paste = NSPasteboard.general
			let url = String(userInfo["url"] as? String ?? "")
			paste.clearContents()
			paste.setString(url, forType: .string)
        case "CLOSE_ACTION":
			#if DEBUG
            print("close")
			#endif
        default:
            break
        }
        completionHandler()
	}
	public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		 completionHandler([.alert, .sound])
	}
}
