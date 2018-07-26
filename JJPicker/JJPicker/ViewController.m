//
//  ViewController.m
//  JJPicker
//
//  Created by 16 on 2018/7/26.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "ViewController.h"
#import "JJPicker.h"

@interface ViewController ()

@end

@implementation ViewController
{
    JJPicker *picker;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableArray *house = [NSMutableArray array];
    for (NSInteger i = 0; i < 24; i++) {
        [house addObject:@(i+1)];
    }
    NSMutableArray *minute = [NSMutableArray array];
    for (NSInteger i = 0; i < 60; i++) {
        [minute addObject:@(i+1)];
    }
    picker = [[JJPicker alloc] initCustomPickerWithTitle:@"标题" showType:JJPickerShowTypeCenter reload:^(NSInteger index, id tag) {
        if (index == 1) {
            [self->picker reloadComponent:index itmes:minute];
        }
    } completion:^(id data) {
        NSLog(@"%@",data);
    }];
    [picker setUpItems:house];
    
    picker = [[JJPicker alloc] initDatePickerWithTitle:@"" showType:JJPickerShowTypeBottom completion:^(id data) {
        
    }];
}
@end
