//
//  QiniuUploadManger.m
//  MToGifAndUpload
//
//  Created by Charlie on 2019/12/10.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import "QiniuUploadManger.h"
#import "NSObject+token.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

#import <Qiniu/QN_GTM_Base64.h>
#import <Qiniu/QNUrlSafeBase64.h>
#import <Qiniu/QNUpToken.h>
#import "QNModel.h"
#import <AFNetworking/AFNetworking.h>
#import <AUY-Swift.h>
#import "UtilTool.h"
#import "NSImage+Format.h"


@interface QiniuUploadManger(){
    NSMutableData *_downData;
}


@end
@implementation QiniuUploadManger
+ (instancetype)shareDefault{
	static dispatch_once_t onceToken;
	static QiniuUploadManger * manger;
	dispatch_once(&onceToken, ^{
		manger=[[QiniuUploadManger alloc]init];
	});
	return manger;
}
+(void)uploadPasetedImage{
	NSPasteboard * paste = NSPasteboard.generalPasteboard;
	NSData *data = [paste dataForType:NSPasteboardTypePNG];
	[QiniuUploadManger shareDefault].currentFileIndex = 0;
	if (data == nil) {
		[FYNotification.share pushErrorWithMsg:@"剪切板没有图片哦"];
	} else{
		[FYSourceManger.share addImageWithImg:[[NSImage alloc]initWithData:data]];
		[QiniuUploadManger uploadImage:nil
								  data:@[data]];
	}
}
-(instancetype)init{
	if (self = [super init]) {
		if (self.token.length == 0 ) {
//			NSString * token =[QiniuUploadManger getTokenWithModel:[QiniuUploadManger getModel]];
//			[self setToken:token];
            self.queue=[[NSOperationQueue alloc]init];
		}
		return self;
	}
	return self;
}
+ (QNModel *)getModel{
	return [QNModel getSaveModel];
}
+ (BOOL)hasInfo{
	QNModel *model = [self getModel];
	if (model.accessKey > 0 && model.buckName > 0 && model.secretKey.length > 0) {
		return YES;
	}
	return NO;
}
+(NSString *)getKeyWithURL:(NSURL *)url data:(NSData *)data{
	if (url) {
		NSString *ex = url.pathExtension;
		NSString *path =[QiniuUploadManger hmacSha1Key:@"upload" textData:url.path];
		NSString *key=[NSString stringWithFormat:@"%@.%@",path,ex];
		return key;
	}else{
		NSTimeInterval time=[[NSDate dateWithTimeIntervalSinceNow:0]timeIntervalSince1970];
        NSString *type = [NSImage fy_imageFormatForImageData:data];
        if (type.length > 0) {
            return [NSString stringWithFormat:@"%lld%d.%@",(long long)time,rand()%100,type];
        }
		NSString *key=[NSString stringWithFormat:@"%lld%d",(long long)time,rand()%100];
		return key;
	}
}
static NSString *extracted(NSData *finData) {
    return [QiniuUploadManger getKeyWithURL:nil
                                       data:finData];
}

