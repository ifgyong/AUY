//
//  NSData+add.m
//  AUY
//
//  Created by Charlie on 2019/12/30.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import "NSData+add.h"

#import <AppKit/AppKit.h>
#import "NSImage+Format.h"

@implementation NSData (add)
- (NSString *)imageName{
	NSTimeInterval time=[[NSDate dateWithTimeIntervalSinceNow:0]timeIntervalSince1970];
	NSString *type = [NSImage fy_imageFormatForImageData:self];
	if (type.length > 0) {
		return [NSString stringWithFormat:@"%lld%d.%@",(long long)time,rand()%100,type];
	}
	NSString *key=[NSString stringWithFormat:@"%lld%d",(long long)time,rand()%100];
	return key;
}
@end
