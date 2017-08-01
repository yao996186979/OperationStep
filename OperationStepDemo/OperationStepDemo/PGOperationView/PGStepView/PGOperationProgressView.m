//
//  PGOperationProgressView.m
//  PGOperationProgressView
//
//  Created by 姚东 on 17/7/26.
//  Copyright © 2017年 姚东. All rights reserved.
//

/*
 1：公开移动方法 需不需要在内部移动？
 2：默认初始化 指定位置
 3：点击事件的公开

 总结：移动点亮  统一放于外部  只提供移动点亮的接口  移动与点亮不可以强相关 
 线可以控制 文字的亮灭 线到哪 文字亮哪
 */
#import "PGOperationProgressView.h"

@interface PGOperationProgressView()<CAAnimationDelegate>
//底层
@property (nonatomic ,strong)CAShapeLayer * bottomLayer;
//填充层
@property (nonatomic ,strong)CAShapeLayer * fillLayer;
//覆盖层
@property (nonatomic ,strong)CAShapeLayer * coverLayer;
//光圈
@property (nonatomic ,strong) CAShapeLayer * circleLayer;
//水纹动画
@property (nonatomic ,strong) CAAnimationGroup *groupAnima;

@property (nonatomic ,assign)float defaultLineWidth;
@property (nonatomic ,assign)float fillLineWidth;

//记录上次移动位置
@property (nonatomic ,assign)float lastX;
//记录文本信息
@property (nonatomic ,strong)NSMutableArray * showTextArr;

@end
@implementation PGOperationProgressView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
//        NSInteger count = titles.count;
        self.defaultLineWidth = (frame.size.width - 3 * CircleDefautD)/6;
        self.fillLineWidth = (frame.size.width - 3 * CircleFillD)/6;
        [self.layer addSublayer:self.bottomLayer];
        [self.layer addSublayer:self.fillLayer];
        self.lastX = -self.frame.size.width/2;
        self.coverLayer.bounds = CGRectMake(0, 0 ,self.frame.size.width,self.frame.size.height);
        [self addTextLayerTitles:titles];
        
        
    }
    return self;
}

