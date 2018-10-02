//
//  ViewController.m
//  DouDouChong
//
//  Created by PC on 2018/2/26.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "ViewController.h"
//#import "WSUtil.h"
#import "AFNetworking.h"

@interface ViewController ()<NSXMLParserDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)requestAction:(id)sender {
    
    NSString *soapMessage =
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<select xmlns=\"http://tempuri.org/\">\n"
    "<sql>\"select * from car\"</sql>"
    "</select>"
    "</soap:Body>\n"
    "</soap:Envelope>\n";
    
    // hello world ' /' xmlns
    /*
     "<HelloWorld xmlns=\"http://tempuri.org/\" />\n"
     "</soap:Body>\n"
     "</soap:Envelope>\n"
     
     
     "<select xmlns=\"http://tempuri.org/\">\n"
     "<sql>\"select * from car\"</sql>"
     "</select>"
     "</soap:Body>\n"
     "</soap:Envelope>\n"
     */
    
    ///请求发送到的路径
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.180:7777/Service1.asmx"];
    
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //
    //    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    //
    //    //以下对请求信息添加属性
    //    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //
    //    [request addValue:[NSString stringWithFormat:@"http://www.Nanonull.com/TimeService/getOffesetUTCTime"] forHTTPHeaderField:@"SOAPAction"];
    //
    //    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    //
    //    [request setHTTPMethod:@"POST"];
    //
    //    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //
    //    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //
    //    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    //
    //
    //    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
    //        NSLog(@"%@",responseObject);
    //
    //        [responseObject setDelegate:self];
    //
    //        //开始解析
    //        [responseObject parse];
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //
    //        NSLog(@"%@",error);
    //
    //
    //
    //    }];
    //
    //    [operation start];
    
    
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    
    //设置请求头
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
   // manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
   // manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        
        return soapMessage;
    }];
    
    [manager POST:url.absoluteString parameters:soapMessage progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"-----%@",responseObject);
        
         NSArray * arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"%@",arr);
        
        NSString * ssss = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",ssss);
        // NSLog(@"%@",dic);
        
        // [(NSXMLParser *)responseObject setDelegate:self];
        
        
        // 返回XML
       // [responseObject setDelegate:self];
        //开始解析
        //[responseObject parse];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error);
        NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"服务器的错误原因:%@",str);
        
    }];
}

#pragma mark - NSXMLParser代理
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // self.timeLabel.text=string;
    NSLog(@"********%@",string);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //  [self.view endEditing:YES];
    
}

@end
