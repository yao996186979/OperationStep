//
//  StepBaseView.h
//  OperationStep
//
//  Created by 姚东 on 17/5/18.
//  Copyright © 2017年 姚东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepBaseView : UIView
// 步骤标题
@property  (nonatomic, strong) NSArray * titleArr;
// 步骤页面
@property  (nonatomic, strong) NSMutableArray <UIView *>*viewArr;
@end
