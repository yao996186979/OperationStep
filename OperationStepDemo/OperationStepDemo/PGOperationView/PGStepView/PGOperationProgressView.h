//
//  PGOperationProgressView.h
//  PGOperationProgressView
//
//  Created by 姚东 on 17/7/26.
//  Copyright © 2017年 姚东. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark  基础配置

#define SelectedTitleColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0] //选中字体颜色
#define SelectedStrokeColor [UIColor colorWithRed:199/255.0 green:167/255.0 blue:123/255.0 alpha:1/1.0] // 选中填充颜色
 
#define UnSelectedTitleColor [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] // 未选中字体颜色
#define UnSelectedStrokeColor [UIColor colorWithRed:219/255.0 green:217/255.0 blue:213/255.0 alpha:1/1.0] // 未选中填充颜色

#define CircleDefautD  9   // 圆圈默认直径
#define CircleFillD    16   // 圆圈填充直径
#define CircleHaloD    22  // 光晕背景直径
 
#define LineCirclY   self.frame.size.height/3   //起始高度
#define AnimationDuration  0.5

typedef  NS_ENUM(NSInteger,PGStepButtonState){
    PGStepButtonStateUnSelected,         //未选中
    PGStepButtonStateSelected,           //选中
    PGStepButtonStateHaveInfoUnSelected, //有信息未选中
};
@interface PGStepButton : UIButton
@property (nonatomic ,assign) PGStepButtonState stepState;


@end

@class PGOperationProgressView;
@protocol PGOperationProgressViewDelegate <NSObject>

/**
 ProgressView 操作
 
 @param button 按钮
 */
- (void)operationProgressView:(PGOperationProgressView*)progressView Action:(PGStepButton*)button;
@end
@interface PGOperationProgressView : UIView
//协议方法
@property (nonatomic ,weak) id <PGOperationProgressViewDelegate> operationDelegate;
//记录按钮信息
@property (nonatomic ,strong)NSMutableArray <PGStepButton *>* stepButtonArr;
/**
 初始化方法
 @param frame 尺寸
 @param titles 标题 组
 @return PGOperationProgressView
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;


/**
  指定位置移动

 @param x x为末尾位置（这样方便计算）
 */
- (void)startAnimationMoveToPointX:(float)x;
//指定步骤移动
- (void)startAnimationMoveToStep:(NSInteger)step;
@end
