//
//  NSObject+token.h
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/10.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (token)

- (void)setToken:(NSString *)token;

- (NSString *)token;
@end

NS_ASSUME_NONNULL_END
