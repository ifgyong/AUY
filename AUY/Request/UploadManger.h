//
//  uploadManger.h
//  AUY
//
//  Created by Charlie on 2019/12/26.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadManger.h"


NS_ASSUME_NONNULL_BEGIN
typedef void(^ComplateBlock)(NSString *);
@interface UploadManger : NSObject

+(UploadManger *)share;
///文件总数
@property (nonatomic,assign) NSInteger filesCount;
///现在上传的图片索引
@property (nonatomic,assign) NSInteger imageIndex;

@property (nonatomic,copy) ComplateBlock complate;
@property (nonatomic,copy) ComplateBlock faild;

- (void)setDefaultBlock;

@end

NS_ASSUME_NONNULL_END
