//
//  DEMOSecondViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOSecondViewController.h"
#import "DEMONavigationController.h"
#import "AFNetworking.h"
#import "XMLReader.h"

@interface DEMOSecondViewController ()<NSXMLParserDelegate>

@end

@implementation DEMOSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self setNav];
      self.view.backgroundColor = [UIColor orangeColor];
// 中心按钮
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(ttAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * cancel = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-80, 30, 60, 35)];
    [cancel setTitle:@"返回" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancel];
}

- (void) setNav{

 
    
}

- (void) backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
 
   }

- (void) cancelAction{

    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - 发起网络请求
- (void) startNetAction{

    NSString * soapMessage = [self buildSoapMessageWidthName:nil andParam:nil];
    
    
    
    
}

#pragma mark - 构造请求信息
- (NSString *) buildSoapMessageWidthName:(NSString *)mName andParam:(NSDictionary *)param{

    
    NSString * soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                              "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                              "<soap:Body>\n"
                              "<%@ xmlns=\"http://tempuri.org/\">\n"
                              "<city>临朐县</city>"
                              "</%@>"
                              "</soap:Body>\n"
                              "</soap:Envelope>\n",@"select_city_car",@"select_city_car"];
    
//    select_per_cityarea  select_all_car select_city_car
    return soapMessage;
}

#pragma mark - soap请求网络数据
- (void) ttAction{

    /*
    NSString *soapMessage =
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
        "<select_all_car xmlns=\"http://tempuri.org/\">\n"
        "</select_all_car>"
    "</soap:Body>\n"
    "</soap:Envelope>\n";
     */
    
//    NSString * soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
//                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//                               "<soap:Body>\n"
//                               "<%@ xmlns=\"http://tempuri.org/\">\n"
//                               "</%@>"
//                               "</soap:Body>\n"
//                               "</soap:Envelope>\n",@"select_all_car",@"select_all_car"];
    
    NSString * soapMessage = [self buildSoapMessageWidthName:nil andParam:nil];
    
    // "<sql>select * from car</sql>"
    
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
    // 47.104.172.215
    // 192.168.1.180
    ///请求发送到的路径
    NSURL *url = [NSURL URLWithString:@"http://47.104.172.215:7777/Service1.asmx"];
    
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
        
        NSError * e;
        NSDictionary * arr = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
        
        NSLog(@"%@",arr);
        NSLog(@"erroe:%@Error",e);
        
        NSString * ssss = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",ssss);
        
        // xmlReader 解析数据
        NSError * readError;
        NSDictionary *items =
        [XMLReader dictionaryForXMLData:responseObject options:XMLReaderOptionsProcessNamespaces error:&readError];
        NSLog(@"ITEM:%@",items);
        
        NSDictionary * dic1 = items[@"Envelope"];
        NSDictionary * dic2 = dic1[@"Body"];
        NSDictionary * dic3 = dic2[@"select_all_carResponse"];
        NSDictionary * dic4 = dic3[@"select_all_carResult"];
        
        NSString * jsonStr = dic4[@"text"];
        // 取出查询字符串 转 data
        NSData * jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        // data 转 数组
        NSArray * resArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        // 数组存放车辆信息字典
        NSLog(@"RESARR:%@",resArr);
        NSDictionary * fDic = resArr[0];
        NSLog(@"第一个车牌:%@",fDic[@"num"]);
        
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
    
   // NSData * jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
   // NSArray * array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    
   // NSLog(@"=========%@",array);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //  [self.view endEditing:YES];
    
}



@end
