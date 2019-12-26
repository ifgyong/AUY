//
//  AliYunUploadMangre.h
//  AUY
//
//  Created by fgy on 2019/12/25.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class QNModel;
@class AliYunClient;

typedef void(^AliyunComplate)(NSString *);

@interface AliYunUploadMangre : NSObject<UploadMangerProtocol>
@property (nonatomic,strong) AliYunClient *client;

+ (instancetype) share;

+ (void)uploadTestAsync:(NSData *)data
				  model:(QNModel *)model
			   complate:(nonnull AliyunComplate)complate
				  faild:(nonnull AliyunComplate)faild;

/// 上传阿里云多文件
/// @param datas 文件数组
/// @param model 配置model
/// @param complate 完成回调
/// @param faild 失败回调
+ (void)uploadDatasAsync:(NSArray<NSData *> *)datas
				   model:(QNModel *)model
				complate:(nonnull AliyunComplate)complate
				   faild:(nonnull AliyunComplate)faild;
@end

NS_ASSUME_NONNULL_END
