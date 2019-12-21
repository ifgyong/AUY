//
//  FYReceivedMsgObj.h
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/10.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UtilTool.h"


NS_ASSUME_NONNULL_BEGIN
//消息回调
static CFDataRef Callback(CFMessagePortRef port,
						  SInt32 messageID,
						  CFDataRef data,
						  void *info);


@interface FYReceivedMsgObj : NSObject
+ (BOOL)addRunLoopPort;
@end

NS_ASSUME_NONNULL_END
