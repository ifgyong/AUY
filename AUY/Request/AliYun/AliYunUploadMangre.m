//
//  AliYunUploadMangre.m
//  AUY
//
//  Created by fgy on 2019/12/25.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import "AliYunUploadMangre.h"
#import <AliyunOSSiOS/OSSService.h>
#import "QiniuUploadManger.h"
#import "AliYunClient.h"
#import "QNModel.h"
#import <AUY-Swift.h>
#import "UploadManger.h"


@interface AliYunUploadMangre (){
	
}

@end

@implementation AliYunUploadMangre
static AliYunUploadMangre *manger;

+ (instancetype) share{
	if (manger == nil) {
		manger=[AliYunUploadMangre new];
	}
	return manger;
}
#pragma mark 异步上传
+ (OSSPutObjectRequest *)getNewOSSObjectResult:(NSData *)data buckName:(NSString *)name{
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = name;
    put.objectKey = [QiniuUploadManger getNameWithData:data];
    put.uploadingData = data;
    
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"total:%lld, progress: %f", totalBytesExpectedToSend, (double)totalByteSent/(double)totalBytesExpectedToSend);
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
	return put;
}
+ (void)uploadTestAsync:(NSData *)data
					   model:(QNModel *)model
					complate:(nonnull AliyunComplate)complate
					   faild:(nonnull AliyunComplate)faild{
	OSSPutObjectRequest * put = [self getNewOSSObjectResult:data buckName:model.buckName];
	[AliYunUploadMangre share].client = [AliYunClient sharedInstanceModel:model];
    OSSTask * putTask = [[AliYunUploadMangre share].client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        NSString *msg;
        if (!task.error) {
             msg = @"upload object success!";
			dispatch_async(dispatch_get_main_queue(), ^{
				NSString *fullUrl =[NSString stringWithFormat:@"%@/%@",model.yuming,put.objectKey];
				if (complate) {
					complate(fullUrl);
				}
			});
        } else {
            msg = [NSString stringWithFormat:@"%@" , task.error];
			dispatch_async(dispatch_get_main_queue(), ^{
				if (faild) {
					faild(msg);
				}
			});
		}
        return nil;
    }];
}
+(void) uploadDataFromPasted{
	NSPasteboard * paste = NSPasteboard.generalPasteboard;
	NSData *data = [paste dataForType:NSPasteboardTypePNG];
	[UploadManger share].imageIndex = 0;
	if (data == nil) {
		[FYNotification.share pushErrorWithMsg:@"剪切板没有图片哦"];
	} else{
		[FYSourceManger.share addImageWithImg:[[NSImage alloc]initWithData:data]];
		QNModel *model =[QNModel getSaveModel];
		[AliYunUploadMangre uploadDatasAsync:@[data]
									   model:model
									complate:^(NSString * _Nonnull url) {
			[UploadManger share].complate(url);
		} faild:^(NSString * _Nonnull error) {
			[UploadManger share].complate(error);
		}];
	}
}
+ (void)uploadDatasAsync:(NSArray<NSData *> *)datas
					   model:(QNModel *)model
					complate:(nonnull AliyunComplate)complate
					   faild:(nonnull AliyunComplate)faild{
	if ([QNModel getSaveModel] == nil) {
		[[FYNotification share] pushErrorWithMsg:@"请先设置图床平台！"];
		return;
	}
	if (datas.count == 0) {
        [FYNotification.share pushErrorWithMsg:@"图片为空哦！"];
		return;
	}
	//重置当前索引
	[[UploadManger share] setImageIndex:0];// = 0;
	[UploadManger share].filesCount = datas.count;
	for (NSInteger i = 0; i < datas.count; i ++) {
		NSData *data = datas[i];
		OSSPutObjectRequest * put = [self getNewOSSObjectResult:data
													   buckName:model.buckName];
		if ([AliYunUploadMangre share].client == nil) {
			[AliYunUploadMangre share].client = [AliYunClient sharedInstanceModel:model];
		}
		OSSTask * putTask = [[AliYunUploadMangre share].client putObject:put];
		
		[putTask continueWithBlock:^id(OSSTask *task) {
			NSString *msg;
			if (!task.error) {
				 msg = @"upload object success!";
				dispatch_async(dispatch_get_main_queue(), ^{
					NSString *fullUrl =[NSString stringWithFormat:@"![](%@/%@)",model.yuming,put.objectKey];
					if (complate) {
						complate(fullUrl);
					}
				});
			} else {
				msg = [NSString stringWithFormat:@"%@" , task.error];
				dispatch_async(dispatch_get_main_queue(), ^{
					if (faild) {
						faild(msg);
					}
				});
			}
			return nil;
		}];
	}

}
@end
