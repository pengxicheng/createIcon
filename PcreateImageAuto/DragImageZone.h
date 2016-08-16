//
//  DragImageZone.h
//  PcreateImageAuto
//
//  Created by Peng xi cheng on 16/8/14.
//  Copyright © 2016年 com.hengfu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@protocol DragImageZoneDelegate <NSObject>

@optional
- (void)didFinishDragwithFile:(NSString*)filePath;

@end
@interface DragImageZone : NSImageView<NSDraggingDestination>

@property(weak) id<DragImageZoneDelegate> delegate;

@end


