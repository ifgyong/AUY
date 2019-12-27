//
//  uploadManger.m
//  AUY
//
//  Created by Charlie on 2019/12/26.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import "UploadManger.h"
#import <AUY-Swift.h>
#import "QiniuUploadManger.h"

@implementation UploadManger
static UploadManger * _upload = nil;

+ (UploadManger *)share{
	if (_upload == nil) {
		_upload= [[UploadManger alloc]init];
		[_upload setDefaultBlock];
	}
	return _upload;
}

- (void)setDefaultBlock{
	[[UploadManger share] setComplate:^(NSString * _Nonnull fullURL) {
		//发推送
		[[FYSourceManger share] addURLWithUrl:fullURL];
		NSLog(@"%@",fullURL); 
		[NSPasteboard.generalPasteboard addUrlToPasteWithMsg:fullURL shouldClear:^BOOL{
			if (UploadManger.share.imageIndex == 0) {
				return true;
			}
			return false;
		} complate:^{
			UploadManger.share.imageIndex += 1;
		}];
		[[FYNotification share] pushWithUrl:fullURL];
	}];
	
	[[UploadManger share] setFaild:^(NSString * _Nonnull error) {
		[[FYNotification share] pushErrorWithMsg:error];
	}];
}
@end
