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
@property (nonatomic ,strong)PGStepBaseView * stepView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stepView = [[PGStepBaseView alloc]initWithFrame:self.view.bounds formType:FormTypeLineCircle];
    self.stepView.titleArr = @[@"第一步",@"第二步",@"第三步"];
    self.stepView.viewArr = [self ProgressView];
    self.stepView.bottomTitles = @[@[@"下一步"],@[@"上一步",@"下一步"],@[@"上一步"]];
    [self.stepView.progressView startAnimationMoveToStep:0];
    self.stepView.delegate = self;
    [self.stepView setAllBottomIsAble];
    [self.view addSubview:self.stepView];

}
// setpBaseView 代理事件
- (void)actionClickIsTop:(BOOL)isTop Tag:(NSInteger)tag Page:(NSInteger)page backView:(UIScrollView *)backView{
    // 下标 从 0 开始
    
    if (isTop) {
        NSLog(@"top %ld",(long)tag);
         [self.stepView changePageCircleWithStepTop:tag];
    }
    else{
        NSLog(@"bottom 第%ld页 按钮%ld",(long)page,(long)tag);
    
        switch (page) {
            case 0:
                [self.stepView changePageWithStepTop:1];
                break;
            case 1:
                [self.stepView changePageWithStepTop:tag==0?0:2];
                break;
            default:
                [self.stepView changePageWithStepTop:1];
                break;
        }
       
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
 
            PGBaseInfoView * base = [[PGBaseInfoView alloc]initWithFrame:
                                     CGRectMake(index*V_W, 0, V_W,V_H-T_V_H-T_B_H-20)    titles:titles
                                                                   types:types];
            base.inputDelegate = self;
            base.values = @[@{@"n":@"",@"id":@""},@{@"n":@"",@"id":@""},@{@"n":@"",@"id":@""},@{@"n":@"",@"id":@""},@{@"n":@"",@"id":@""}];
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
