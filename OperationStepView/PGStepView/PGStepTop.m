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

@end
