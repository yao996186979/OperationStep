//
//  StepBaseView.m
//  OperationStep
//
//  Created by 姚东 on 17/5/18.
//  Copyright © 2017年 姚东. All rights reserved.
//

#import "StepBaseView.h"
#import "StepButton.h"
@implementation StepBaseView

#pragma mark 设置标题
- (void)setTitleArr:(NSArray *)titleArr{
    
    for (int index = 0; index < titleArr.count; index ++) {
        
        StepButton * step = [[StepButton alloc]initWithTitle:titleArr[index] frame:CGRectMake(0, 0, 0, 0)];
        
    }
}

@end
