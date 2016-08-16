//
//  NSImage+Catgory.m
//  PcreateImageAuto
//
//  Created by Peng xi cheng on 16/8/14.
//  Copyright © 2016年 com.hengfu. All rights reserved.
//

#import "NSImage+Catgory.h"

@implementation NSImage (Catgory)

- (BOOL)saveAtPath:(NSString *)path
{
    NSData *imageData = [self TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
    return [imageData writeToFile:path atomically:NO];
}

- (NSImage*)reSize:(NSSize)resize
{
//    float resizeWidth = resize.width/2;
//    float resizeHeight = resize.height/2;
    float resizeWidth = resize.width;
    float resizeHeight = resize.height;
    
    NSImage *resizedImage = [[NSImage alloc] initWithSize:NSMakeSize(resizeWidth, resizeHeight)];
    NSSize originalSize = [self size];
    [resizedImage lockFocus];
    [self drawInRect:NSMakeRect(0, 0, resizeWidth, resizeHeight) fromRect:(NSMakeRect(0, 0, originalSize.width, originalSize.height)) operation:NSCompositeSourceOver fraction:1.0];
    
    [resizedImage unlockFocus];
    return resizedImage;

}
@end
