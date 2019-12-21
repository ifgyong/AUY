//
//  FYCreateGif.swift
//  MToGifAndUpload
//
//  Created by fgy on 2019/12/13.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

import Foundation
import PhotosUI
import ImageIO
import CoreImage
import FileProvider
import ImageCaptureCore


let fpsMax = 24
let fpsMin = 0.5
let fpsDefault = 1

let zoomMax = 10
let zoomMin = 0.1
let zoomDefault = 1

public typealias NSRectPointer = UnsafeMutablePointer<NSRect>

extension NSObject{
    
    /// 制作gif
    /// - Parameters:
    ///   - images: 图片数组
    ///   - url: 目标url
    ///   - fps: 帧率
    func save(_ images:[URL],url:URL,fps:Double,zoom:Double) -> Bool {
        let imageCuont = images.count
        guard let   destinaiton = CGImageDestinationCreateWithURL(url as CFURL, kUTTypeGIF, imageCuont, nil) else {
            return false
        }
        
        //设置每帧图片播放时间
        var dfps:Double = fps
        
        if dfps < fpsMin {
            dfps = Double(exactly: fpsMin)!
        }else if Int(dfps) > fpsMax{
            dfps = Double(exactly: fpsMax)!
        }
        // 设置gif的彩色空间格式、颜色深度、执行次数
        let gifPropertyDic = NSMutableDictionary()
        gifPropertyDic.setValue(kCGImagePropertyColorModelRGB,
                                forKey: kCGImagePropertyColorModel as String)
        //通道宽度
        gifPropertyDic.setValue(8,
                                forKey: kCGImagePropertyDepth as String)
        //循环次数
//        gifPropertyDic.setValue(1,
//                                forKey: kCGImagePropertyGIFLoopCount as String)

//        gifPropertyDic.setValue(200, forKey: kCGImagePropertyHeight as String)
//        gifPropertyDic.setValue(200, forKey: kCGImagePropertyWidth as String)
        
        //设置gif属性
        let gifDicDest = [kCGImagePropertyGIFDictionary as String: gifPropertyDic]
        CGImageDestinationSetProperties(destinaiton, gifDicDest as CFDictionary)
        
        
        //添加gif图像的每一帧元素
        for i in 0..<images.count {
//            let size = images[i].size
//            images[i].size = NSSize(width: Double( size.width) * zoom, height: Double(size.height) * zoom)
            let imageold = NSImage(contentsOf: images[i])!
            let oldRect = NSRect(x: 0,
                                            y: 0,
                                            width: Double(imageold.size.width) ,
                                            height: Double(imageold.size.height))
            let newRect = NSRect(x: 0,
                                 y: 0,
                                 width: Double(imageold.size.width) * zoom,
                                 height: Double(imageold.size.height) * zoom)

            let newImg = NSImage(size: newRect.size)
            
            
            newImg.lockFocus()
            imageold.draw(in: newRect,
                          from: oldRect,
                          operation: .copy,
                          fraction: 1.0)
            newImg.unlockFocus()
            
            let unsafepointer = UnsafeMutablePointer<NSRect>.allocate(capacity: 4)
            unsafepointer.initialize(to: newRect)
            let cg = newImg.cgImage(forProposedRect: unsafepointer,
                                    context: nil,
                                    hints: nil)!
            print("newimg:\(newImg.size) cgH:\(cg.height) W:\(cg.width)")
            //设置每帧图片播放时间
            let cgimageDic = [kCGImagePropertyGIFDelayTime as String: 1/fps]
            let gifDestinaitonDic = [kCGImagePropertyGIFDictionary as String: cgimageDic]
            CGImageDestinationAddImage(destinaiton, cg, gifDestinaitonDic as CFDictionary)
        }
        //生成gif
        return CGImageDestinationFinalize(destinaiton)
    }
    func imageResize(img:NSImage,newsize:NSSize) -> NSImage? {
        let sourceImage = img;
        if sourceImage.isValid {
            NSLog("Invalid Image");
            return nil
        }else{
            let smallImage = NSImage(size: newsize);
            smallImage.lockFocus()
            NSGraphicsContext.current?.imageInterpolation = .high
            sourceImage.draw(at: NSZeroPoint, from: CGRect(x: 0, y: 0, width: newsize.width, height: newsize.height), operation: NSCompositingOperation.copy,
                             fraction: 1.0);
            smallImage.unlockFocus()
            return smallImage
        }
    }
    

    
    /// 将图片数组转化成并返回文件URLf
    /// - Parameters:
    ///   - images: 图片数组
    ///   - imageName: 图片名字
    ///   - fps: 帧数
    ///   - loop: 循环次数 默认1
    func compositionImage(_ images: [URL], _ imageName: String,fps:Double,loop:Int,zoom:Double) -> URL? {
        //在系统级别创建 Cache目录下创建gif文件
        let path = defaultCachePath()
        let gifPath = path + "/\(imageName)" + ".GIF"
        let url = URL(fileURLWithPath: gifPath)
        if save(images, url: url, fps: fps,zoom: zoom){
            return url
        }
        return nil
    }
	func defaultCachePath() -> String {
		let docs = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .allDomainsMask, true)
		   let path =  docs[0] + "/AUY"
		   let manger = FileManager.default
		   let objcB = ObjCBool(booleanLiteral: true)
		   let fileType = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
		   fileType.initialize(to: objcB)
		   if manger.fileExists(atPath: path, isDirectory: fileType) == false{
			   //withIntermediateDirectories 没有父级则创建父级目录
			   try? manger.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
		   }
		return path
	}
    
}
