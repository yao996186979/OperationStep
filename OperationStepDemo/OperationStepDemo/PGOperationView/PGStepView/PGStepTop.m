//
//  ProgressButton.m
//  PanguSPD
//
//  Created by 姚东 on 17/4/24.
//  Copyright © 2017年 姚东. All rights reserved.
//

#import "PGStepTop.h"

@interface PGStepTop ()
@property (nonatomic ,strong) CAShapeLayer * alayer;
@property (nonatomic ,strong) CAShapeLayer * selectLayer;

@property (nonatomic ,strong) CATextLayer *  indexLayer;
@property (nonatomic ,strong) CATextLayer *  titleLayer;
@end

@implementation PGStepTop
- (instancetype) initWithTitle:(NSString *)title frame:(CGRect)frame{
    if(self = [super init]){
        
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.frame = frame;
        
}
    return self;
}
- (void)setStyleType:(StyleType)styleType{

    UIBezierPath* aPath = [UIBezierPath bezierPath];
    switch (styleType) {
        case StyleTypeStart:
            [self drawStartStyleWithPath:aPath];
            break;
        case StyleTypeMiddle:
            [self drawMiddleStyleWithPath:aPath];
            break;
        case StyleTypeEnd:
            [self drawEndStyleWithPath:aPath];
            break;
        case StyleTypeLineCircle:
            [self drawLineCircleStyleWithPath:aPath];
            break;
        default:
            break;
    }
    [aPath closePath];
    _alayer = [[CAShapeLayer alloc]init];
    _alayer.path = aPath.CGPath;
    
    [self.layer insertSublayer:_alayer atIndex:0];
    
    self.selectorType = SelectorTypeUnSelected; //默认未选中
}
- (void)setSelectorType:(SelectorType)selectorType{
    
    if (self.formType == FormTypeTip) {
        switch (selectorType) {
            case SelectorTypeUnSelected:
                [self setTitleColor: UnSelectedTitleColor forState:UIControlStateNormal];
                _alayer.strokeColor = UnSelectedStrokeColor.CGColor;
                _alayer.fillColor = UnSelectedfillColor.CGColor;
                break;
            case SelectorTypeSelected:
                [self setTitleColor:SelectedTitleColor forState:UIControlStateNormal];
                _alayer.strokeColor = SelectedStrokeColor.CGColor;
                _alayer.fillColor = SelectedfillColor.CGColor;
                break;
            default:
                break;
        }
    }
    else{
        switch (selectorType) {
            case SelectorTypeUnSelected:
                [self setTitleColor: [UIColor clearColor] forState:UIControlStateNormal];
                _alayer.strokeColor = [UIColor blackColor].CGColor;
                _alayer.fillColor = [UIColor blackColor].CGColor;
                break;
            case SelectorTypeSelected:
                [self showLineCirclSelectAnimation];
                break;
            default:
                break;
        }

        
    }
    
}
// 画开始样式
- (void)drawStartStyleWithPath:(UIBezierPath*)aPath{
    [aPath moveToPoint:CGPointMake(0, 0)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width-tipWidth, 0)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width-tipWidth,self.frame.size.height)];
    [aPath addLineToPoint:CGPointMake(0,self.frame.size.height)];
}
// 画中间样式
- (void)drawMiddleStyleWithPath:(UIBezierPath*)aPath{
    [aPath moveToPoint:CGPointMake(0, 0)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width-tipWidth, 0)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width-tipWidth,self.frame.size.height)];
    [aPath addLineToPoint:CGPointMake(0,self.frame.size.height)];
    [aPath addLineToPoint:CGPointMake(tipWidth, self.frame.size.height/2)];
}
// 画结束样式
- (void)drawEndStyleWithPath:(UIBezierPath*)aPath{
    [aPath moveToPoint:CGPointMake(0, 0)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width, 0)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [aPath addLineToPoint:CGPointMake(0,self.frame.size.height)];
    [aPath addLineToPoint:CGPointMake(tipWidth, self.frame.size.height/2)];;
}
// 画线圈样式 描述文字
- (void)drawLineCircleStyleWithPath:(UIBezierPath*)aPath{
    
    [aPath moveToPoint:CGPointMake(0, LineCirclY)];
    [aPath addLineToPoint:CGPointMake(LineWidthDefault, LineCirclY)];
    [aPath addArcWithCenter:CGPointMake(LineWidthDefault+CircleDefautD/2, LineCirclY) radius:CircleDefautD/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [aPath addLineToPoint:CGPointMake(LineWidthDefault+CircleDefautD+LineWidthDefault, LineCirclY)];
    
    //文字部分
    self.titleLayer = [[CATextLayer alloc]init];
    self.titleLayer.string = self.titleLabel.text;
    self.titleLayer.bounds = CGRectMake(0, 0, self.frame.size.width, 19);
    //字体的名字 不是 UIFont
    self.titleLayer.font = (__bridge CFTypeRef _Nullable)(@"PingFangSC-Regular");
    //字体的大小
    self.titleLayer.fontSize = 13.f;
    
    self.titleLayer.alignmentMode = kCAAlignmentCenter;//字体的对齐方式
    self.titleLayer.position = CGPointMake(self.frame.size.width/2,LineCirclY+25);
    self.titleLayer.foregroundColor = UnSelectedTitleColor.CGColor;//字体的颜色
    [self.layer addSublayer:self.titleLayer];
    
}
// 线圈选中动画效果 遵循 线圈线原则
- (void)showLineCirclSelectAnimation{
    
//    背景图层
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    [aPath moveToPoint:CGPointMake(0, LineCirclY)];
    [aPath addLineToPoint:CGPointMake(LineWidthSelect, LineCirclY)];
    
    [aPath addArcWithCenter:CGPointMake(LineWidthSelect+CircleFillD/2, LineCirclY) radius:CircleFillD/2 startAngle:M_PI endAngle:3*M_PI clockwise:YES];
    [aPath addLineToPoint:CGPointMake(LineWidthDefault+CircleFillD+LineWidthDefault, LineCirclY)];
    
    
    _selectLayer = [[CAShapeLayer alloc]init];
    _selectLayer.path = aPath.CGPath;
    _selectLayer.fillColor = SelectedfillColor.CGColor;
    _selectLayer.strokeColor = SelectedfillColor.CGColor;
    [self.layer addSublayer:_selectLayer];
    
//    文字部分
    CATextLayer * textLayer = [[CATextLayer alloc]init];
    textLayer.string = [NSString stringWithFormat:@"%ld",(long)self.index];
    textLayer.bounds = CGRectMake(0, 0, CircleFillD, CircleFillD);\
     //字体的名字 不是 UIFont
    textLayer.font = (__bridge CFTypeRef _Nullable)(@"PingFangSC-Medium");
    //字体的大小
    textLayer.fontSize = 10.f;

    textLayer.alignmentMode = kCAAlignmentCenter;//字体的对齐方式
    textLayer.position = CGPointMake(LineWidthSelect+CircleFillD/2,LineCirclY);
    textLayer.foregroundColor = [UIColor whiteColor].CGColor;//字体的颜色
    [_selectLayer addSublayer:textLayer];
    
 
    [CATransaction begin];
    [CATransaction setAnimationDuration:5];
    _titleLayer.foregroundColor =SelectedfillColor.CGColor;
    [CATransaction commit];
   
   //覆盖图层
    CALayer *mask = [CALayer layer];
    mask.frame = _selectLayer.frame;
    CAShapeLayer *coverLayer = [CAShapeLayer layer];
    coverLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)].CGPath;
     coverLayer.bounds = CGRectMake(0, 0 ,self.frame.size.width,self.frame.size.height);
     coverLayer.position = CGPointMake(-self.frame.size.width/2, self.frame.size.height/2);
    [mask addSublayer:coverLayer];
    _selectLayer.mask = mask;
    CABasicAnimation *coverAnimation = [CABasicAnimation animation];
    coverAnimation.keyPath = @"position.x";
    coverAnimation.fromValue = @(-self.frame.size.width/2);
    coverAnimation.toValue = @(self.frame.size.width/2);
    coverAnimation.duration = 5;
    coverAnimation.removedOnCompletion = NO;
    [coverLayer addAnimation:coverAnimation forKey:nil];
 
    
}
@end
