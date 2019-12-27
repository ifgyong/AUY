//
//  ModelActionProtocol.h
//  AUY
//
//  Created by Charlie on 2019/12/27.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FYModelProtocol <NSObject>

+ (instancetype)getSaveModel;
+ (void)saveModel:(id<FYModelProtocol>)model;

@end



NS_ASSUME_NONNULL_END
