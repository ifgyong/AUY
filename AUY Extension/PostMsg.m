//
//  PostMsg.m
//  MToGifAndUpload Extension
//
//  Created by Charlie on 2019/12/10.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import "PostMsg.h"

@implementation PostMsg
static CFDataRef Callback(CFMessagePortRef port,
						  SInt32 messageID,
						  CFDataRef data,
						  void *info)
{
	// ...
	return NULL;
}

void postMsg(void){
	natural_t data = 0;
	mach_port_t port = 0;
	 
	struct {
		mach_msg_header_t header;
		mach_msg_body_t body;
		mach_msg_type_descriptor_t type;
	} message;
	 
	message.header = (mach_msg_header_t) {
		.msgh_remote_port = port,
		.msgh_local_port = MACH_PORT_NULL,
		.msgh_bits = MACH_MSGH_BITS(MACH_MSG_TYPE_COPY_SEND, 0),
		.msgh_size = sizeof(message)
	};
	 
	message.body = (mach_msg_body_t) {
		.msgh_descriptor_count = 1
	};
	 
	message.type = (mach_msg_type_descriptor_t) {
		.pad1 = data,
		.pad2 = sizeof(data)
	};
	 
	mach_msg_return_t error = mach_msg_send(&message.header);
	 
	if (error == MACH_MSG_SUCCESS) {
		// ...
		printf("发送成功 post msg");
	}else{
		printf("发送失败 post msg");
	}
}
void postMsgFinal(NSArray * url){
//	NSString *messageStr = @"hello word";
    if (url.count == 0) {
        return;
    }
    CFDataRef data = [PostMsg getDataArray:url];//(__bridge CFDataRef)(data2);//[PostMsg getData:url];
	static SInt32 messageID = 0x1111; // Arbitrary
	CFTimeInterval timeout = 3.0;
	CFStringRef portName = CFSTR(msg_bundleid);
	CFDataRef recData = nil;
	CFMessagePortRef remotePort = CFMessagePortCreateRemote(kCFAllocatorDefault,portName);
	if (remotePort == NULL) {
		printf("远程端口创建失败 postMsgFinal\n");
		return;
	} else {
		SInt32 status = CFMessagePortSendRequest(remotePort,
												 messageID,
												 data,
												 timeout,
												 timeout,
												 kCFRunLoopDefaultMode,
												 Nil);
		
		if (recData != NULL) {
			NSString *desc = [PostMsg getStringFromData:recData];
			NSLog(@"收到了 %@",desc);
			CFRelease(recData);
			CFMessagePortInvalidate(remotePort);
			CFRelease(remotePort);
			return ;
		}
		switch (status) {
			case kCFMessagePortSuccess:
				printf("发送成功 postMsgFinal\n");
				break;
				case kCFMessagePortIsInvalid:
				printf("发送失败 PortIsInvalid\n");
				break;
				case kCFMessagePortSendTimeout:
				printf("发送失败 kCFMessagePortSendTimeout\n");
				break;
				case kCFMessagePortReceiveTimeout:
				printf("发送失败 kCFMessagePortReceiveTimeout\n");
				break;
				case kCFMessagePortTransportError:
				printf("发送失败 kCFMessagePortTransportError\n");
				break;
				case kCFMessagePortBecameInvalidError:
				printf("发送失败 kCFMessagePortBecameInvalidError\n");
				break;
			default:
				break;
		}
	}
}

CFDataRef getData(NSString * str){
	if (str.length == 0) {
		str = @"";
	}
	const char* cStr = [str UTF8String];
	NSUInteger ulen = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	CFDataRef sgReturn = CFDataCreate(NULL, (UInt8 *)cStr, ulen);
	return sgReturn;
}
+ (CFDataRef)getDataArray:(NSArray *)array{
     NSData *data=[NSJSONSerialization dataWithJSONObject:array
                                                  options:NSJSONWritingPrettyPrinted
                                                    error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data
                                           encoding:NSUTF8StringEncoding];
	return getData(jsonStr);
}
+ (NSString *)getStringFromData:(CFDataRef )cfData{
	const UInt8  * recvedMsg = CFDataGetBytePtr(cfData);
	NSString * strData = [NSString stringWithCString:(char *)recvedMsg encoding:NSUTF8StringEncoding];
	return strData;
}
@end