#pragma mark 底层
- (CAShapeLayer *)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [[CAShapeLayer alloc]init];
        _bottomLayer.strokeColor = [UIColor blackColor].CGColor;
        _bottomLayer.fillColor  = [UIColor blackColor].CGColor;
        UIBezierPath* aPath = [UIBezierPath bezierPath];
        
        [aPath moveToPoint:CGPointMake(0, LineCirclY)];
        [aPath addLineToPoint:CGPointMake(_defaultLineWidth, LineCirclY)];
        //第一步的圆
        [aPath addArcWithCenter:CGPointMake(_defaultLineWidth+CircleDefautD/2, LineCirclY) radius:CircleDefautD/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
        [aPath addLineToPoint:CGPointMake(_defaultLineWidth*3+CircleDefautD, LineCirclY)];
        //第二步的圆
        [aPath addArcWithCenter:CGPointMake(_defaultLineWidth*3+CircleDefautD+CircleDefautD/2, LineCirclY) radius:CircleDefautD/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
         [aPath addLineToPoint:CGPointMake(CircleDefautD*2+_defaultLineWidth*5, LineCirclY)];
        //第三步的圆
        [aPath addArcWithCenter:CGPointMake(_defaultLineWidth * 5+CircleDefautD/2+CircleDefautD*2, LineCirclY) radius:CircleDefautD/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
        
        [aPath addLineToPoint:CGPointMake(_defaultLineWidth*6+CircleDefautD*3, LineCirclY)];
        [aPath closePath];
        
        _bottomLayer.path = aPath.CGPath;
        
    }
    return _bottomLayer;
}
#pragma mark 文字
- (void)addTextLayerTitles:(NSArray*)titles{
    self.showTextArr = [[NSMutableArray alloc]init];
    
    for (int index =0 ; index < titles.count; index ++) {
        CATextLayer *titleLayer = [[CATextLayer alloc]init];
        titleLayer.string = titles[index];
        titleLayer.bounds = CGRectMake(0, 0, self.frame.size.width/3, 19);
        //字体的名字 不是 UIFont
        titleLayer.font = (__bridge CFTypeRef _Nullable)(@"PingFangSC-Regular");
        //字体的大小
        titleLayer.fontSize = 13.f;
        
        titleLayer.alignmentMode = kCAAlignmentCenter;//字体的对齐方式
        titleLayer.position = CGPointMake(self.frame.size.width/3*index+self.frame.size.width/6,LineCirclY+25);
        titleLayer.foregroundColor = UnSelectedTitleColor.CGColor;//字体的颜色
        titleLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:titleLayer];
        
        [_showTextArr addObject:titleLayer];
        
        //顺便添加 覆盖的按钮
        UIButton * coverButton = [[UIButton alloc]initWithFrame:CGRectMake(index * self.frame.size.width/titles.count, 0, self.frame.size.width/titles.count, self.frame.size.height)];
        [coverButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        coverButton.tag = index;
        [self addSubview:coverButton];
  
    }
}

#pragma mark 填充层
- (CAShapeLayer*)fillLayer{
    if (!_fillLayer) {
        //    背景图层
        _fillLayer = [[CAShapeLayer alloc]init];
        _fillLayer.strokeColor = SelectedStrokeColor.CGColor;
        _fillLayer.fillColor  = SelectedStrokeColor.CGColor;
        UIBezierPath* aPath = [UIBezierPath bezierPath];
        
        [aPath moveToPoint:CGPointMake(0, LineCirclY)];
        [aPath addLineToPoint:CGPointMake(_fillLineWidth, LineCirclY)];
        //第一步的圆
        [aPath addArcWithCenter:CGPointMake(_fillLineWidth+CircleFillD/2, LineCirclY) radius:CircleFillD/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
        [_fillLayer addSublayer:[self addNumberTextWithNumber:@"1" position:CGPointMake(_fillLineWidth+CircleFillD/2, LineCirclY)]];
        [self.layer addSublayer:self.circleLayer];
        [self.circleLayer addAnimation:self.groupAnima forKey:@"groupAnima"];
        [aPath addLineToPoint:CGPointMake(_fillLineWidth*3+CircleFillD, LineCirclY)];
        //第二步的圆
        [aPath addArcWithCenter:CGPointMake(_fillLineWidth*3+CircleFillD/2+CircleFillD, LineCirclY) radius:CircleFillD/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
          [_fillLayer addSublayer:[self addNumberTextWithNumber:@"2" position:CGPointMake(_fillLineWidth*3+CircleFillD/2+CircleFillD, LineCirclY)]];
        [aPath addLineToPoint:CGPointMake(CircleFillD*2+_fillLineWidth*5, LineCirclY)];
        //第三步的圆
        [aPath addArcWithCenter:CGPointMake(_fillLineWidth * 5+CircleFillD/2+CircleFillD*2, LineCirclY) radius:CircleFillD/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
           [_fillLayer addSublayer:[self addNumberTextWithNumber:@"3" position:CGPointMake(_fillLineWidth * 5+CircleFillD/2+CircleFillD*2, LineCirclY)]];
        [aPath addLineToPoint:CGPointMake(_fillLineWidth*6+CircleFillD*3, LineCirclY)];
        [aPath closePath];
        
        _fillLayer.path = aPath.CGPath;

        
    }
    return _fillLayer;
}
#pragma mark 填充层数字标识
- (CATextLayer*)addNumberTextWithNumber:(NSString*)number position:(CGPoint)point{
    CATextLayer *textLayer = [[CATextLayer alloc]init];
    textLayer.string = number;
    textLayer.bounds = CGRectMake(0, 0, CircleFillD, CircleFillD);\
    //字体的名字 不是 UIFont
    textLayer.font = (__bridge CFTypeRef _Nullable)(@"PingFangSC-Medium");
    //字体的大小
    textLayer.fontSize = 10.f;
    
    textLayer.alignmentMode = kCAAlignmentCenter;//字体的对齐方式
    textLayer.position = point;
    textLayer.foregroundColor = [UIColor whiteColor].CGColor;//字体的颜色
    textLayer.contentsScale = [UIScreen mainScreen].scale; //防止字体模糊
    return textLayer;
    
}
#pragma mark 覆盖层
- (CAShapeLayer*)coverLayer{
    if (!_coverLayer) {
        CALayer *mask = [CALayer layer];
        mask.frame = _fillLayer.frame;
        _coverLayer = [CAShapeLayer layer];
        _coverLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)].CGPath;
      
        _coverLayer.position = CGPointMake(-self.frame.size.width, self.frame.size.height/2);
        [mask addSublayer:_coverLayer];
        _fillLayer.mask = mask;
    }
    return _coverLayer;
}
#pragma mark 光圈
- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [[CAShapeLayer alloc]init];
        
        _circleLayer.frame = CGRectMake(0, 0, CircleHaloD, CircleHaloD);
        _circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:_circleLayer.bounds].CGPath;
        _circleLayer.position = CGPointMake(self.frame.size.width/2, LineCirclY);
        _circleLayer.fillColor = SelectedTitleColor.CGColor;//填充色
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
//        顶部动画页面切换时失效
        _groupAnima.removedOnCompletion = NO;
    }
    return _groupAnima;
    
}

