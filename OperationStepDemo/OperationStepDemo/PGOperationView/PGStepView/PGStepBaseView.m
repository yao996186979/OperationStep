//
//  StepBaseView.m
//  OperationStep
//
//  Created by 姚东 on 17/5/18.
//  Copyright © 2017年 姚东. All rights reserved.
//

#import "PGStepBaseView.h"

@interface PGStepBaseView()<BottomButtonDelegate,UIScrollViewDelegate,PGOperationProgressViewDelegate>
// 标题视图
@property (nonatomic ,strong)UIScrollView * titleView;
// 信息展示视图
@property (nonatomic ,strong)UIScrollView * infoBackView;
@end
@implementation PGStepBaseView
- (instancetype)initWithFrame:(CGRect)frame formType:(FormType)type{
    if (self == [super initWithFrame:frame]) {
        self.frame = frame;
        self.formType = type;
        float height = type == FormTypeTip?T_V_H:T_V_CL_H;
        self.titleView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, V_W, height)];
        self.titleView.backgroundColor = [UIColor colorWithRed:42/255.0 green:38/255.0 blue:35/255.0 alpha:1/1.0];
        [self addSubview:self.titleView];
        
      // 可关闭滑动 可设置自行切换动画
      // 底部按钮 遮挡 infoBackView 可设置 添加视图的contentInset
      // 也可以直接设置infoBackView的contentInset
        self.infoBackView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, height, V_W, frame.size.height-height)];
        self.infoBackView.scrollEnabled = YES;
        self.infoBackView.pagingEnabled = YES;
        self.infoBackView.delegate = self;
        self.infoBackView.scrollEnabled = NO;
        [self addSubview:self.infoBackView];
        self.topBtnArr = [[NSMutableArray alloc]init];
        self.bottomBtnArr = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark 设置标题

- (void)setTitleArr:(NSArray *)titleArr{
    if (_formType == FormTypeTip) {
        self.titleBtnWidth =self.formType == FormTypeTip?(V_W - 40)/titleArr.count+tipWidth/2:V_W/titleArr.count;
        for (int index = 0; index < titleArr.count; index ++){
             PGStepTop * step = [[PGStepTop alloc]initWithTitle:titleArr[index] frame:CGRectZero];
            step.tag = index;
            [step addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.titleView addSubview:step];
            [self.topBtnArr addObject:step];
        }
    }
    else{
        self.progressView = [[PGOperationProgressView alloc]initWithFrame:_titleView.frame titles:titleArr];
        self.progressView.operationDelegate = self;
        [_titleView addSubview:self.progressView];
    }
}
#pragma mark 设置视图
- (void)setViewArr:(NSMutableArray<UIView *> *)viewArr{
    self.infoBackView.contentSize = CGSizeMake(V_W*viewArr.count, 0);
    for (UIView * aView in viewArr) {
        [self.infoBackView addSubview:aView];
    }
    
}
#pragma mark 设置底部按钮
- (void)setBottomTitles:(NSArray<NSArray<NSString *> *> *)bottomTitles{
    
    for (int index = 0; index < bottomTitles.count; index ++) {
        
        PGStepBottom * bottom = [[PGStepBottom alloc]init];
        bottom.XY = CGSizeMake(V_W * index, self.infoBackView.frame.size.height - S_B_H);
        bottom.titles = bottomTitles[index];
        bottom.delegate = self;
        [self.bottomBtnArr addObject:bottom.buttons];
        [self.infoBackView addSubview:bottom];
    }
    
}
#pragma mark 上部分点击事件
- (void)topAction:(PGStepTop*)button{
    
    //一些简单变换操作
    if (button.selectorType == SelectorTypeUnSelected) {
        return;
    }
    [self changePageWithStepTop:button.tag];
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionClickIsTop:Tag:Page:backView:)]) {
        [self.delegate actionClickIsTop:YES Tag:button.tag Page:self.infoBackView.contentOffset.x/V_W backView:self.infoBackView];
    }
}
#pragma mark FormTypeLineCircle上部分点击事件
- (void)operationProgressView:(PGOperationProgressView *)progressView Action:(PGStepButton *)button{
 
    //方法提供出来 证明按钮已经可以点击
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionClickIsTop:Tag:Page:backView:)]) {
        [self.delegate actionClickIsTop:YES Tag:button.tag Page:self.infoBackView.contentOffset.x/V_W backView:self.infoBackView];
    }
    [self changePageWithStepTop:button.tag];
}
#pragma mark 下部分点击事件
- (void)clickButtonTag:(NSInteger)tag{
    
    NSInteger page = self.infoBackView.contentOffset.x/V_W;
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionClickIsTop:Tag:Page:backView:)]) {
        [self.delegate actionClickIsTop:NO Tag:tag Page:self.infoBackView.contentOffset.x/V_W backView:self.infoBackView];
    }
    if ([self.bottomBtnArr[page][tag].titleLabel.text isEqualToString:@"下一步"]) {
        [self changePageWithStepTop:page+1];
    }
}

#pragma mark 更改页面显示位置 上/下公用方法
- (void)changePageWithStepTop:(NSInteger)index{
    
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.infoBackView.contentOffset = CGPointMake(index* V_W, 0);
    }];
    if (self.formType == FormTypeTip) {
        for (PGStepTop * btn in self.topBtnArr) {
            btn.selectorType = SelectorTypeUnSelected;
        }
        self.topBtnArr[index].selectorType = SelectorTypeSelected;
    }
    else{
        self.progressView.stepButtonArr[index].stepState = PGStepButtonStateSelected;
        [self.progressView startAnimationMoveToStep:index];
    }
}
#pragma mark 设置下部按钮全开
- (void)setAllBottomIsAble{
    for (NSArray * btnArr in self.bottomBtnArr) {
        for (StepBottomButton * btn in btnArr) {
            btn.isAble = YES;
        }
    }
}
@end
