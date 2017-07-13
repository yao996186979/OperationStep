//
//  ProgressButton.h
//  PanguSPD
//
//  Created by 姚东 on 17/4/24.
//  Copyright © 2017年 yxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark  基础配置

#define SelectedTitleColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0] //选中字体颜色
#define SelectedStrokeColor [UIColor colorWithRed:199/255.0 green:167/255.0 blue:123/255.0 alpha:1/1.0] // 选中填充颜色
#define SelectedfillColor [UIColor colorWithRed:199/255.0 green:167/255.0 blue:123/255.0 alpha:1/1.0] // 选中线框颜色
#define UnSelectedTitleColor [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] // 未选中字体颜色
#define UnSelectedStrokeColor [UIColor colorWithRed:219/255.0 green:217/255.0 blue:213/255.0 alpha:1/1.0] // 未选中填充颜色
#define UnSelectedfillColor [UIColor colorWithRed:219/255.0 green:217/255.0 blue:213/255.0 alpha:1/1.0] // 未选中线框颜色

#define tipWidth 20       // 箭头三角长度
#define CircleDefautD  9   // 圆圈默认直径
#define CircleFillD    16   // 圆圈填充直径
#define CircleHaloD    22  // 光晕背景直径
#define LineWidthDefault    (self.frame.size.width-CircleDefautD)/2 //默认线宽
#define LineWidthSelect    (self.frame.size.width-CircleFillD)/2 //选中线宽
#define LineCirclY   self.frame.size.height/3   //起始高度
#define AnimationDuration  0.5
typedef  NS_ENUM(NSInteger,SelectorType){
    SelectorTypeUnSelected,      //未选中
    SelectorTypeSelected,        //选中
    SelectorTypeHaveInfoUnSelected, //有信息未选中
};
typedef  NS_ENUM(NSInteger,StyleType){
    StyleTypeStart,      //开始样式
    StyleTypeMiddle,     //中间样式
    StyleTypeEnd,        //结束样式
    StyleTypeLineCircle  //线圈样式
};
typedef  NS_ENUM(NSInteger,FormType){
    FormTypeTip,         //箭头形式
    FormTypeLineCircle,  //线圈形式
};
typedef  NS_ENUM(NSInteger,LineCircleSpecialType){
    LineCircleSpecialTypeNoAnimation,  //第一个不需要动画
    LineCircleSpecialTypeAllAnimation, //最后一个走完动画
    LineCircleSpecialTypeNormalAnimation, //正常动画
};
@interface PGStepTop : UIButton
// 显示形式
@property (nonatomic ,assign)FormType formType;
// 选中类型
@property (nonatomic ,assign)SelectorType  selectorType;
// 展示样式
@property (nonatomic ,assign)StyleType  styleType;
// 下标
@property (nonatomic ,assign)NSInteger index;
// 动画
@property (nonatomic ,assign)LineCircleSpecialType specialType;
//初始化
- (instancetype) initWithTitle:(NSString *) title frame:(CGRect)frame;
@end
