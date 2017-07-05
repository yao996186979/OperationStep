//
//  InputTextView.h
//  PanguSPD
//
//  Created by 姚东 on 17/4/21.
//  Copyright © 2017年 yxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSInteger,TextType){
    TextTypeNormal,       //普通文本输入
    TextTypeDate,         ///日期文本输入
    TextTypeSelector,     //文本选择输入
    TextTypeOnlyShow,     //仅显示
    TextTypeLongText,     //长文本输入
    TextTypePlaceholder   //仅用来占位
};
@class PGInputTextView;
@protocol PGInputTextViewDelegate <NSObject>

/**
  事件方法
 @param view self
 */
- (void)pgInputTextViewAction:(PGInputTextView*)view;

@end

@interface PGInputTextView : UIView

///定义代理属性,用来存储代理对象
@property (nonatomic, weak) id<PGInputTextViewDelegate>delegate;
///对外公布的选择数据
@property (nonatomic,strong) id value;
///文本输入类型
@property (nonatomic,assign)TextType type;
/**
 初始化方法

 @param title 标题
 @param frame 位置
 @return 返回InputTextView
 */
- (instancetype)initWithTitle:(NSString*)title frame:(CGRect)frame;

@end
