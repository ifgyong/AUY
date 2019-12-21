//
//  NSImage+Format.h
//  AUY
//
//  Created by fgy on 2019/12/18.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import <AppKit/AppKit.h>


#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (Format)


+ (NSString *)fy_imageFormatForImageData:(nullable NSData *)data ;
@end

NS_ASSUME_NONNULL_END
