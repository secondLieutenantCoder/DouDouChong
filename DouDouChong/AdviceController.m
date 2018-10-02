//
//  AdviceController.m
//  DouDouChong
//
//  Created by PC on 2018/6/28.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "AdviceController.h"

@interface AdviceController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *adviceTV;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic,strong) UILabel * pHolder;

@property (weak, nonatomic) IBOutlet UILabel *countLab;
@end

@implementation AdviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    self.submitBtn.layer.cornerRadius = 6;
    
    self.adviceTV.delegate = self;
    self.adviceTV.layer.borderWidth = 0.5f;
    self.adviceTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.adviceTV.layer.cornerRadius = 3;
    
    self.pHolder = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.adviceTV.frame.size.width, 25)];
    self.pHolder.text = @"请在此写下您对我们的意见建议，感谢您的反馈！";
    self.pHolder.font = [UIFont systemFontOfSize:14];
    self.pHolder.adjustsFontSizeToFitWidth = YES;
    self.pHolder.textColor = [UIColor lightGrayColor];
    
    [self.adviceTV addSubview:self.pHolder];
}

#pragma mark - textView代理方法

- (void)textViewDidChange:(UITextView *)textView{

    if (textView.text.length >0) {
        self.pHolder.hidden = YES;
    }else{
        
        self.pHolder.hidden = NO;
    }
     self.countLab.text=[NSString stringWithFormat:@"%lu/140",(unsigned long)textView.text.length];
    if (textView.text.length > 140) {
        //        textView.editable=NO;
        NSMutableAttributedString * indicatorStr = [[NSMutableAttributedString alloc] initWithString:self.countLab.text];
        
        [indicatorStr beginEditing];
        NSDictionary * attriDic = @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:16]};
        [indicatorStr addAttributes:attriDic range:NSMakeRange(0, 3)];
        [indicatorStr endEditing];
        
        self.countLab.attributedText = indicatorStr;
        
        [self.countLab setAttributedText:indicatorStr];
    }
}

#pragma mark - 提交意见
- (IBAction)submitAction:(id)sender {
    
    
}

- (void) setNav{
    
    self.title = @"意见反馈";
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_gray"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
}

- (void) leftBtn:(UIButton *)btn{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
