//
//  JJPicker.m
//  JJPicker
//
//  Created by 16 on 2018/7/26.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import "JJPicker.h"

#define title_h 50
#define sh self.frame.size.height
#define sw self.frame.size.width
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
@interface JJPicker ()<UIPickerViewDelegate,UIPickerViewDataSource>

///选择器类型
@property (nonatomic , strong) NSString *type;
///选择器展示类型
@property (nonatomic , assign) JJPickerShowType showType;
///完成按钮回调
@property (nonatomic , copy) JJPickerCompletion completion;
///刷新按钮回调
@property (nonatomic , copy) JJPickerReload reload;
///自定义picker视图
@property (nonatomic , strong) UIPickerView *customPicker;
///时间选择器
@property (nonatomic , strong) UIDatePicker *datePicker;
///选中自定义数组
@property (nonatomic , strong) NSMutableArray *select;
///自定义数据源
@property (nonatomic , strong , readwrite) NSArray *items;
///底部加载视图
@property (nonatomic , strong) UIView *bottom;
///标题
@property (nonatomic , strong) NSString *title;
@end
@implementation JJPicker

- (instancetype)initDatePickerWithTitle:(NSString *)title showType:(JJPickerShowType)showType completion:(JJPickerCompletion)completion
{
    self.type = @"date";
    self.showType = showType;
    self.completion = completion;
    self.title = title;
    return [self init];
}

- (instancetype)initCustomPickerWithTitle:(NSString *)title showType:(JJPickerShowType)showType reload:(JJPickerReload)reload completion:(JJPickerCompletion)completion
{
    self.showType = showType;
    self.completion = completion;
    self.reload = reload;
    self.title = title;
    return [self init];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if (self.showType == JJPickerShowTypeBottom) {
            [self creatBottom];
        }else {
            [self creatCenter];
        }
        
    }
    return self;
}
- (void)creatBottom
{
    CGFloat bottom_h = 0;
    if (iPhoneX) bottom_h = 34;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    
    // 底层背景按钮
    UIButton *backGroudBtn = [[UIButton alloc] initWithFrame:self.bounds];
    backGroudBtn.backgroundColor = [UIColor blackColor];
    backGroudBtn.alpha = 0.5;
    [backGroudBtn addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backGroudBtn];
    
    // 底部加载footer
    _bottom = [[UIView alloc] init];
    _bottom.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    [self addSubview:_bottom];
    _bottom.frame = CGRectMake(0, sh, sw, 210+bottom_h);
    _bottom.layer.cornerRadius = 5;
    _bottom.layer.masksToBounds = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _bottom.frame = CGRectMake(0, sh-210-bottom_h, sw, 210+bottom_h);
    }];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, title_h)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    cancel.backgroundColor = [UIColor clearColor];
    [_bottom addSubview:cancel];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, _bottom.frame.size.width-200, title_h)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = [NSString stringWithFormat:@"%@",_title];
    titleLab.textColor = [UIColor blackColor];
    [_bottom addSubview:titleLab];
    
    UIButton *sure = [[UIButton alloc] initWithFrame:CGRectMake(_bottom.frame.size.width-100, 0, 100, title_h)];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor colorWithRed:229/255.0 green:52/255.0 blue:53/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    sure.backgroundColor = [UIColor clearColor];
    [_bottom addSubview:sure];
    
    if ([self.type isEqualToString:@"date"]) {
        _datePicker = [[UIDatePicker alloc]init];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.frame = CGRectMake(0, title_h, _bottom.frame.size.width, 150);
        [_bottom addSubview:_datePicker];
    }else {
        _customPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, title_h, _bottom.frame.size.width, 150)];
        _customPicker.delegate = self;
        _customPicker.dataSource = self;
        [_bottom addSubview:_customPicker];
    }
}

