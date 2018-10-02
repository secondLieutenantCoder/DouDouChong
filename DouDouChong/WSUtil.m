//
//  WSUtil.m
//  DouDouChong
//
//  Created by PC on 2018/2/26.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "WSUtil.h"
#import "AFNetworking.h"
#import "XMLReader.h"

@interface WSUtil ()<NSFileManagerDelegate>

@end

/// webservice方法名前缀
//NSString * methodName;

@implementation WSUtil{

    // 调用的方法名前缀
  //  NSString * _methodName;
    
   // NSString * methodName;
}


#pragma mark - 网络请求返回 array
+ (void) wsRequestWithName:(NSString *) mName  andParam:(NSDictionary *)param success:(wwSuccess)success failure:(wwFailure)faulure{

   // __block NSString * rosponseName = mName;
     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString * soapMessage = nil;
    NSString * methodName = mName;
    if (param == nil) {
        // 不带参数
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<%@ xmlns=\"http://tempuri.org/\">\n"
                       "</%@>"
                       "</soap:Body>\n"
                       "</soap:Envelope>\n",methodName,methodName];
        
        
    }else{
        // 带参数
       __block NSString * pStr = @"";
        // 遍历字典，拼接字符串
        [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
          //  NSLog(@"key = %@,----obj = %@",key,obj);
            pStr = [NSString stringWithFormat:@"%@<%@>%@</%@>",pStr,key,obj,key];
        }];
        
       // NSLog(@"******%@",pStr);
        // 多个参数拼成一个字符串占位插入
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<%@ xmlns=\"http://tempuri.org/\">\n"
                       "%@"
                       "</%@>"
                       "</soap:Body>\n"
                       "</soap:Envelope>\n",methodName,pStr,methodName];
        
    }
    
    
    NSURL *url = [NSURL URLWithString:@"http://47.104.172.215:7777/Service1.asmx"];
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    //设置请求头
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        
        return soapMessage;
    }];
    
   
        
      //  NSLog(@"===--%@",[NSThread currentThread]);
        [manager POST:url.absoluteString parameters:soapMessage progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
       //     NSLog(@"--==---%@",[NSThread currentThread]);
            
        //    NSError * e;
       //     NSDictionary * arr = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&e];
            
       //     NSLog(@"%@",arr);
       //     NSLog(@"erroe:%@Error",e);
            
      //      NSString * ssss = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
       //     NSLog(@"%@",ssss);
            
            // xmlReader 解析数据
            NSError * readError;
            NSDictionary *items =
            [XMLReader dictionaryForXMLData:responseObject options:XMLReaderOptionsProcessNamespaces error:&readError];
       //     NSLog(@"ITEM:%@",items);
            
            NSDictionary * dic1 = items[@"Envelope"];
            NSDictionary * dic2 = dic1[@"Body"];
            // responseKey
            NSString * responseKey = [NSString stringWithFormat:@"%@Response",methodName];
            NSDictionary * dic3 = dic2[responseKey];
            // resultKey
            NSString * resultKey = [NSString stringWithFormat:@"%@Result",methodName];
            NSDictionary * dic4 = dic3[resultKey];
            
            NSString * jsonStr = dic4[@"text"];
            // 取出查询字符串 转 data
            NSData * jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
            
            // data 转 数组
            NSArray * resArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
            // 数组存放车辆信息字典
      //      NSLog(@"RESARR:%@",resArr);
            NSDictionary * fDic = resArr[0];
            NSLog(@"第一个车牌:%@",fDic[@"num"]);
            
          //  dispatch_sync(dispatch_get_main_queue(), ^{
                success(resArr);
          //  });
            
            //  return resArr;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"Error: %@", error);
            NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"服务器的错误原因:%@",str);
            
            // return nil;
          //  dispatch_sync(dispatch_get_main_queue(), ^{
                faulure(task,error);
          //  });
            
        }];
        
    });
    
    
    
    
}





#pragma mark - 网络请求返回 Bool
+ (void) wsBoolRequestWithName:(NSString *) mName  andParam:(NSDictionary *)param success:(boolSuccess)success failure:(boolFailure)faulure{
    
    
    NSString * soapMessage = nil;
    NSString * methodName = mName;
    if (param == nil) {
        // 不带参数
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<%@ xmlns=\"http://tempuri.org/\">\n"
                       "</%@>"
                       "</soap:Body>\n"
                       "</soap:Envelope>\n",methodName,methodName];
        
        
    }else{
        // 带参数
        __block NSString * pStr = @"";
        // 遍历字典，拼接字符串
        [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            //  NSLog(@"key = %@,----obj = %@",key,obj);
            pStr = [NSString stringWithFormat:@"%@<%@>%@</%@>",pStr,key,obj,key];
        }];
        
        NSLog(@"******%@",pStr);
        // 多个参数拼成一个字符串占位插入
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<%@ xmlns=\"http://tempuri.org/\">\n"
                       "%@"
                       "</%@>"
                       "</soap:Body>\n"
                       "</soap:Envelope>\n",methodName,pStr,methodName];
        
    }
    
    
    NSURL *url = [NSURL URLWithString:@"http://47.104.172.215:7777/Service1.asmx"];
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    //设置请求头
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
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
        // responseKey
        NSString * responseKey = [NSString stringWithFormat:@"%@Response",methodName];
        NSDictionary * dic3 = dic2[responseKey];
        // resultKey
        NSString * resultKey = [NSString stringWithFormat:@"%@Result",methodName];
        NSDictionary * dic4 = dic3[resultKey];
        
        NSString * jsonStr = dic4[@"text"];
        BOOL isOK = YES;
        if ([jsonStr isEqualToString:@"true"]) {
            // YES
            isOK = YES;
           
        }else{
            // NO
            isOK = NO;
        }
        success(isOK);
        /*
        // 取出查询字符串 转 data
        NSData * jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        // data 转 数组
        NSArray * resArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        // 数组存放车辆信息字典
        NSLog(@"RESARR:%@",resArr);
        NSDictionary * fDic = resArr[0];
        NSLog(@"第一个车牌:%@",fDic[@"num"]);
        success(resArr);
        //  return resArr;
        */
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error);
        NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"服务器的错误原因:%@",str);
        
        // return nil;
        faulure(task,error);
        
    }];
    
    
}


















+ (void)afnSoap{
    
    NSString *soapMessage =
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
    "<soap:Body>\n"
    "<HelloWorld xmlns=\"http://tempuri.org/\" />\n"
    "</soap:Body>\n"
    "</soap:Envelope>\n";
    
    ///请求发送到的路径
    NSURL *url = [NSURL URLWithString:@"http://47.104.172.215:7777/Service1.asmx"];
    
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
    
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        
        return soapMessage;
    }];
    
    [manager POST:url.absoluteString parameters:soapMessage progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"-----%@",responseObject);
        
       // NSDictionary * dic = (NSDictionary *)responseObject;
       // NSLog(@"%@",dic);
        
       // [(NSXMLParser *)responseObject setDelegate:self];
        
     //   [responseObject setDelegate:self];
        
        //开始解析
        [responseObject parse];
        
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
