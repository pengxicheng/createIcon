//
//  ViewController.m
//  PcreateImageAuto
//
//  Created by Peng xi cheng on 16/8/14.
//  Copyright © 2016年 com.hengfu. All rights reserved.
//

#import "ViewController.h"
#import "DragImageZone.h"
#import "NSImage+Catgory.h"
@interface ViewController ()<DragImageZoneDelegate,NSComboBoxDelegate,NSComboBoxDataSource,NSOpenSavePanelDelegate>
@property (strong) IBOutlet NSTextField *label;
@property (strong) IBOutlet DragImageZone *dragImage;
@property (strong) IBOutlet NSComboBox *comboBox;
@property (strong) IBOutlet NSButton *exportBtn;
@property (weak) IBOutlet NSTextField *messageLable;


@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)NSURL *saveUrl;

@property (nonatomic,strong)NSImage *pimage;

@property (nonatomic,strong)NSDictionary *bigDir;
@property (nonatomic,strong)NSDictionary *typeDir;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 0;
    [self.comboBox selectItemAtIndex:0];
    self.dragImage.delegate = self;
    self.comboBox.delegate = self;

    // Do any additional setup after loading the view.
}
- (IBAction)expotBtn:(id)sender {
    if (!self.pimage) {
        self.messageLable.cell.title = @"请先拖入需要裁剪的图片";
        self.messageLable.textColor = [NSColor redColor];
        return;
       
    }
    //找到保存的路径
    NSSavePanel *savepanel  = [NSSavePanel savePanel];
    savepanel.canCreateDirectories = NO;
    savepanel.delegate = self;
    [savepanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSSaveAsOperation) {
   
        }
        else{
            self.messageLable.cell.title = @"未选择保存路径";
            self.messageLable.textColor = [NSColor redColor];
        }
        
    }];

}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (IBAction)comboAction:(id)sender {
    NSComboBox *boBox = (NSComboBox *)sender;
    self.index = boBox.indexOfSelectedItem;
}

- (void)didFinishDragwithFile:(NSString*)filePath
{
    //拖来图片的路径
    self.messageLable.cell.title = filePath;
    
    self.pimage = [[NSImage alloc] initByReferencingFile:filePath];
}


- (BOOL)panel:(id)sender validateURL:(NSURL *)url error:(NSError **)outError
{
    if (!outError) {
        return YES;
    }else
    {
        self.saveUrl = url;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PxcList" ofType:@"plist"];
    if (path) {
        self.bigDir = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    //根据类型导出不同的图片
    switch (self.index) {
        case 0:
        {
            //iphone
            if (self.bigDir) {
                self.typeDir = [self.bigDir objectForKey:@"iPhone"];
                if (self.typeDir) {
                [self exportImage:self.typeDir];
                }
            }
            
        }
            break;
        case 1:
        {
            //ipad
            if (self.bigDir) {
                self.typeDir = [self.bigDir objectForKey:@"iPad"];
                if (self.typeDir) {
                    [self exportImage:self.typeDir];
                }
            }

            
        }
            break;
        case 2:
        {
            //iphone + ipad
            if (self.bigDir) {
                self.typeDir = [self.bigDir objectForKey:@"iPhone"];
                if (self.typeDir) {
                    [self exportImage:self.typeDir];
                }
            }
                        //ipad
            if (self.bigDir) {
                self.typeDir = [self.bigDir objectForKey:@"iPad"];
                if (self.typeDir) {
                    [self exportImage:self.typeDir];
                }
            }
        }
            break;
        case 3:
        {
            //osx
            if (self.bigDir) {
                self.typeDir = [self.bigDir objectForKey:@"OSX"];
                if (self.typeDir) {
                    [self exportImage:self.typeDir];
                }
            }
        }
            break;
        default:
            break;
    }
    return YES;

}

- (void)exportImage:(NSDictionary *)dic
{
    if (dic) {
        NSArray *keyArray = [dic allKeys];
        for (int i = 0; i < keyArray.count; i++) {
            NSString *title = [keyArray objectAtIndex:i];
            NSArray *arryValue = [dic objectForKey:[keyArray objectAtIndex:i]];
            
            for (int j = 0; j < arryValue.count; j++) {
                NSNumber *nub = [arryValue objectAtIndex:j];
                NSImage *image = [self.pimage reSize:NSMakeSize([title floatValue] * [nub intValue], [title floatValue] * [nub intValue])];
                
                NSString *urlStr = [[NSString stringWithFormat:@"%@",self.saveUrl] substringFromIndex:8];
                NSArray *listItems = [urlStr componentsSeparatedByString:@"/"];
                NSString * lastStr = [NSString stringWithFormat:@""];
                
                for (int  i = 0; i < [listItems count] - 1 ; i ++ ) {
                    if([NSString stringWithFormat:@"/%@",[listItems objectAtIndex:i]].length > 0)
                    {
                        lastStr  = [lastStr stringByAppendingString:[NSString stringWithFormat:@"/%@",[listItems objectAtIndex:i]]];
                    }
                }
                NSString *pathStr = [NSString stringWithFormat:@"%@/%@*%@@%dx.png",lastStr,title,title,[nub intValue]];
                BOOL isSave =  [image saveAtPath:pathStr];
                if (isSave) {
                    self.messageLable.cell.title = [NSString stringWithFormat:@"裁剪成功to:%@",pathStr];
                    self.messageLable.textColor = [NSColor greenColor];
                }
                
            }
        }
    }
}
@end


