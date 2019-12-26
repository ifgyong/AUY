//
//  NSObject+token.m
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/10.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import "NSObject+token.h"

#import <AppKit/AppKit.h>


@implementation NSObject (token)
- (void)setToken:(NSString *)token{
	if (token.length) {
		[[NSUserDefaults standardUserDefaults]setObject:token forKey:@"token"];
		[[NSUserDefaults standardUserDefaults]synchronize];
	}
}
- (NSString *)token{
	NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
	NSLog(@"token:%@",token);
	return token;
}
@end
