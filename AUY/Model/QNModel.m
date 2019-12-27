//
//  QNModel.m
//  MToGifAndUpload
//
//  Created by fgy on 2019/12/10.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import "QNModel.h"
#import <AUY-Swift.h>



@interface QNModel () 

@end

@implementation QNModel

+ (instancetype)getSaveModel{
	NSMutableDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:kQiNiuKey];
	if (user.count == 0) {
		return nil;
	}
	
	QNModel *model = [QNModel new];
	model.accessKey = [user objectForKey:kQiNiuaccessKey];// @"nwSHDHj9dsf72FWAI2CxEo4TszpWpF-HmVR8Qwgd";
	model.secretKey = [user objectForKey:kQiNiusecretKey]; //@"lnBhZthAOUsHq5oFjnvEVdjCk46L2W2pELmuwU2d";
	model.buckName = [user objectForKey:kQiNiubuckName]; //@"fgyongblog";
	model.yuming = [user objectForKey:kOSS_ENDPOINT];
	model.regName = [user objectForKey:kRegName];
	return model;
}
+ (void)saveModel:(QNModel *)model{
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setValue:model.accessKey forKey:kQiNiuaccessKey];
	[dic setValue:model.secretKey forKey:kQiNiusecretKey];
	[dic setValue:model.buckName forKey:kQiNiubuckName];
	[dic setValue:model.yuming forKey:kOSS_ENDPOINT];
	if (model.regName.length) {
		[dic setValue:model.regName forKey:kRegName];
	}
	[user setObject:dic forKey:kQiNiuKey];
	[user synchronize];
}
+ (void)clearCaches{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kQiNiuKey];
}
+ (NSString *)yuming{
	NSString *yu = [[NSUserDefaults standardUserDefaults] stringForKey:kQiNiuYuMingKey];
	return yu;
}
+ (void)saveYuming:(NSString *)yuming{
	yuming = yuming.length > 0 ? yuming : @"";
	[[NSUserDefaults standardUserDefaults] setValue:yuming forKey:kQiNiuYuMingKey];
}
@end
