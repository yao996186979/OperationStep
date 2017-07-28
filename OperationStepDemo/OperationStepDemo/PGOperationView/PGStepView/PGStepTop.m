//
//  ProgressButton.m
//  PanguSPD
//
//  Created by 姚东 on 17/4/24.
//  Copyright © 2017年 姚东. All rights reserved.
//

#import "PGStepTop.h"

@interface PGStepTop () <CAAnimationDelegate>
@property (nonatomic ,strong) CAShapeLayer * alayer;
//选中图层样式
@property (nonatomic ,strong) CAShapeLayer * selectLayer;
//覆盖图层样式 用来做动画
@property (nonatomic ,strong) CAShapeLayer * coverLayer;
//圈中文字
@property (nonatomic ,strong) CATextLayer * textLayer;
//选中动画
@property (nonatomic ,strong) CABasicAnimation *coverAnimation;
//未选中有信息动画
@property (nonatomic ,strong) CABasicAnimation *afterCoverAnimation;
//标题文字
@property (nonatomic ,strong) CATextLayer *  titleLayer;
//光圈
@property (nonatomic ,strong) CAShapeLayer * circleLayer;
//水纹动画
@property (nonatomic ,strong) CAAnimationGroup *groupAnima;

//执行过前动画
@property (nonatomic ,assign)BOOL doneBefore;
//执行过后动画
@property (nonatomic ,assign)BOOL doneAfter;
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
#pragma mark 设置样式
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
#pragma mark 设置状态
- (void)setSelectorType:(SelectorType)selectorType{
    _selectorType = selectorType;
    //箭头形式
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
    //线圈形式
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
            case SelectorTypeHaveInfoUnSelected:
                [self showLineCirckleHaveInfoUnSelectedAnimation];
                break;
            default:
                break;
        }

        
    }
    
}

