//
//  FYReceivedMsgObj.m
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/10.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import "FYReceivedMsgObj.h"


#define msg_bundleid "PU5CP57746.FY.MToGifAndUpload.demo"
@implementation FYReceivedMsgObj
void messagePortInvalidationCallBack(CFMessagePortRef ms, void *info){
	NSString  * ss = (NSString *)CFMessagePortGetName(ms);
	printf("PortInvalidationCallBack %s ",ss.UTF8String);
}
static CFDataRef Callback(CFMessagePortRef port,
						  SInt32 messageID,
						  CFDataRef cfData,
						  void *info)
{
    NSString *strData = nil;
    if (cfData)
    {
    	strData = [UtilTool getStringFromData:cfData];
        NSData *data = [strData dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *array = (NSArray *)[NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
        /**
         
         实现数据解析操作
         
         **/
        NSMutableDictionary *mutDic=[NSMutableDictionary dictionary];
        if (strData.length > 0) {
            [mutDic setObject:array forKey:@"files"];
        }
		NSNotification *notifi=[[NSNotification alloc]initWithName:kVCDidReceivedMsgNotificationName
								
															object:nil
														  userInfo:mutDic];
		dispatch_async(dispatch_get_main_queue(), ^{
			[NSNotificationCenter.defaultCenter postNotification:notifi];
		});
        NSLog(@"receive message:%@",strData);
    }
    
    //为了测试，生成返回数据
    NSString *returnString = [NSString stringWithFormat:@"i have receive:%@",strData];
    CFDataRef sgReturn = getData(returnString);
    return sgReturn;
}

+ (BOOL)addRunLoopPort{
	CFStringRef port_name = CFSTR(msg_bundleid);
	CFMessagePortRef localPort = CFMessagePortCreateLocal(kCFAllocatorDefault,
														  port_name,
														  Callback,
														  NULL,
														  NULL);
	if (localPort == nil) {
		return NO;
	}
	if (CFMessagePortIsValid(localPort) == false) {
		return NO;
	}
	//不可用回调
	CFMessagePortSetInvalidationCallBack(localPort, messagePortInvalidationCallBack);
	
	if (localPort == NULL) {
		printf("本地localPort 创建失败 \n");
		return NO;
	}
	if (CFMessagePortIsValid(localPort)==false) {
		printf("本地localPort 不可用\n");
		return NO;
	}
	CFRunLoopSourceRef runLoopSource = CFMessagePortCreateRunLoopSource(kCFAllocatorDefault, localPort, 0);
	if (runLoopSource == NULL) {
		printf("source 创建失败 \n");
		return NO;
	}
	CFRunLoopAddSource(CFRunLoopGetCurrent(),
					   runLoopSource,
					   kCFRunLoopDefaultMode);
//	CFMessagePortSetDispatchQueue(localPort, dispatch_get_main_queue());//添加到主线程

	return YES;
}
@end
