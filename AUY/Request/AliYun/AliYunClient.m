//
//  AliYunClient.m
//  AUY
//
//  Created by fgy on 2019/12/25.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import "AliYunClient.h"
#import "QNModel.h"

NSString *const endPoint = @"https://oss-cn-beijing.aliyuncs.com"; //@"http://aliyunimg.fgyong.cn";//
NSString *const AccessKey = @"LTAI4FhJAjF6ZZmoGBUqdsT4";
NSString *const SecretKey = @"HnjilwKtp8KEGF25oT6Uubj031DLKM";

@implementation AliYunClient
+ (instancetype)sharedInstanceModel:(QNModel *)model {
	return [self _initClient:model];
}

+ (AliYunClient *)_initClient:(QNModel *)model {
    // 打开调试log
//    [OSSLog enableLog];
    
    // oss-cn-shenzhen    oss-cn-shenzhen.aliyuncs.com    oss-cn-shenzhen-internal.aliyuncs.com
    
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:model.accessKey
																											secretKey:model.secretKey];
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
    conf.timeoutIntervalForRequest = 30; // 网络请求的超时时间
    conf.timeoutIntervalForResource = 24 * 60 * 60; // 允许资源传输的最长时间
    
    AliYunClient *client = [[AliYunClient alloc] initWithEndpoint:model.yuming
											   credentialProvider:credential
											  clientConfiguration:conf];
    return client;
}
@end