#pragma mark 线圈选中动画效果
- (void)showLineCirclSelectAnimation{
    
    //字体颜色渐变
    [CATransaction begin];
    [CATransaction setAnimationDuration:AnimationDuration];
    _titleLayer.foregroundColor =SelectedfillColor.CGColor;
    [CATransaction commit];
    
    //添加新图层
    [self.layer addSublayer:_selectLayer];
    
    //选中动画 线圈动画是否已走
    if (self.doneBefore == NO) {
        //如果是第一个不需要动画过程 直接覆盖，添加闪烁
        if (self.specialType == LineCircleSpecialTypeNoAnimation){
            self.coverLayer.position = CGPointMake(CircleFillD/2, LineCirclY);
            [self.circleLayer addAnimation:self.groupAnima forKey:@"groupAnimation"];
        }
        //如果不是需要先走动画过工程
        else{
            self.coverAnimation.delegate =self;
            [self.coverLayer addAnimation:_coverAnimation forKey:nil];
        }
        self.doneBefore = YES;
    }
    else{
        //直接闪烁
         [self.circleLayer addAnimation:self.groupAnima forKey:@"groupAnimation"];
    }
}
#pragma mark 线圈动画结束后执行光圈动画
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    //光圈动画
    [self.circleLayer addAnimation:self.groupAnima forKey:@"groupAnimation"];
}
#pragma mark 有信息未选中时展示状态
- (void)showLineCirckleHaveInfoUnSelectedAnimation{
    
    [self.circleLayer removeAnimationForKey:@"groupAnimation"];
     if (self.doneAfter == NO ) {
        [self.coverLayer addAnimation:self.afterCoverAnimation forKey:@"afterCoverAnimation"];
        self.doneAfter = YES;
    }
 
}
/**************************** 样式初始化 **********************************/
#pragma mark 画开始样式
- (void)drawStartStyleWithPath:(UIBezierPath*)aPath{
    [aPath moveToPoint:CGPointMake(0, 0)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width-tipWidth, 0)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width-tipWidth,self.frame.size.height)];
    [aPath addLineToPoint:CGPointMake(0,self.frame.size.height)];
}
#pragma mark 画中间样式
- (void)drawMiddleStyleWithPath:(UIBezierPath*)aPath{
    [aPath moveToPoint:CGPointMake(0, 0)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width-tipWidth, 0)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width-tipWidth,self.frame.size.height)];
    [aPath addLineToPoint:CGPointMake(0,self.frame.size.height)];
    [aPath addLineToPoint:CGPointMake(tipWidth, self.frame.size.height/2)];
}
#pragma mark 画结束样式
- (void)drawEndStyleWithPath:(UIBezierPath*)aPath{
    [aPath moveToPoint:CGPointMake(0, 0)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width, 0)];
    [aPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [aPath addLineToPoint:CGPointMake(0,self.frame.size.height)];
    [aPath addLineToPoint:CGPointMake(tipWidth, self.frame.size.height/2)];
}
/***************************** FormTypeLineCircle相关******************************/
#pragma mark 画线圈样式 描述文字
- (void)drawLineCircleStyleWithPath:(UIBezierPath*)aPath{
    
    [aPath moveToPoint:CGPointMake(0, LineCirclY)];
    [aPath addLineToPoint:CGPointMake(LineWidthDefault, LineCirclY)];
    [aPath addArcWithCenter:CGPointMake(LineWidthDefault+CircleDefautD/2, LineCirclY) radius:CircleDefautD/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    [aPath addLineToPoint:CGPointMake(LineWidthDefault+CircleDefautD+LineWidthDefault, LineCirclY)];
    
    [self.layer addSublayer:self.titleLayer];
    
    [self.selectLayer addSublayer:self.textLayer];
}
#pragma mark 标题文本
- (CATextLayer*)titleLayer{
    
    if(!_titleLayer){
        //文字部分
        _titleLayer = [[CATextLayer alloc]init];
        _titleLayer.string = self.titleLabel.text;
        _titleLayer.bounds = CGRectMake(0, 0, self.frame.size.width, 19);
        //字体的名字 不是 UIFont
        _titleLayer.font = (__bridge CFTypeRef _Nullable)(@"PingFangSC-Regular");
        //字体的大小
        _titleLayer.fontSize = 13.f;
        
        _titleLayer.alignmentMode = kCAAlignmentCenter;//字体的对齐方式
        _titleLayer.position = CGPointMake(self.frame.size.width/2,LineCirclY+25);
        _titleLayer.foregroundColor = UnSelectedTitleColor.CGColor;//字体的颜色
        _titleLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _titleLayer;
}
#pragma mark 背景图层
- (CAShapeLayer*)selectLayer{
    if (!_selectLayer) {
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
       
    }
    return _selectLayer;
}
#pragma mark 覆盖图层
- (CAShapeLayer*)coverLayer{
    if (!_coverLayer) {
        
        //覆盖图层
        CALayer *mask = [CALayer layer];
        mask.frame = _selectLayer.frame;
        _coverLayer = [CAShapeLayer layer];
        _coverLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)].CGPath;
        _coverLayer.bounds = CGRectMake(0, 0 ,self.frame.size.width,self.frame.size.height);
        _coverLayer.position = CGPointMake(-self.frame.size.width/2, self.frame.size.height/2);
        [mask addSublayer:_coverLayer];
        _selectLayer.mask = mask;
    
    }
    return _coverLayer;
}
#pragma mark 步骤数字文本
- (CATextLayer*)textLayer{
    
    if (!_textLayer) {
        //    文字部分
        _textLayer = [[CATextLayer alloc]init];
        _textLayer.string = [NSString stringWithFormat:@"%ld",(long)self.index];
        _textLayer.bounds = CGRectMake(0, 0, CircleFillD, CircleFillD);\
        //字体的名字 不是 UIFont
        _textLayer.font = (__bridge CFTypeRef _Nullable)(@"PingFangSC-Medium");
        //字体的大小
        _textLayer.fontSize = 10.f;
        
        _textLayer.alignmentMode = kCAAlignmentCenter;//字体的对齐方式
        _textLayer.position = CGPointMake(LineWidthSelect+CircleFillD/2,LineCirclY);
        _textLayer.foregroundColor = [UIColor whiteColor].CGColor;//字体的颜色
        _textLayer.contentsScale = [UIScreen mainScreen].scale; //防止字体模糊
      
    }
    return _textLayer;
}
#pragma mark 进度动画
- (CABasicAnimation *)coverAnimation{
    if (!_coverAnimation) {
        
        _coverAnimation= [CABasicAnimation animation];
        _coverAnimation.beginTime = CACurrentMediaTime() + AnimationDuration;
        _coverAnimation.keyPath = @"position.x";
        _coverAnimation.fromValue = @(-LineWidthSelect-CircleFillD/2);
        self.doneAfter =self.specialType == LineCircleSpecialTypeAllAnimation?YES:NO;
         float x = self.specialType == LineCircleSpecialTypeAllAnimation?self.frame.size.width/2:CircleFillD/2;
        _coverAnimation.toValue = @(x);
        _coverAnimation.duration = AnimationDuration;
        _coverAnimation.removedOnCompletion = NO;
        _coverAnimation.fillMode = kCAFillModeForwards;
    }
    return _coverAnimation;
}
#pragma mark 未选中有信息进度动画
- (CABasicAnimation*)afterCoverAnimation{
    if (!_afterCoverAnimation) {
        _afterCoverAnimation= [CABasicAnimation animation];
        _afterCoverAnimation.keyPath = @"position.x";
        _afterCoverAnimation.fromValue = @(CircleFillD/2);
        _afterCoverAnimation.toValue = @(self.frame.size.width/2);
        _afterCoverAnimation.duration = AnimationDuration;
        _afterCoverAnimation.removedOnCompletion = NO;
        _afterCoverAnimation.fillMode = kCAFillModeForwards;
    }
    return _afterCoverAnimation;
}
#pragma mark 光圈
- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [[CAShapeLayer alloc]init];
 
        _circleLayer.frame = CGRectMake(0, 0, CircleHaloD, CircleHaloD);
        _circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:_circleLayer.bounds].CGPath;
        _circleLayer.position = CGPointMake(self.frame.size.width/2, LineCirclY);
        _circleLayer.fillColor = SelectedfillColor.CGColor;//填充色
        _circleLayer.opacity = 0.0;
    }
    return _circleLayer;
}

#pragma mark 光圈动画
- (CAAnimationGroup *)groupAnima{
    if (!_groupAnima) {
        CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
        replicatorLayer.frame = CGRectMake(0, 0, CircleHaloD, CircleHaloD);
        replicatorLayer.instanceCount = 4;//创建副本的数量,包括源对象。
        replicatorLayer.instanceDelay = 0.5;//复制副本之间的延迟
        [replicatorLayer addSublayer:_circleLayer];
        [self.layer addSublayer:replicatorLayer];
        
        CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnima.fromValue = @(0.3);
        opacityAnima.toValue = @(0.0);
        
        CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
        scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 2.0, 2.0, 0.0)];

        _groupAnima = [CAAnimationGroup animation];
        _groupAnima.animations = @[opacityAnima, scaleAnima];
        _groupAnima.duration = 2.0;
        _groupAnima.autoreverses = NO;
        _groupAnima.repeatCount = HUGE;
    }
    return _groupAnima;
    
}


@end
