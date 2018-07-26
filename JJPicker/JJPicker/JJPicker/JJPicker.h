//
//  JJPicker.h
//  JJPicker
//
//  Created by 16 on 2018/7/26.
//  Copyright © 2018年 冀佳伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ///居中显示
    JJPickerShowTypeCenter = 0,
    ///底部显示
    JJPickerShowTypeBottom = 1
}JJPickerShowType;

typedef void(^JJPickerCompletion)(id data);
typedef void(^JJPickerReload)(NSInteger index,id tag);
@interface JJPicker : UIView

///自定义数据源(只读)
@property (nonatomic , strong , readonly) NSArray *items;
///文字颜色(默认黑色)
@property (nonatomic , strong) UIColor *textColor;

/**
 * 设置第一层数据源
 * @param items 设置第一层自定义数据源
 */
- (void)setUpItems:(NSArray *)items;

/**
 * 刷新某一层自定义数据
 * @param component 需要刷新的层数
 * @param items 需要刷新层数的数据源
 */
- (void)reloadComponent:(NSInteger)component itmes:(NSArray *)items;

/**
 * 初始化自定义选择器
 * @param title 标题
 * @param reload 刷新block,如果是自定义就传nil
 * @param completion 完成block
 */
- (instancetype)initCustomPickerWithTitle:(NSString *)title showType:(JJPickerShowType)showType reload:(JJPickerReload)reload completion:(JJPickerCompletion)completion;

/**
 * 初始化时间选择器
 * @param title 标题
 * @param showType 显示类型,居中显示或底部显示
 * @param completion 完成block
 */
- (instancetype)initDatePickerWithTitle:(NSString *)title showType:(JJPickerShowType)showType completion:(JJPickerCompletion)completion;

@end
