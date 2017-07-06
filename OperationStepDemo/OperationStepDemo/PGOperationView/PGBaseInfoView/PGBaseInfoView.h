//
//  PGBaseInfoView.h
//  PGCreatOrEdit
//
//  Created by 姚东 on 17/7/5.
//  Copyright © 2017年 姚东. All rights reserved.
//


/*
 1:认识此view 是 装载 多个 PGInputTextView 的 基础视图
 2:输入数量过多时 考虑滑动处理
 3:是否需要 在外部接口处直接 设置 排列顺序（存在 空位情况  可以设置PGInputTextView的type 有一种占位情况）
 4:提供外部的数据变换 应该以怎样的形式呈现 (可以用 键值 方式存储)
 */

#import <UIKit/UIKit.h>
#import "PGInputTextView.h"

@protocol PGBaseInfoViewDelegate <NSObject>

- (void)valueChangeOfPGInputTextView:(PGInputTextView*)inputTextView;

@end
@interface PGBaseInfoView : UIScrollView <PGInputTextViewDelegate>


/**
 初始化 基本信息页面

 @param frame 大小
 @param titles 标题
 @param types 类型
 @param values 初始值
 @return PGBaseInfoView
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titles types:(NSArray<NSNumber*>*)types values:(NSArray*)values;

@property (nonatomic ,weak) id <PGBaseInfoViewDelegate> inputDelegate;

@end
