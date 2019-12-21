//
//  QNModel.m
//  MToGifAndUpload
//
//  Created by fgy on 2019/12/10.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import "QNModel.h"

static NSString * kQiNiuKey = @"kQiNiuKey";
static NSString * kQiNiuYuMingKey = @"kQiNiuYuMingKey";

static NSString * kQiNiuaccessKey = @"kQiNiuaccessKey";

static NSString * kQiNiusecretKey = @"kQiNiusecretKey";

static NSString * kQiNiubuckName = @"kQiNiubuckName";



@implementation QNModel

+ (QNModel *)getSaveModel{
	NSMutableDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:kQiNiuKey];
	
	QNModel *model = [QNModel new];
	if (user.count == 0) {
		return model;
	}
	model.accessKey = [user objectForKey:kQiNiuaccessKey];// @"nwSHDHj9dsf72FWAI2CxEo4TszpWpF-HmVR8Qwgd";
	model.secretKey = [user objectForKey:kQiNiusecretKey]; //@"lnBhZthAOUsHq5oFjnvEVdjCk46L2W2pELmuwU2d";
	model.buckName = [user objectForKey:kQiNiubuckName]; //@"fgyongblog";
	return model;
}
+ (void)saveModel:(QNModel *)model{
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setValue:model.accessKey forKey:kQiNiuaccessKey];
	[dic setValue:model.secretKey forKey:kQiNiusecretKey];
	[dic setValue:model.buckName forKey:kQiNiubuckName];
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
