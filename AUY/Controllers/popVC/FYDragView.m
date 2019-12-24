//
//  FYDragView.m
//  AUY
//
//  Created by fgy on 2019/12/22.
//  Copyright © 2019 www.fgyong.cn. All rights reserved.
//

#import "FYDragView.h"

@implementation FYDragView
- (void)config{
	[self registerForDraggedTypes:@[NSFilenamesPboardType]];
	self.wantsLayer = YES;
	self.layer.backgroundColor = [NSColor colorWithRed:0.1 green:1 blue:1 alpha:1].CGColor;
}
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender{
    NSPasteboard *pboard = [sender draggingPasteboard];
      if ([[pboard types] containsObject:NSFilenamesPboardType]) {
          NSLog(@"copy");
          return NSDragOperationCopy;
      }
      
      return NSDragOperationNone;
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender{
		// 1）、获取拖动数据中的粘贴板
		NSPasteboard *zPasteboard = [sender draggingPasteboard];
		// 2）、从粘贴板中提取我们想要的NSFilenamesPboardType数据，这里获取到的是一个文件链接的数组，里面保存的是所有拖动进来的文件地址，如果你只想处理一个文件，那么只需要从数组中提取一个路径就可以了。
		NSArray *list = [zPasteboard propertyListForType:NSFilenamesPboardType];
		
		for (int i = 0; i < list.count; i ++) {
	        NSURL *url =[NSURL fileURLWithPath:list[i]];
			NSData *data =[NSData dataWithContentsOfFile:list[i]];
//			self.image = [[NSImage alloc] initWithData:data];
			NSLog(@"dataSize:%ld",data.length);
		}
}


@end
