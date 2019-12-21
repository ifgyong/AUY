//
//  QNModel.h
//  MToGifAndUpload
//
//  Created by fgy on 2019/12/10.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QNModel : NSObject


@property (nonatomic,strong) NSString *accessKey;
@property (nonatomic,strong) NSString *secretKey;
@property (nonatomic,strong) NSString *buckName;


+ (QNModel *)getSaveModel;

+ (void)saveModel:(QNModel *)model;

+ (void)clearCaches;

+ (NSString *)yuming;

+ (void)saveYuming:(NSString *)yuming;
@end

NS_ASSUME_NONNULL_END
