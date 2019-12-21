//
//  PostMsg.h
//  MToGifAndUpload Extension
//
//  Created by Charlie on 2019/12/10.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UtilTool.h"
NS_ASSUME_NONNULL_BEGIN

////获取字符串封装的data
//CFDataRef getData(NSString * str);
void postMsg(void);
void postMsgFinal(NSArray * urls);
static CFDataRef Callback(CFMessagePortRef port,
						  SInt32 messageID,
						  CFDataRef data,
						  void *info);


CFDataRef getData(NSString * str);

NSString* getStringFromData(CFDataRef data);



@interface PostMsg : NSObject
+ (CFDataRef)getData:(NSString *)str;

+ (NSString *)getStringFromData:(CFDataRef )recData;
@end

NS_ASSUME_NONNULL_END
