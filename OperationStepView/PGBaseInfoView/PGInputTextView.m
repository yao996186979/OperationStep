//
//  InputTextView.m
//  PanguSPD
//
//  Created by 姚东 on 17/4/21.
//  Copyright © 2017年 yxiang. All rights reserved.
//

#import "PGInputTextView.h"

#define BackViewHeight 36
// 文本有值颜色  333333
#define NormalColor  [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0]
// 文本默认颜色  666666
#define DefaultColor [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0]
// 标题颜色     999999
#define TitleColor [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0]
@interface PGInputTextView() <UITextViewDelegate>
@property (nonatomic ,strong) UIButton * backView; //文本背景框
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,strong) UITextField * inputText;  //纯文本
@property (nonatomic ,strong) UILabel * dateLable;      //日期展示
@property (nonatomic ,strong) UILabel * onlyShow;       //仅用来显示
@property (nonatomic ,strong) UILabel * selectorLable;  //选择文本
@property (nonatomic ,strong) UITextView * textView;    //备注样式


@end
@implementation PGInputTextView
- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame{
    if (self =[super init]) {
        
        self.title = title;
        self.frame = frame;
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.frame.size.width, 16.5)];
        label.text = title;
        label.textColor = TitleColor;
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
        
        self.backView = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+5, self.frame.size.width,frame.size.height==72.5?BackViewHeight:BackViewHeight+38)];
        self.backView.layer.borderWidth = 1;
        self.backView.layer.borderColor = [UIColor blackColor].CGColor;
        [self addSubview:self.backView];

    }
    return self;
}
- (void)setType:(TextType)type{
    _type = type;
    switch (type) {
        case TextTypeNormal:
            [self addTextField];
            break;
        case TextTypeDate:
            [self addDateButton];
            break;
        case TextTypeSelector:
            [self addTypeSelector];
            break;
        case TextTypeOnlyShow:
            [self addOnlyShow];
            break;
        case TextTypeLongText:
            [self addLongTextInput];
            break;
        default:
            
            break;
    }
}
//添加纯文本
- (void)addTextField{
    self.inputText = [[UITextField alloc]initWithFrame:CGRectMake(15,0, self.frame.size.width-30, BackViewHeight)];
    self.inputText.textColor = NormalColor;
    self.inputText.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [self.inputText addTarget:self action:@selector(clickActionCenter) forControlEvents:UIControlEventEditingDidEnd];
    [self.backView addSubview:self.inputText];
}
//添加日期选择
- (void)addDateButton{
    self.dateLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.frame.size.width-40, BackViewHeight)];
    self.dateLable.textColor = NormalColor;
    self.dateLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
   
    [self.backView addSubview:self.dateLable];
    self.value = @((long long)[[NSDate date] timeIntervalSince1970] * 1000);
    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img-pg16-h-calendar.png"]];
    image.center = CGPointMake(self.frame.size.width-19, BackViewHeight/2);
    image.bounds = CGRectMake(0, 0, 18, 17);
    [self.backView addSubview:image];
 
     [self.backView addTarget:self action:@selector(clickActionCenter) forControlEvents:UIControlEventTouchUpInside];
}
//添加下拉选择
- (void)addTypeSelector{
    
    self.selectorLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.frame.size.width-40, BackViewHeight)];
    self.selectorLable.textColor = NormalColor;
    self.selectorLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [self.backView addSubview:self.selectorLable];
    
    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img-pg16-h-drop-down"]];
    image.center = CGPointMake(self.frame.size.width-19, BackViewHeight/2);
    image.bounds = CGRectMake(0, 0, 10.5, 5);
    [self.backView addSubview:image];
    
    [self.backView addTarget:self action:@selector(clickActionCenter) forControlEvents:UIControlEventTouchUpInside];

}
// 仅用来显示
- (void)addOnlyShow{
    
    self.onlyShow = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, BackViewHeight)];
    self.onlyShow.textColor = NormalColor;
    self.onlyShow.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    self.backView.layer.borderWidth = 0;
    [self.backView addSubview:self.onlyShow];
    
}
//添加长文本输入
- (void)addLongTextInput{
 
    //需要继承设置的位置 大小
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width-30, 72.5+38);
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(15,0, self.backView.frame.size.width-30, 74)];
    self.textView.textColor = NormalColor;
    self.textView.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    self.textView.delegate = self;
    [self.backView addSubview:self.textView];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    //统一交与事件中心处理
    [self clickActionCenter];
}
#pragma mark 编辑页面时使用
- (void)setValue:(id)value{
    _value = value;
    switch (_type) {
        case TextTypeNormal:
           self.inputText.text = value;
            break;
        case TextTypeDate:
             self.dateLable.text = [self timestapToStringWithTimestap:[value longLongValue] formatter:@"yyyy-MM-dd"];
            break;
        case TextTypeSelector:
            
            self.selectorLable.text = [value isEqualToString:@""]?[NSString stringWithFormat:@"选择%@",self.title]:value[@"n"];
            self.selectorLable.textColor = value?NormalColor:DefaultColor;
            break;
        case TextTypeOnlyShow:
             self.onlyShow.text = [value isEqualToString:@""]?@"暂无":value;
             self.onlyShow.textColor = [value isEqualToString:@""]?NormalColor:DefaultColor;
            break;
        case TextTypeLongText:
            self.textView.text = value;
            break;
        default:
            break;
    }
}
#pragma mark  日期格式
- (NSString *)timestapToStringWithTimestap:(long long)timestape formatter:(NSString *)fmt {
    if (!timestape) {
        return @"";
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = fmt;
    NSDate * confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestape/1000.0];
    return [formatter stringFromDate:confromTimesp];
}
#pragma mark 事件中心
- (void)clickActionCenter{
    
    if ([_delegate respondsToSelector:@selector(pgInputTextViewAction:)]) {
        [_delegate pgInputTextViewAction:self];
    }
    
}
@end
