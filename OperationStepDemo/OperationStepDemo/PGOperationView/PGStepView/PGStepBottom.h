//
//  StepBottom.h
//  OperationStepDemo
//
//  Created by 姚东 on 17/5/19.
//  Copyright © 2017年 姚东. All rights reserved.
//

#import <UIKit/UIKit.h>
#define  WIDTH [UIScreen mainScreen].bounds.size.width
/// 底部视图高度 Step Bottom Height
#define S_B_H 50
/// 底部按钮高度 Step Bottom Button Height
#define S_BB_H 36
/// 底部按钮高度 Step Bottom Button Weight  按比例计算
#define S_BB_W WIDTH*0.3
 
/// 不可点击颜色
#define UnAble_Color [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]
/// 可点击颜色
#define Able_Color [UIColor colorWithRed:199/255.0 green:167/255.0 blue:123/255.0 alpha:1]



@interface StepBottomButton : UIButton
// 默认为不可点击
@property (nonatomic, assign)BOOL isAble;
@end



@protocol BottomButtonDelegate <NSObject>

- (void)clickButtonTag:(NSInteger)tag;

@end
@interface PGStepBottom : UIView
@property (nonatomic ,assign) id<BottomButtonDelegate>delegate;
///titles 按钮名称
@property (nonatomic ,strong) NSArray * titles;

///buttons 按钮
@property (nonatomic ,strong) NSMutableArray <StepBottomButton *>* buttons;
///起始位置
@property (nonatomic ,assign) CGSize XY;
@end




