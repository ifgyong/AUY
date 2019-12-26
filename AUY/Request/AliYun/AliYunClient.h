//
//  AliYunClient.h
//  AUY
//
//  Created by fgy on 2019/12/25.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/OSSService.h>

NS_ASSUME_NONNULL_BEGIN
@class QNModel;


@interface AliYunClient : OSSClient
@property (nonatomic,strong) QNModel *model;
+ (instancetype)sharedInstanceModel:(QNModel *)model;
@end

NS_ASSUME_NONNULL_END
