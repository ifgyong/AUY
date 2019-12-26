//
//  UploadProtocol.h
//  AUY
//
//  Created by Charlie on 2019/12/26.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class QNModel;

@protocol UploadMangerProtocol <NSObject>
typedef void(^ComplateCallback)(NSString *);
/// 上传阿里云多文件
/// @param datas 文件数组
/// @param model 配置model
/// @param complate 完成回调
/// @param faild 失败回调
+ (void)uploadDatasAsync:(NSArray<NSData *> *)datas
				   model:(QNModel *)model
				complate:(nonnull ComplateCallback)complate
				   faild:(nonnull ComplateCallback)faild;
@optional

/// 上传剪切板图片
+ (void)uploadDataFromPasted;


@end

@interface UploadProtocol : NSObject

@end

NS_ASSUME_NONNULL_END
