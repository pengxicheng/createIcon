//
//  DragImageZone.m
//  PcreateImageAuto
//
//  Created by Peng xi cheng on 16/8/14.
//  Copyright © 2016年 com.hengfu. All rights reserved.
//

#import "DragImageZone.h"

@implementation DragImageZone

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //注册拖放类型为NSFilenamesPboardType
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
        [self dropAreaFadeOut];
    }
    
    return self;
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        //注册拖放类型为NSFilenamesPboardType
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
        [self dropAreaFadeOut];
    }
    return self;
}

- (void)dropAreaFadeIn
{
    [self setAlphaValue:1.0];

}

- (void)dropAreaFadeOut
{
    [self setAlphaValue:0.2];
}

//图片资源适配自动化工具
//支持的拖放操作的类型，对于图片的操作这里返回的是NSDragOperationLink
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    
    NSLog(@"drag operation entered");
    sourceDragMask = [sender draggingSourceOperationMask];
    
    pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        [self dropAreaFadeIn];
        
        if (sourceDragMask & NSDragOperationLink) {
            return NSDragOperationLink;
        }else if(sourceDragMask & NSDragOperationCopy){
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;

}

//拖放结束的处理
- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    NSLog(@"drag operation finished");
    
    [self dropAreaFadeOut];

}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    NSLog(@"drop now");
    
    [self dropAreaFadeOut];
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        NSInteger numberOfFiles = [files count];
        if (numberOfFiles > 0) {
            NSString *filePath = [files objectAtIndex:0];
            
            if (self.delegate) {
                [self.delegate didFinishDragwithFile:filePath];
            }
            return YES;
        }
        else{
            NSLog(@"drag file num = 0 return!");
        }
    }
    else
    {
        NSLog(@"pboard types(%@) not register!",[pboard types]);
    
    }
    return YES;

}

/**
 NSDraggingDestination协议中实现3个方法说明
 1、（NSDragOperation）draggingEntered:(id)sender 返回支持的拖放操作的类型：对于图片操作这里返回时NSDragOperationLink
 2、(void)dragginExited:(id)info拖放结束的处理
 3、（Bool）performDragOperation:(id)sender最关键的方法，返回拖放的文件拖放文件路径
 另外在类的init方法中，注册了拖放类型为NSFilenamesPboardType.
 [self registerForDraggenTyes:[NSArray arraywithobjects:NSFilenamesPboardTyoe,nil]];
 
 */
@end
