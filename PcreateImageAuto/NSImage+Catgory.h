//
//  NSImage+Catgory.h
//  PcreateImageAuto
//
//  Created by Peng xi cheng on 16/8/14.
//  Copyright © 2016年 com.hengfu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Catgory)
-(NSImage*)reSize:(NSSize)resize;
- (BOOL)saveAtPath:(NSString *)path;
@end
