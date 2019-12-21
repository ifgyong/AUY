//
//  QiniuUploadManger.h
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/10.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Qiniu/QiniuSDK.h>

#import "QNModel.h"


NS_ASSUME_NONNULL_BEGIN
typedef void(^complateBlock)(NSString *);

@interface QiniuUploadManger : NSObject
@property (nonatomic,assign) NSInteger currentFileIndex;
@property (nonatomic,strong)     NSOperationQueue *queue;
@property (nonatomic,copy) complateBlock block;
@property (nonatomic,assign) NSInteger filesCount;
//当前上传的文件 索引
@property (nonatomic,copy) NSString* token;



+ (void)uploadImage:(NSArray<NSString*>  * _Nullable)url data:(NSArray<NSData*>  * _Nullable)data;

+ (void)uploadPasetedImage;

+ (instancetype)shareDefault;


/// 测试key是否可以正常访问
/// @param data 测试数据
/// @param comB 成功回调
/// @param failB 失败回调
+ (void)testUploadData:(NSData *)data
			  complate:(complateBlock)comB
				 faild:(complateBlock)failB
				 model:(QNModel *)model;

+ (BOOL)hasInfo;
@end

NS_ASSUME_NONNULL_END