- (void)creatCenter
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    
    // 底层背景按钮
    UIButton *backGroudBtn = [[UIButton alloc] initWithFrame:self.bounds];
    backGroudBtn.backgroundColor = [UIColor blackColor];
    backGroudBtn.alpha = 0.5;
    [backGroudBtn addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backGroudBtn];
    
    // 中间加载视图center
    _bottom = [[UIView alloc] init];
    _bottom.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    _bottom.layer.cornerRadius = 5;
    _bottom.layer.masksToBounds = YES;
    [self addSubview:_bottom];
    
    _bottom.frame = CGRectMake(15, sh/2-100, sw-30, 250);
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, _bottom.frame.size.width/2, title_h)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    cancel.backgroundColor = [UIColor clearColor];
    [_bottom addSubview:cancel];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bottom.frame.size.width, title_h)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = [NSString stringWithFormat:@"%@",_title];
    titleLab.textColor = [UIColor blackColor];
    [_bottom addSubview:titleLab];
    
    UIButton *sure = [[UIButton alloc] initWithFrame:CGRectMake(_bottom.frame.size.width/2, 200, _bottom.frame.size.width/2, title_h)];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor colorWithRed:229/255.0 green:52/255.0 blue:53/255.0 alpha:1.0] forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    sure.backgroundColor = [UIColor clearColor];
    [_bottom addSubview:sure];
    
    if ([self.type isEqualToString:@"date"]) {
        _datePicker = [[UIDatePicker alloc]init];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.frame = CGRectMake(0, title_h, _bottom.frame.size.width, 150);
        [_bottom addSubview:_datePicker];
    }else {
        _customPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, title_h, _bottom.frame.size.width, 150)];
        _customPicker.delegate = self;
        _customPicker.dataSource = self;
        [_bottom addSubview:_customPicker];
    }
}
- (void)setUpItems:(NSArray *)items
{
    self.items = @[items];
    self.select = [NSMutableArray array];
    [_items enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.select addObject:obj[0]];
    }];
    [self.customPicker reloadAllComponents];
    // 自动刷新下一列
    if (self.reload) {
        self.reload(1,self.items[0][0]);
    }
}
#pragma mark picker代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.items.count;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *data = self.items[component];
    return data.count;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 选中行和列
    NSArray *data = self.items[component];
    self.select[component] = data[row];
    // 刷新下一列
    if (self.reload) {
        self.reload(component+1,self.items[component][row]);
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sw/self.items.count, 50)];
    title.text = [NSString stringWithFormat:@"%@",self.items[component][row]];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = self.textColor;
    title.font = [UIFont systemFontOfSize:20];
    return title;
}
#pragma mark 刷新方法
- (void)reloadComponent:(NSInteger)component itmes:(NSArray *)items
{
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.items];
    if (temp.count <= component) {
        if (items.count) {
            [temp addObject:items];
            [self.select addObject:items[0]];
        }else {
            return;
        }
    }else {
        if (!items.count) {
            [temp removeObjectAtIndex:component];
            [self.select removeObjectAtIndex:component];
            self.items = temp;
            [self.customPicker reloadAllComponents];
            [self.customPicker selectRow:0 inComponent:component-1 animated:YES];
            return;
        }
        
        temp[component] = items;
        self.select[component] = items[0];
        [temp removeObjectsInRange:NSMakeRange(component+1, temp.count-component-1)];
        [self.select removeObjectsInRange:NSMakeRange(component+1, temp.count-component-1)];
    }
    
    self.items = temp;
    [self.customPicker reloadAllComponents];
    [self.customPicker selectRow:0 inComponent:component animated:YES];
}
#pragma mark 按钮点击事件
- (void)hidden
{
    if (self.showType == JJPickerShowTypeBottom) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _bottom.frame = CGRectMake(0, sh, sw, 200);
        } completion:^(BOOL finished) {
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self removeFromSuperview];
        }];
    }else {
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }
}
- (void)sure
{
    if (!self.completion) return;
    if ([self.type isEqualToString:@"date"]) {
        
        NSDate *selected = [self.datePicker date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date = [dateFormatter stringFromDate:selected];
        self.completion(date);
    }else {
        self.completion(self.select);
    }
    [self hidden];
}
@end
