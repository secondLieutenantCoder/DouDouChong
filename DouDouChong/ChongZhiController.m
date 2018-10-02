//
//  ChongZhiController.m
//  DouDouChong
//
//  Created by PC on 2018/5/31.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "ChongZhiController.h"

@interface ChongZhiController ()

@property (weak, nonatomic) IBOutlet UIButton *cBtn1;
@property (weak, nonatomic) IBOutlet UIButton *cBtn2;
@property (weak, nonatomic) IBOutlet UIButton *cBtn3;

@property (weak, nonatomic) IBOutlet UIButton *cBtn4;
@property (weak, nonatomic) IBOutlet UIButton *cBtn5;
@property (weak, nonatomic) IBOutlet UIButton *cBtn6;

@property (weak, nonatomic) IBOutlet UIButton *zfbBtn;

@property (weak, nonatomic) IBOutlet UIButton *weiixnBtn;
@property (weak, nonatomic) IBOutlet UIButton *czBtn;

@property (weak, nonatomic) IBOutlet UILabel *mmb1;
@property (weak, nonatomic) IBOutlet UILabel *price1;

@property (weak, nonatomic) IBOutlet UILabel *mmb2;
@property (weak, nonatomic) IBOutlet UILabel *price2;
@property (weak, nonatomic) IBOutlet UILabel *mmb3;
@property (weak, nonatomic) IBOutlet UILabel *price3;
@property (weak, nonatomic) IBOutlet UILabel *mmb4;
@property (weak, nonatomic) IBOutlet UILabel *price4;
@property (weak, nonatomic) IBOutlet UILabel *mmb5;
@property (weak, nonatomic) IBOutlet UILabel *price5;

@property (weak, nonatomic) IBOutlet UILabel *mmb6;
@property (weak, nonatomic) IBOutlet UILabel *price6;
/** 1毛毛币抵1元租金  */
@property (weak, nonatomic) IBOutlet UILabel *comentLab;

@end



@implementation ChongZhiController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self setSubViews];
    
}

- (void) setSubViews{

    self.cBtn1.layer.cornerRadius = 5;
    self.cBtn2.layer.cornerRadius = 5;
    self.cBtn3.layer.cornerRadius = 5;
    self.cBtn4.layer.cornerRadius = 5;
    self.cBtn5.layer.cornerRadius = 5;
    self.cBtn6.layer.cornerRadius = 5;
    
    self.zfbBtn.selected = YES;
    
    self.czBtn.layer.cornerRadius = 5;
    
    [self initCZBtnState];
    self.mmb1.textColor = [UIColor whiteColor];
    self.price1.textColor = [UIColor whiteColor];
    self.cBtn1.backgroundColor = kGreenColor;
    
    self.comentLab.layer.cornerRadius = 3;
    self.comentLab.layer.borderWidth  = 0.5;
    self.comentLab.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    
}
- (IBAction)czKindAction:(UIButton *)sender {
    
    
    [self initCZBtnState];
    
    sender.backgroundColor = kGreenColor;
    
    switch (sender.tag) {
        case 1:
        {
//            NSMutableAttributedString *
            self.mmb1.textColor = [UIColor whiteColor];
            self.price1.textColor = [UIColor whiteColor];
            
        }
            break;
        case 2:
        {
            NSDictionary * attriDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor redColor]};
            NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc] initWithString:self.mmb2.text];
            [aStr addAttributes:attriDic range:NSMakeRange(5, 7)];
            self.mmb2.textColor = [UIColor whiteColor];
            self.price2.textColor = [UIColor whiteColor];
            self.mmb2.attributedText = aStr;

        }
            break;
        case 3:
        {
            NSDictionary * attriDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor redColor]};
            NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc] initWithString:self.mmb3.text];
            [aStr addAttributes:attriDic range:NSMakeRange(5, 7)];
            self.mmb3.textColor = [UIColor whiteColor];
            self.price3.textColor = [UIColor whiteColor];
            self.mmb3.attributedText = aStr;
        }
            break;
        case 4:
        {
            NSDictionary * attriDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor redColor]};
            NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc] initWithString:self.mmb4.text];
            [aStr addAttributes:attriDic range:NSMakeRange(6, 7)];
            self.mmb4.textColor = [UIColor whiteColor];
            self.price4.textColor = [UIColor whiteColor];
            self.mmb4.attributedText = aStr;
        }
            break;
        case 5:
        {
            NSDictionary * attriDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor redColor]};
            NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc] initWithString:self.mmb5.text];
            [aStr addAttributes:attriDic range:NSMakeRange(6, 7)];
            self.mmb5.textColor = [UIColor whiteColor];
            self.price5.textColor = [UIColor whiteColor];
            self.mmb5.attributedText = aStr;
        }
            break;
        case 6:
        {
            NSDictionary * attriDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor redColor]};
            NSMutableAttributedString * aStr = [[NSMutableAttributedString alloc] initWithString:self.mmb6.text];
            [aStr addAttributes:attriDic range:NSMakeRange(6, 7)];
            self.mmb6.textColor = [UIColor whiteColor];
            self.price6.textColor = [UIColor whiteColor];
            self.mmb6.attributedText = aStr;
        }
            break;
            
        default:
            break;
    }
    
}

