//
//  StepBaseView.m
//  OperationStep
//
//  Created by 姚东 on 17/5/18.
//  Copyright © 2017年 姚东. All rights reserved.
//

#import "StepBaseView.h"

@interface StepBaseView()<BottomButtonDelegate,UIScrollViewDelegate>
// 标题视图
@property (nonatomic ,strong)UIScrollView * titleView;
// 信息展示视图
@property (nonatomic ,strong)UIScrollView * infoBackView;
@end
@implementation StepBaseView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.frame = frame;
 
        //这里由于未添加导航，所以将titleView起始位置加高 可自行调整
        float statusBarHeight = 22;
        
        self.titleView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, statusBarHeight, V_H, T_V_H)];
        self.titleView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.titleView];
        
      // 可关闭滑动 可设置自行切换动画
      // 底部按钮 遮挡 infoBackView 可设置 添加视图的contentInset
      // 也可以直接设置infoBackView的contentInset
        self.infoBackView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, T_V_H+22, V_W, frame.size.height-T_V_H-statusBarHeight)];
        self.infoBackView.scrollEnabled = YES;
        self.infoBackView.pagingEnabled = YES;
        self.infoBackView.delegate = self;
        [self addSubview:self.infoBackView];
        self.topBtnArr = [[NSMutableArray alloc]init];
        self.bottomBtnArr = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark 设置标题
- (void)setTitleArr:(NSArray *)titleArr{
    
    self.titleBtnWidth = (V_W - 40)/titleArr.count+tipWidth/2;
    for (int index = 0; index < titleArr.count; index ++) {
        
        StepTop * step = [[StepTop alloc]initWithTitle:titleArr[index] frame:CGRectMake(10+(self.titleBtnWidth-10)*index,(T_V_H - T_B_H)/2, self.titleBtnWidth, T_B_H)];
        if (index == 0) {                  //第一位起始样式
            step.styleType  = StyleTypeStart;
            step.selectorType = SelectorTypeSelected; //默认第一步选中
        }
        else if (index == titleArr.count-1){ //末尾结束样式
            step.styleType = StyleTypeEnd;
        }
        else{                              //中间样式
            step.styleType = StyleTypeMiddle;
        }
        step.tag = index;
        [step addTarget:self action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleView addSubview:step];
        [self.topBtnArr addObject:step];
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
        
        StepBottom * bottom = [[StepBottom alloc]init];
        bottom.XY = CGSizeMake(V_W * index, self.infoBackView.frame.size.height - S_B_H);
        bottom.titles = bottomTitles[index];
        bottom.delegate = self;
        [self.bottomBtnArr addObject:bottom.buttons];
        [self.infoBackView addSubview:bottom];
    }
    
}
#pragma mark 上部分点击事件
- (void)topAction:(UIButton*)button{
    
    //一些简单变换操作
    for (StepTop * btn in self.topBtnArr) {
        btn.selectorType = SelectorTypeUnSelected;
    }
    self.topBtnArr[button.tag].selectorType = SelectorTypeSelected;
    //切换 视图展示
    self.infoBackView.contentOffset = CGPointMake(button.tag* V_W, 0);
    
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionClickIsTop:TopButton:BottomButton:Tag:Page:backView:)]) {
        [self.delegate actionClickIsTop:YES TopButton:self.topBtnArr BottomButton:self.bottomBtnArr Tag:button.tag Page:self.infoBackView.contentOffset.x/V_W backView:self.infoBackView];
    }
}
#pragma mark 下部分点击事件
- (void)clickButtonTag:(NSInteger)tag{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionClickIsTop:TopButton:BottomButton:Tag:Page:backView:)]) {
        [self.delegate actionClickIsTop:NO TopButton:self.topBtnArr BottomButton:self.bottomBtnArr Tag:tag Page:self.infoBackView.contentOffset.x/V_W backView:self.infoBackView];
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
#pragma mark scroll滑动结束
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 设置 顶部按钮 状态变化
    int index = scrollView.contentOffset.x/V_W;
    
    for (StepTop * btn in self.topBtnArr) {
        btn.selectorType = SelectorTypeUnSelected;
    }
    self.topBtnArr[index].selectorType = SelectorTypeSelected;
}
@end
