//
//  UtilTool.m
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/10.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import "UtilTool.h"
#import "QNModel.h"

#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <Qiniu/QN_GTM_Base64.h>
#import <Qiniu/QNUrlSafeBase64.h>
#import <Qiniu/QNUpToken.h>
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

#import <Qiniu/QN_GTM_Base64.h>
#import <Qiniu/QNUrlSafeBase64.h>


@implementation UtilTool
CFDataRef getData(NSString * str){
	if (str.length == 0) {
		str = @"";
	}
	const char* cStr = [str UTF8String];
	NSUInteger ulen = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	CFDataRef sgReturn = CFDataCreate(NULL, (UInt8 *)cStr, ulen);
	return sgReturn;
}
+ (CFDataRef)getData:(NSString *)str{
	return getData(str);
}
+ (NSString *)getStringFromData:(CFDataRef )cfData{
	const UInt8  * recvedMsg = CFDataGetBytePtr(cfData);
	NSString * strData = [NSString stringWithCString:(char *)recvedMsg encoding:NSUTF8StringEncoding];
	return strData;
}
+ (NSString *)makeNewToken:(QNModel *)model{
	return [UtilTool makeToken:model.accessKey
					 secretKey:model.secretKey
						  buck:model.buckName];
}
+ (NSString *) hmacSha1Key:(NSString*)key textData:(NSString*)text
 {
     const char *cData  = [text cStringUsingEncoding:NSUTF8StringEncoding];
     const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
     uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
     CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
     NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
     NSString *hash = [QNUrlSafeBase64 encodeData:HMAC];
     return hash;
 }

+ (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey buck:(NSString *)buckName
{
	
    //名字
    NSString *baseName = [self marshal:buckName];
    baseName = [baseName stringByReplacingOccurrencesOfString:@" " withString:@""];
    baseName = [baseName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData   *baseNameData = [baseName dataUsingEncoding:NSUTF8StringEncoding];
    NSString *baseNameBase64 = [QNUrlSafeBase64 encodeData:baseNameData];
    NSString *secretKeyBase64 =  [UtilTool hmacSha1Key:secretKey textData:baseNameBase64];
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, secretKeyBase64, baseNameBase64];

    return token;
}

+ (NSString *)marshal:(NSString *)name
{
	if (name == nil) {
		return @"";
	}
    time_t deadline;
    time(&deadline);
    //"ceshi" 是我们七牛账号下创建的储存空间名字“可以自定义”
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:name
			forKey:@"scope"];
    //3464706673 是token有效期
	NSTimeInterval time=[[NSDate dateWithTimeIntervalSinceNow:60*60*24*1000] timeIntervalSince1970];
    NSNumber *escapeNumber = [NSNumber numberWithLongLong:(long long)time];
    [dic setObject:escapeNumber forKey:@"deadline"];
    NSString *json = [UtilTool dictionryToJSONString:dic];
    return json;
}

+  (NSString*)dictionryToJSONString:(NSMutableDictionary *)dictionary
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
