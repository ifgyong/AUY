//
//  QNModel.h
//  MToGifAndUpload
//
//  Created by fgy on 2019/12/10.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelActionProtocol.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * kQiNiuKey = @"kQiNiuKey";
static NSString * kQiNiuYuMingKey = @"kQiNiuYuMingKey";

static NSString * kQiNiuaccessKey = @"kQiNiuaccessKey";

static NSString * kQiNiusecretKey = @"kQiNiusecretKey";

static NSString * kQiNiubuckName = @"kQiNiubuckName";

static NSString * kOSS_ENDPOINT = @"kOSS_ENDPOINT";


static NSString * kRegName = @"kRegName";


@interface QNModel : NSObject


@property (nonatomic,strong) NSString *accessKey;
@property (nonatomic,strong) NSString *secretKey;
@property (nonatomic,strong) NSString *buckName;
@property (nonatomic,strong) NSString *yuming;
@property (nonatomic,strong) NSString *regName;


+ (instancetype)getSaveModel;

+ (void)saveModel:(QNModel *)model;

+ (void)clearCaches;

+ (NSString *)yuming;

+ (void)saveYuming:(NSString *)yuming;
@end

NS_ASSUME_NONNULL_END
