//
//  NSImage+Format.m
//  AUY
//
//  Created by fgy on 2019/12/18.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import "NSImage+Format.h"

#import <AppKit/AppKit.h>


@implementation NSImage (Format)
+ (NSString *)fy_imageFormatForImageData:(nullable NSData *)data {
    if (!data) {
        return @"";
    }
    
    // File signatures table: http://www.garykessler.net/library/file_sigs.html
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"JPEG";
        case 0x89:
            return @"PNG"; //SDImageFormatPNG;
        case 0x47:
            return @"GIF";//SDImageFormatGIF;
        case 0x49:
        case 0x4D:
            return @"TIFF";//SDImageFormatTIFF;
        case 0x52: {
            if (data.length >= 12) {
                //RIFF....WEBP
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
                if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                    return @"WEBP";
                }
            }
            break;
        }
        case 0x00: {
            if (data.length >= 12) {
                //....ftypheic ....ftypheix ....ftyphevc ....ftyphevx
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, 8)] encoding:NSASCIIStringEncoding];
                if ([testString isEqualToString:@"ftypheic"]
                    || [testString isEqualToString:@"ftypheix"]
                    || [testString isEqualToString:@"ftyphevc"]
                    || [testString isEqualToString:@"ftyphevx"]) {
                    return @"HEIC";
                }
            }
            break;
        }
    }
    return @"";
}
@end
