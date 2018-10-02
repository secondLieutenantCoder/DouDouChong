//
//  XieYiControllerViewController.m
//  DouDouChong
//
//  Created by PC on 2018/6/19.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "XieYiControllerViewController.h"

#import <WebKit/WebKit.h>

@interface XieYiControllerViewController ()<WKUIDelegate,WKNavigationDelegate>


@property (nonatomic,strong) UIWebView * webView;

@property (nonatomic,strong) UIProgressView * progressView;

@property (nonatomic,strong) WKWebView * wkWebView;

@end

@implementation XieYiControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNav];
    
//    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
//    self.webView.delegate = self;
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://longchuangkeji.com/doudouchong/yonghuxieyi.html"]]];
//    
//    [self.view addSubview:self.webView];
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 2)];
    self.progressView.backgroundColor = [UIColor blueColor];
    self.progressView.transform = CGAffineTransformMakeScale(1, 1.5);
    [self.view addSubview:self.progressView];
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://longchuangkeji.com/doudouchong/yonghuxieyi.html"]];
    [self.wkWebView loadRequest:request];
    
    // KVO
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view addSubview:self.wkWebView];
    
    
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            
            
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1, 1.4);
                
            } completion:^(BOOL finished) {
                
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }
}

#pragma mark - wkWebView开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{

    self.progressView.hidden = NO;
    self.progressView.transform  = CGAffineTransformMakeScale(1, 1.5);
    [self.view bringSubviewToFront:self.progressView];
}

#pragma mark - 记载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{

    
}
- (void) webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error{

    
}


-(void) dealloc{

    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    NSLog(@"webError = %@",error);
}

- (void) setNav{
    
    self.title = @"豆豆虫租车协议";
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_gray"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
//    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
//    // [rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [rightBtn setTitle:@"确认还车" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:kGreenColor forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
}

- (void) leftBtn:(UIButton *)btn{
    
    
   // [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