/*************************实线方法***************************/
-(void)buttonClick:(UIButton*)button{
   
    if ([_operationDelegate respondsToSelector:@selector(operationProgressView:Action:)]) {
        [_operationDelegate operationProgressView:self  Action:button];
    }
}
#pragma mark 移动位置
- (void)startAnimationMoveToPointX:(float)x{
    //此处x为移动的末尾位置 需要计算成中心位置
    x = x - self.frame.size.width/2;
    if (self.lastX == x) {
        //如果本身已在 预期位置 不动
        return;
    }
    CABasicAnimation *coverAnimation= [CABasicAnimation animation];
//    coverAnimation.beginTime = CACurrentMediaTime() + AnimationDuration;
    coverAnimation.keyPath = @"position.x";
    coverAnimation.duration = AnimationDuration;
    coverAnimation.delegate = self;
    coverAnimation.removedOnCompletion = NO;
    coverAnimation.fillMode = kCAFillModeForwards;
    coverAnimation.fromValue = @(self.lastX);
    coverAnimation.toValue = @(x);
    
    [_coverLayer addAnimation:coverAnimation forKey:@"a"];
    //记录上次位置
    self.lastX = x;
}
#pragma mark 移动步骤
- (void)startAnimationMoveToStep:(NSInteger)step{
    // +0.5避免圆形缺口
    float x = 0.0;
    switch (step) {
        case 0:
            x = CircleFillD +_fillLineWidth+0.5;
            [self setTextLayer:_showTextArr[0] colorIsLight:YES];
            [self setTextLayer:_showTextArr[1] colorIsLight:NO];
            [self setTextLayer:_showTextArr[2] colorIsLight:NO];
            break;
        case 1:
            x = CircleFillD*2 +_fillLineWidth*3+0.5;
            [self setTextLayer:_showTextArr[0] colorIsLight:YES];
            [self setTextLayer:_showTextArr[1] colorIsLight:YES];
             [self setTextLayer:_showTextArr[2] colorIsLight:NO];
            break;
        case 2:
            x = CircleFillD*3 +_fillLineWidth*6+0.5;
            [self setTextLayer:_showTextArr[0] colorIsLight:YES];
            [self setTextLayer:_showTextArr[1] colorIsLight:YES];
            [self setTextLayer:_showTextArr[2] colorIsLight:YES];
            break;
        default:
            break;
    }
    
  
    [self moveCirclePositionToStep:step];
    [self startAnimationMoveToPointX:x];
}
#pragma mark 移动光圈
- (void)moveCirclePositionToStep:(NSInteger)step{
      _circleLayer.position =  CGPointMake(self.frame.size.width/3*step+self.frame.size.width/6, _circleLayer.position.y);
}
#pragma mark 点亮文字

- (void)setTextLayer:(CATextLayer*)textLayer colorIsLight:(BOOL)isLight{
    CGColorRef color =  isLight?SelectedTitleColor.CGColor:UnSelectedTitleColor.CGColor;
    [CATransaction begin];
    [CATransaction setAnimationDuration:.5];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    textLayer.foregroundColor = color;
    [CATransaction commit];
}
@end
