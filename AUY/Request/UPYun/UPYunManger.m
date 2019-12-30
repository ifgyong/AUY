//
//  UPYunManger.m
//  AUY
//
//  Created by Charlie on 2019/12/30.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import "UPYunManger.h"
#import "UpYun.h"
#import "UpYunFormUploader.h"
#import "UpSimpleHttpClient.h"
#import "NSData+add.h"
#import "QNModel.h"

@implementation UPYunManger


+ (void)uploadDatasAsync:(nonnull NSArray<NSData *> *)datas model:(nonnull QNModel *)model complate:(nonnull ComplateCallback)complate faild:(nonnull ComplateCallback)faild {

	for (int i =0;i < datas.count; i ++){
		NSData *data = datas[i];
		if (data.length == 0) {
			continue;
		}
		UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
		NSString *bucketName = model.buckName;// @"teset-image";
		NSString *pwd = model.secretKey;
		NSString *oper = model.accessKey;
			
		[up uploadWithBucketName:model.buckName
						operator:oper
						password:pwd
						fileData:data
						fileName:nil
						 saveKey:[data imageName]
				 otherParameters:nil
						 success:^(NSHTTPURLResponse *response,
								   NSDictionary *responseBody) {
			NSLog(@"上传成功 responseBody：%@", responseBody);
			
			NSLog(@"可将您的域名与返回的 url 路径拼接成完整文件 URL，再进行访问测试。注意生产环境请用正式域名，新开空间可用 test.upcdn.net 进行测试。https 访问需要空间开启 https 支持");
			NSLog(@"用默认提供的旧测试域名，拼接后文件地址（新空间无法访问）：http://%@.b0.upaiyun.com/%@", bucketName, [responseBody objectForKey:@"url"]);
			NSLog(@"默认: http://%@.test.upcdn.net/%@", bucketName, [responseBody objectForKey:@"url"]);
			
			//主线程刷新ui
			
			//主线程刷新ui
			dispatch_async(dispatch_get_main_queue(), ^(){
				NSLog(@"上传成功");
				NSString *fullURL=[NSString stringWithFormat:@"![](%@/%@)",model.yuming,[responseBody objectForKey:@"url"]];
				if (complate) {
					complate(fullURL);
				}
				//							  [self.uploadBtn setTitle:progress_rate forState:UIControlStateNormal];
			});
		}
						 failure:^(NSError *error,
								   NSHTTPURLResponse *response,
								   NSDictionary *responseBody) {
			NSLog(@"上传失败 error：%@", error);
			NSLog(@"上传失败 code=%ld, responseHeader：%@", (long)response.statusCode, response.allHeaderFields);
			NSLog(@"上传失败 message：%@", responseBody);
			//主线程刷新ui
			dispatch_async(dispatch_get_main_queue(), ^(){
				NSString *message = [responseBody objectForKey:@"message"];
				if (!message) {
					message = [NSString stringWithFormat:@"%@", error.localizedDescription];
				}
				if (faild) {
					faild(@"上传失败");
				}
				//								   NSLog(@"%@",message);
			});
		}
		 
						progress:^(int64_t completedBytesCount,
								   int64_t totalBytesCount) {
			NSString *progress = [NSString stringWithFormat:@"%lld / %lld", completedBytesCount, totalBytesCount];
			NSString *progress_rate = [NSString stringWithFormat:@"upload %.1f %%", 100 * (float)completedBytesCount / totalBytesCount];
			NSLog(@"upload progress: %@", progress);
			
		}];
	}
}

+ (void)uploadTestAsync:(nonnull NSData *)data model:(nonnull QNModel *)model complate:(nonnull ComplateCallback)complate faild:(nonnull ComplateCallback)faild {
	[self uploadDatasAsync:@[data] model:model complate:complate faild:faild];
}

@end
