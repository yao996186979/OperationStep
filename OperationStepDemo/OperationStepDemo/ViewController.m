//
//  ViewController.m
//  OperationStepDemo
//
//  Created by 姚东 on 17/5/19.
//  Copyright © 2017年 姚东. All rights reserved.
//

#import "ViewController.h"
#import "PGStepBaseView.h"
#import "PGBaseInfoView.h"
@interface ViewController ()<ActionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PGStepBaseView * stepView = [[PGStepBaseView alloc]initWithFrame:self.view.bounds];
    stepView.titleArr = @[@"第一步",@"第二步",@"第三步"];
    stepView.viewArr = [self ProgressView];
    stepView.bottomTitles = @[@[@"下一步"],@[@"上一步",@"下一步"],@[@"上一步"]];
    stepView.delegate = self;
    [stepView setAllBottomIsAble];
    [self.view addSubview:stepView];

}
// setpBaseView 代理事件
- (void)actionClickIsTop:(BOOL)isTop TopButton:(NSArray<PGStepTop *> *)topArr BottomButton:(NSArray<NSArray<StepBottomButton *> *> *)bottomArr Tag:(NSInteger)tag Page:(NSInteger)page backView:(UIScrollView *)backView{
    // 下标 从 0 开始
    
    if (isTop) {
        NSLog(@"top %ld",(long)tag);
    }
    else{
        NSLog(@"bottom 第%ld页 按钮%ld",(long)page,(long)tag);
        if (page==0 && tag ==0) {
            //点击第一个页面的下一步
            backView.contentOffset = CGPointMake(V_W, 0);
        }
        else if (page==1){
            //点击第二个页面 上步是0 下步为2
          
            backView.contentOffset = CGPointMake(V_W*(tag==0?0:2), 0);
        }
        else if (page==2 && tag==0){
            //点击第三个页面 上步是1
            backView.contentOffset = CGPointMake(V_W, 0);
        }
        
    }

}






// 自定义展示步骤视图
- (NSMutableArray*)ProgressView{
    
    NSMutableArray * returnArr = [[NSMutableArray alloc]init];
    NSArray * colorArr = @[[UIColor purpleColor],[UIColor yellowColor],[UIColor blueColor]];
    for (int index = 0; index< 3; index++) {
        //以 titleView的高度 为起始位置
        if (index == 0) {
            PGBaseInfoView * base = [[PGBaseInfoView alloc]initWithFrame:CGRectMake(index*V_W, 0, V_W, self.view.frame.size.height-T_V_H) titles:@[@"单据编号",@"申请日期",@"拒绝日期",@"秦时明月",@"备注"] types:@[@(TextTypeOnlyShow),@(TextTypeDate),@(TextTypeSelector),@(TextTypeOnlyShow),@(TextTypeLongText)]];
            [returnArr addObject:base];
        }
        else{
            UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(index*V_W, 0, V_W, self.view.frame.size.height-T_V_H)];
            aView.backgroundColor = colorArr[index];
            [returnArr addObject:aView];
        }
        
    }
    return returnArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
