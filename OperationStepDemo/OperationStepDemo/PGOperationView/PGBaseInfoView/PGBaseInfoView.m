//
//  PGBaseInfoView.m
//  PGCreatOrEdit
//
//  Created by 姚东 on 17/7/5.
//  Copyright © 2017年 姚东. All rights reserved.
//

#import "PGBaseInfoView.h"

@implementation PGBaseInfoView 

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles types:(NSArray<NSNumber *> *)types{
 
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        //控件的背景
        UIView * backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        //宽度 [按比例]
        float width = [UIScreen mainScreen].bounds.size.width * 0.4;
        //间隔
        float intervalWidth = [UIScreen mainScreen].bounds.size.width - 2* width-30;
        float bottom = 0.0;
        for (int index =0; index<titles.count;index++) {
           PGInputTextView * inputText= [[PGInputTextView alloc]initWithTitle:titles[index] frame:CGRectMake(index%2*(width+intervalWidth)+15,index/2*72.5, width, 72.5)];
            inputText.type = [types[index] intValue];
            inputText.delegate = self;
            bottom = CGRectGetMaxY(inputText.frame);
            [backView addSubview:inputText];
        }
        backView.frame = CGRectMake(0, 15, self.frame.size.width,bottom+15);
        if (frame.size.height < bottom+15){
            //如果 最大高度 小于 自适应下来的高度 ，证明是小屏  需要滚动
            //frame 不变 更改滑动区域
            self.contentSize = CGSizeMake(0, CGRectGetMaxY(backView.frame)+50+15);
        }
//        else{
//            //自适应高度 足够 (预留区域足够展示)
//            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(backView.frame));
//        }
    }

    return self;
}
- (void)pgInputTextViewAction:(PGInputTextView *)view{
    
    NSLog(@"%d",view.type);
    
}
@end