+ (void)testUploadData:(NSData *)data complate:(complateBlock)comB faild:(complateBlock)failB model:(QNModel *)model{
		  NSData *finData = data;
					QNUploadManager *upManager = [[QNUploadManager alloc] init];
					QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil
																		progressHandler:^(NSString *key, float percent) {
					}
																				 params:nil
																			   checkCrc:NO
																	 cancellationSignal:nil];
					__block typeof(upManager) __weakOption = upManager;
					complateBlock complate = ^(NSString *token) {
						[__weakOption putData:finData
                                          key:extracted(finData)
										token:token
									 complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
							NSLog(@"info ===== %@", info);
												NSLog(@"resp ===== %@", resp[@"key"]);
												//demo: http://blog.fgyong.cn/FgWZszb9RjqjYHDq4ILg7uanCslw
												if (resp.count > 0) {
													if (comB) {
														comB(@"");
													}
												}else{
													if (failB) {
														failB(@"");
													}
//													[[FYNotification share] pushErrorWithMsg:@"发生错误，请重新配置参数!"];
												}
						}
									   option:uploadOption];
					};
	
			NSString *token =[UtilTool makeToken:model.accessKey
												secretKey:model.secretKey
													 buck:model.buckName];
					complate(token);
}
+ (void)uploadImage:(NSArray<NSString*>  * _Nullable)urls data:(NSArray<NSData*>  * _Nullable )datas{
	if ([QiniuUploadManger hasInfo] == NO) {
		[[FYNotification share] pushErrorWithMsg:@"请先设置图床平台！"];
		return;
	}
    if (urls.count > 0) {
        [QiniuUploadManger shareDefault].filesCount = urls.count;
    }
    else if(datas.count){
        [QiniuUploadManger shareDefault].filesCount += datas.count;
    }
    NSMutableArray<NSData *> *mutData = [NSMutableArray array];
    NSFileManager *manger = [NSFileManager defaultManager];

    for (int i = 0; i < urls.count; i ++) {
        NSString *obj = urls[i];
        if([manger fileExistsAtPath:obj]){
             NSData *itemData = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj]];
             [mutData addObject:itemData];
         }
    }

    [mutData addObjectsFromArray:datas];
    if (mutData.count == 0) {
        [FYNotification.share pushErrorWithMsg:@"图片为空哦！"];
        return;
    }
	//重置当前索引
	[QiniuUploadManger shareDefault].currentFileIndex = 0;

    [mutData enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSData *finData = obj;
        QNModel *model=[QiniuUploadManger getModel];
                QNUploadManager *upManager = [[QNUploadManager alloc] init];
                QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil
                                                                    progressHandler:^(NSString *key, float percent) {
                }
                                                                             params:nil
                                                                           checkCrc:NO
                                                                 cancellationSignal:nil];
                __block typeof(upManager) __weakOption = upManager;
                complateBlock complate = ^(NSString *token) {
                    [__weakOption putData:finData
                                      key:[QiniuUploadManger getKeyWithURL:nil
                                                                      data:finData]
                                    token:token
                                 complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                        NSLog(@"info ===== %@", info);
                                            NSLog(@"resp ===== %@", resp[@"key"]);
                                            //demo: http://blog.fgyong.cn/FgWZszb9RjqjYHDq4ILg7uanCslw
                                            if (resp.count > 0) {
												NSString *yuming = [QNModel yuming];
                                                NSString *fullURL=[NSString stringWithFormat:@"![](%@/%@)",yuming,key];
                                                //发推送
                                                [[FYSourceManger share] addURLWithUrl:fullURL];
												[NSPasteboard.generalPasteboard addUrlToPasteWithMsg:fullURL shouldClear:^BOOL{
													if (QiniuUploadManger.shareDefault.currentFileIndex == 0) {
														return true;
													}
													return false;
												} complate:^{
													QiniuUploadManger.shareDefault.currentFileIndex += 1;
												}];
                                                [[FYNotification share] pushWithUrl:fullURL];
                                            }else{
                                                [[FYNotification share] pushErrorWithMsg:@"发生错误，请重新上传！"];
                                            }
                    }
                                   option:uploadOption];
                };
//                complateBlock faildBlock = ^(NSString *error){
//                    NSLog(@"error:%@",error);
//                };
		NSString *token =[UtilTool makeToken:model.accessKey
											secretKey:model.secretKey
												 buck:model.buckName];
				complate(token);
    }];

	
}

+ (void)gotTokenqnModel:(QNModel *)model Complate:(complateBlock)complate faild:(complateBlock)faild {

    if ([QiniuUploadManger shareDefault].token.length) {
        complate([QiniuUploadManger shareDefault].token);
        return;
    }
    [QiniuUploadManger shareDefault] .block = complate;
	AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
	AFHTTPResponseSerializer* serial = [AFHTTPResponseSerializer serializer];
	[manger setResponseSerializer:serial];
    NSString *url =[NSString stringWithFormat:@"http://localhost:8080/tk?accessKey=%@&secretKey=%@&bucketName=%@",model.accessKey,model.secretKey,model.buckName];
    
	[manger GET:url
	 parameters:nil
	   progress:^(NSProgress * _Nonnull downloadProgress) {
		NSLog(@"NSProgress:%lld",downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSDictionary *info = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject
																			 options:NSJSONReadingMutableContainers
																			   error:nil];
		
		NSLog(@"task:%@",info);
		if ([info[@"status"] isEqualTo:@"success"]) {
			if (complate) {
				complate(info[@"data"][@"token"]);
			}
		}else{
			if (faild) {
				faild(info[@"msg"]);
			}
		}
		
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		faild(error.description);
#if DEBUG
		NSLog(@"error:%@",error);
#endif
	}];
}


+  (NSString*)dictionryToJSONString:(NSMutableDictionary *)dictionary
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//AccessKey  以及SecretKey
+ (NSString *)getTokenWithModel:(QNModel *)model{
	
    return [QiniuUploadManger makeToken:model.accessKey
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
    NSString *secretKeyBase64 =  [QiniuUploadManger hmacSha1Key:secretKey textData:baseNameBase64];
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, secretKeyBase64, baseNameBase64];

    return token;
}

+ (NSString *)marshal:(NSString *)name
{
    time_t deadline;
    time(&deadline);
    //"ceshi" 是我们七牛账号下创建的储存空间名字“可以自定义”
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:name
			forKey:@"scope"];
    //3464706673 是token有效期
	NSTimeInterval time=[[NSDate dateWithTimeIntervalSinceNow:60*60*24*1000] timeIntervalSince1970];
//	NSString *randName=[NSString stringWithFormat:@"%d-%4ld",(long long)time,rand()%10000];
    NSNumber *escapeNumber = [NSNumber numberWithLongLong:(long long)time];
    [dic setObject:escapeNumber forKey:@"deadline"];
    NSString *json = [QiniuUploadManger dictionryToJSONString:dic];
    return json;
}

@end
