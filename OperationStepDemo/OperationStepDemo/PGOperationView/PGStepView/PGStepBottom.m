//
//  StepBottom.m
//  OperationStepDemo
//
//  Created by 姚东 on 17/5/19.
//  Copyright © 2017年 姚东. All rights reserved.
//

#import "PGStepBottom.h"

@implementation PGStepBottom

- (instancetype)init{
    
    if (self == [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.9;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
        
        
        self.buttons = [[NSMutableArray alloc]init];
        
    }
    return self;
}
- (void)setTitles:(NSArray *)titles{
    
    float y = (S_B_H - S_BB_H)/2;
    float x = (WIDTH - S_BB_W*titles.count)/(titles.count + 1);
    for (int index = 0; index <titles.count ; index++) {
        StepBottomButton * button = [[StepBottomButton alloc]initWithFrame:CGRectMake(x + (S_BB_W +x)*index, y, S_BB_W, S_BB_H)];
        [button setTitle:titles[index] forState:UIControlStateNormal];
        button.tag = index;
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttons addObject:button];
    }
}
- (void)setXY:(CGSize)XY{
    
    self.frame = CGRectMake(XY.width, XY.height, WIDTH, S_B_H);
}
- (void)clickAction:(UIButton*)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickButtonTag:)]) {
        [self.delegate clickButtonTag:button.tag];
    }
}
@end



@implementation StepBottomButton{
    UIImageView *nextImg;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        
        self.isAble = self.enabled = NO;
        [self setTitleColor:UnAble_Color forState:UIControlStateNormal];
        self.layer.borderColor = UnAble_Color.CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 18;
        self.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        
        nextImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        nextImg.center = CGPointMake(frame.size.width-29, frame.size.height/2);
        nextImg.bounds = CGRectMake(0, 0, 14, 12);
        [self addSubview:nextImg];
    }
    return self;
}
- (void)setIsAble:(BOOL)isAble{
    _isAble = isAble;
    self.enabled = isAble;
    
    if(isAble){
        [self setTitleColor:Able_Color forState:UIControlStateNormal];
        self.layer.borderColor = Able_Color.CGColor;
    }
    else{
        [self setTitleColor:UnAble_Color forState:UIControlStateNormal];
        self.layer.borderColor = UnAble_Color.CGColor;
    }
    if ([self.titleLabel.text isEqualToString:@"终止"]) {
        //业务需求暂时如此处理 终止按钮样式
        [self setTitleColor:Specail_Color forState:UIControlStateNormal];
        self.layer.borderColor = Specail_Color.CGColor;
    }
    if([self.titleLabel.text isEqualToString:@"下一步"]){
        nextImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"page_next_%d",isAble]];
    }
}
@end
