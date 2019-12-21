//
//  VolumeManger.swift
//  MToGifAndUpload Extension
//
//  Created by Charlie on 2019/12/6.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Foundation
import Cocoa
import  AppKit;
import FinderSync;

class VolumeManager {
	
	static let shared = VolumeManager()
	
	static let VolumesDidChangeNotification = Notification.Name(rawValue: "VolumeManagerVolumesDidChangeNotification")
	
	let session = DASessionCreate(kCFAllocatorDefault)!
	
//	let connc = NSXPCConnection.init(serviceName: "FY.XPCService")
	
	init() {
		// update the volumes now
		updateVolumes()
		
		// set ourselves up to get notifications when the list of volumes change
		DARegisterDiskAppearedCallback(session, nil, _volumeManagerDiskArbitrationCallback, nil)
        //disk 消失 callback
        DARegisterDiskDisappearedCallback(session, nil, _volumeManagerDiskDisappearCallback(disk:context:), nil)
		
		// schedule DiskArbitrator in the run loop so it actually sends the notifications
		DASessionScheduleWithRunLoop(session, RunLoop.main.getCFRunLoop(), RunLoop.Mode.common as CFString)
		
//		connc.remoteObjectInterface = NSXPCInterface(with: kUTTyp)
		
	}
	
	func updateVolumes() {
		// get the new volumes, and post them in a notification
		print("updateVolumes ")
		let volumes = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: [])
		NotificationCenter.default.post(name: VolumeManager.VolumesDidChangeNotification,
                                        object: volumes)
	}
	
	deinit {
		// remove callbacks and remove the session from the run loop
        DASessionUnscheduleFromRunLoop(session, RunLoop.main.getCFRunLoop(),
                                       RunLoop.Mode.common as CFString)
	}
}

fileprivate func _volumeManagerDiskArbitrationCallback(disk: DADisk, context: UnsafeMutableRawPointer?) {
    print("disk 出现了 :\(disk.hashValue) ")
	VolumeManager.shared.updateVolumes()
}
fileprivate func _volumeManagerDiskDisappearCallback(disk: DADisk, context: UnsafeMutableRawPointer?) {
    print("disk 消失了:\(disk.hashValue) ")
	VolumeManager.shared.updateVolumes()
}

open class Preferences{
	public static let fallbackTerminalAppURL = URL(string: "file:///Applications/Utilities/MToGifAndUpload.app")!

	let preferences = UserDefaults(suiteName: "PU5CP57746.FY.MToGifAndUpload")!

	public static let sharedInstance = Preferences()
	init() {
		preferences.register(defaults: [
			"HadFirstRun": false,
			"appURL": Preferences.fallbackTerminalAppURL.path,
			"ShowInContextMenu": true,
			"OpenSelection": true,
			"EditorShowInContextMenu": true,
		])
	}
	open var appUrl:URL{
		get{return Preferences.fallbackTerminalAppURL; }
		set {preferences.set(newValue.path, forKey: "appURL")}
	}
	
	open var editorShowInContextMenu: Bool {
		get { return preferences.bool(forKey: "EditorShowInContextMenu") }
		set { preferences.set(newValue, forKey: "EditorShowInContextMenu") }
	}
	open var HadFirstRun:Bool{
		get { return preferences.bool(forKey: "HadFirstRun") }
		set { preferences.set(newValue, forKey: "HadFirstRun") }
	}
	
	open var OpenSelection:Bool{
		get { return preferences.bool(forKey: "OpenSelection") }
		set { preferences.set(newValue, forKey: "OpenSelection") }
	}
	open var EditorShowInContextMenu:Bool{
		get { return preferences.bool(forKey: "EditorShowInContextMenu") }
		set { preferences.set(newValue, forKey: "EditorShowInContextMenu") }
	}
	
	
	
	
}