#pragma * 初始化充值金额按钮
- (void) initCZBtnState{

    self.cBtn1.layer.borderColor = kGreenColor.CGColor;
    self.cBtn1.layer.borderWidth = 0.8;
    self.cBtn1.backgroundColor = [UIColor whiteColor];
    
    self.cBtn2.layer.borderColor = kGreenColor.CGColor;
    self.cBtn2.layer.borderWidth = 0.8;
    self.cBtn2.backgroundColor = [UIColor whiteColor];
    
    self.cBtn3.layer.borderColor = kGreenColor.CGColor;
    self.cBtn3.layer.borderWidth = 0.8;
    self.cBtn3.backgroundColor = [UIColor whiteColor];
    
    self.cBtn4.layer.borderColor = kGreenColor.CGColor;
    self.cBtn4.layer.borderWidth = 0.8;
    self.cBtn4.backgroundColor = [UIColor whiteColor];
    
    self.cBtn5.layer.borderColor = kGreenColor.CGColor;
    self.cBtn5.layer.borderWidth = 0.8;
    self.cBtn5.backgroundColor = [UIColor whiteColor];
    
    self.cBtn6.layer.borderColor = kGreenColor.CGColor;
    self.cBtn6.layer.borderWidth = 0.8;
    self.cBtn6.backgroundColor = [UIColor whiteColor];
    
    self.mmb1.textColor = kGreenColor;
    self.price1.textColor = kGreenColor;
    self.mmb2.textColor = kGreenColor;
    self.price2.textColor = kGreenColor;
    self.mmb3.textColor = kGreenColor;
    self.price3.textColor = kGreenColor;
    self.mmb4.textColor = kGreenColor;
    self.price4.textColor = kGreenColor;
    self.mmb5.textColor = kGreenColor;
    self.price5.textColor = kGreenColor;
    self.mmb6.textColor = kGreenColor;
    self.price6.textColor = kGreenColor;
    
    
    NSDictionary * attriDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSForegroundColorAttributeName:[UIColor redColor]};
    NSMutableAttributedString * aStr2 = [[NSMutableAttributedString alloc] initWithString:self.mmb2.text];
    [aStr2 addAttributes:attriDic range:NSMakeRange(5, 7)];

    self.mmb2.attributedText = aStr2;
    
    NSMutableAttributedString * aStr3 = [[NSMutableAttributedString alloc] initWithString:self.mmb3.text];
    [aStr3 addAttributes:attriDic range:NSMakeRange(5, 7)];

    self.mmb3.attributedText = aStr3;
    
    NSMutableAttributedString * aStr4 = [[NSMutableAttributedString alloc] initWithString:self.mmb4.text];
    [aStr4 addAttributes:attriDic range:NSMakeRange(6, 7)];

    self.mmb4.attributedText = aStr4;
    
    
    NSMutableAttributedString * aStr5 = [[NSMutableAttributedString alloc] initWithString:self.mmb5.text];
    [aStr5 addAttributes:attriDic range:NSMakeRange(6, 7)];

    self.mmb5.attributedText = aStr5;
    
    NSMutableAttributedString * aStr6 = [[NSMutableAttributedString alloc] initWithString:self.mmb6.text];
    [aStr6 addAttributes:attriDic range:NSMakeRange(6, 7)];

    self.mmb6.attributedText = aStr6;
    
    
    
}

#pragma mark * 选择支付方式-支付宝
- (IBAction)pickZFBAction:(UIButton *)sender {
    
    sender.selected = YES;
    self.weiixnBtn.selected = NO;
    
    
}
#pragma mark * 选择支付方式-微信
- (IBAction)pickWXAction:(UIButton *)sender {
    
    sender.selected = YES;
    self.zfbBtn.selected = NO;
    
    
}

#pragma mark * 立即支付事件
- (IBAction)payAction:(UIButton *)sender {
    
    
    
}

#pragma mark * 充值与缴费协议
- (IBAction)moneyProtocol:(UIButton *)sender {
    
    
    
}

- (void) setNav{
    
    self.title = @"充毛毛币";
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_gray"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    // [rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [rightBtn setTitle:@"退回历史" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
}

- (void) leftBtn:(UIButton *)btn{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void) rightAction{
    
    NSLog(@"报销停车费");
}

@end
