//
//  UtilTool.h
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/10.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//


#import <Foundation/Foundation.h>



#define msg_bundleid "PU5CP57746.FY.MToGifAndUpload.demo"

static NSString * _Nullable kVCDidReceivedMsgNotificationName = @"kVCDidReceivedMsg";

@class QNModel;

NS_ASSUME_NONNULL_BEGIN
CFDataRef getData(NSString * str);

NSString* getStringFromData(CFDataRef data);


@interface UtilTool : NSObject
+ (CFDataRef)getData:(NSString *)str;

+ (NSString *)getStringFromData:(CFDataRef )recData;

+ (NSString *)makeNewToken:(QNModel *)model;

+ (NSString *) hmacSha1Key:(NSString*)key textData:(NSString*)text;

+ (NSString*)dictionryToJSONString:(NSMutableDictionary *)dictionary;

+ (NSString *)makeToken:(NSString *)accessKey
			  secretKey:(NSString *)secretKey
				   buck:(NSString *)buckName;
@end

NS_ASSUME_NONNULL_END
