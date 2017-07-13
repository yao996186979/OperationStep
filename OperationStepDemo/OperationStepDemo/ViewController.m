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
@interface ViewController ()<PGStepBaseViewDelegate,PGBaseInfoViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PGStepBaseView * stepView = [[PGStepBaseView alloc]initWithFrame:self.view.bounds];
    //设置标题进度展示形式
    stepView.formType = FormTypeLineCircle;
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
        float contentX;
        if (page==0 && tag ==0) {
            //点击第一个页面的下一步
            contentX = V_W;
        }
        else if (page==1){
            //点击第二个页面 上步是0 下步为2
            contentX = V_W*(tag==0?0:2);
        }
        else if (page==2 && tag==0){
            //点击第三个页面 上步是1
            contentX = V_W;
        }
        [UIView animateWithDuration:AnimationDuration animations:^{
            backView.contentOffset = CGPointMake(contentX, 0);
        }];

    }
}
#pragma mark value更改方法
- (void)valueChangeOfPGInputTextView:(PGInputTextView *)inputTextView{
    
 
    if (inputTextView.type == TextTypeDate) {
        
        NSLog(@"日期修改，具体单项根据 tag 区分");
        
    }
    else if (inputTextView.type == TextTypeNormal){
        
        NSLog(@"文字修改，具体单项根据 tag 区分");
    }
    else if (inputTextView.type == TextTypeSelector){
  
        NSLog(@"选项修改，具体单项根据 tag 区分");
    }
    else if (inputTextView.type == TextTypeLongText){
        
        NSLog(@"长文本修改，具体单项根据 tag 区分");
    }

}
// 自定义展示步骤视图
- (NSMutableArray*)ProgressView{
    
    NSMutableArray * returnArr = [[NSMutableArray alloc]init];
    NSArray * colorArr = @[[UIColor purpleColor],[UIColor yellowColor],[UIColor blueColor]];
    for (int index = 0; index< 3; index++) {
        //以 titleView的高度 为起始位置
        if (index == 0) {
            
            // 配置数据 还是自己使用的数据为准
            
            NSArray * titles = @[@"今夜何时",@"今朝何梦",@"今此为何",@"今苦为谁",@"今生何愿",@"老骥伏枥",@"志在千里",@"厚积薄发",@"天道酬勤"];
            NSArray * types = @[@(TextTypeOnlyShow),@(TextTypeDate),@(TextTypeSelector),@(TextTypeSelector),@(TextTypeSelector),@(TextTypeSelector),@(TextTypeNormal),@(TextTypeNormal),@(TextTypeLongText)];
//            NSArray * values = @[@{@"n":@"",@"id":@""},@{@"n":@"",@"id":@""},@{@"n":@"",@"id":@""},@{@"n":@"",@"id":@""},@{@"n":@"",@"id":@""}];
            PGBaseInfoView * base = [[PGBaseInfoView alloc]initWithFrame:
                                     CGRectMake(index*V_W, 0, V_W,V_H-T_V_H-T_B_H-20)    titles:titles
                                                                   types:types
                                                                  values:nil];
            base.inputDelegate = self;
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
