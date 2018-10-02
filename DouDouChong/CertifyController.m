//
//  CertifyController.m
//  DouDouChong
//
//  Created by PC on 2018/6/14.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "CertifyController.h"
#import "checkString.h"
#import "WSUtil.h"

@interface CertifyController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *driveWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *driveHeight;


@property (weak, nonatomic) IBOutlet UIImageView *idImageView;
@property (weak, nonatomic) IBOutlet UIImageView *driveImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *idNumTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

/** 标志 选择的是身份证 1 还是驾驶证 2 */
@property (nonatomic,assign) NSInteger photoFlag;
/** 标志 是否已经拍摄身份证 */
@property (nonatomic,assign) BOOL idFlag;
/** 标志 是否已经拍摄驾驶证 */
@property (nonatomic,assign) BOOL driveFlag;

/** 标志 身份证是否已经识别 */
@property (nonatomic,assign) BOOL idSuccess;
/** 标志 驾驶证是否已经识别 */
@property (nonatomic,assign) BOOL driveSuccess;

@end

@implementation CertifyController{
    /** 完善身份证信息的接口参数 */
    NSMutableDictionary * _idParam;
    /** 完善驾驶证信息的接口参数 */
    NSMutableDictionary * _driveParam;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.idWidth.constant = (kWidth-30)/2.0;
    self.idHeight.constant = self.idWidth.constant*30.0/42.0;
    
    self.driveWidth.constant = (kWidth-30)/2.0;
    self.driveHeight.constant = self.driveWidth.constant*30.0/42.0;
    
    self.idFlag = NO;
    self.driveFlag = NO;
    self.idSuccess = NO;
    self.driveSuccess = NO;
    
    User * cu = [User getUser];
    _idParam = [[NSMutableDictionary alloc] init];
    _idParam[@"tel"] = cu.tel;
    _driveParam = [[NSMutableDictionary alloc] init];
    _driveParam[@"tel"] = cu.tel;
    [self setNav];
    
    [self setSubViews];
}

- (void) setSubViews{

    self.idImageView.userInteractionEnabled = YES;
    self.driveImageView.userInteractionEnabled = YES;
    self.idImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.driveImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.idImageView.tag = 66;
    self.driveImageView.tag = 67;
    
    self.nextBtn.layer.cornerRadius = 6;
    self.nextBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer * tapID = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(idImgTapAction)];
    [self.idImageView addGestureRecognizer:tapID];
    
    UITapGestureRecognizer * tapDrive = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(driveTapAction)];
    [self.driveImageView addGestureRecognizer:tapDrive];
    
}

#pragma mark - 身份证照片
- (void)idImgTapAction{

    NSLog(@"id");
    
    self.photoFlag = 1;
    self.idFlag    = NO;
    [self pickPhotos];
    
}

- (void) driveTapAction{

    NSLog(@"drive");
    
    self.photoFlag = 2;
    self.driveFlag = NO;
    [self pickPhotos];
    
}

- (void)pickPhotos{

    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
        // 身份证长款1.5
        
        UIImageView * scanView = [[UIImageView alloc] initWithFrame:CGRectMake(375-180, 150, 150, 120)];
        scanView.image = [UIImage imageNamed:@"idcard_first_head_5"];
        // [vc.view addSubview:scanView];
        
        vc.delegate = self;
        //   vc.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }];
    
    UIAlertAction * album = [UIAlertAction actionWithTitle:@"从照片库选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
        // 身份证长宽1.5
        
        UIImageView * scanView = [[UIImageView alloc] initWithFrame:CGRectMake(375-180, 150, 150, 120)];
        scanView.image = [UIImage imageNamed:@"idcard_first_head_5"];
        // [vc.view addSubview:scanView];
        
        vc.delegate = self;
        //   vc.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:camera];
    [alertVC addAction:album];
    [alertVC addAction:cancel];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}


#pragma mark - 选中图片的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    NSLog(@"一张图片");
    
    if (self.photoFlag == 1) {
        self.idImageView.image = info[UIImagePickerControllerOriginalImage];
        self.idFlag = YES;
    }else{
    
        self.driveImageView.image = info[UIImagePickerControllerOriginalImage];
        self.driveFlag = YES;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - 下一步，开始认证
- (IBAction)nextAction:(id)sender {
    // drive
    // [UIImage imageNamed:@"ww"];
    // self.idImageView.image;
    
    if (self.nameTF.text.length == 0) {
        [MBProgressHUD showError:@"请填写姓名" toView:nil];
    }else if (![checkString validateCertNo:self.idNumTF.text]){
        [MBProgressHUD showError:@"请填写身份证号" toView:nil];
    }else if (!self.idFlag){
        [MBProgressHUD showError:@"请上传身份证正面照" toView:nil];
    }else if (!self.driveFlag){
        [MBProgressHUD showError:@"请上传驾驶证正面照" toView:nil];
    }else{
        
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self certifyIDCard];
        
        [self certifyDriverCard];
       
    }
    
    
    
   
}

#pragma mark - 识别证件
- (void) certifyIDCard{
    
    // 参数准备
    UIImage *  image = nil;
    NSString * path  = nil;
    NSString * host  = nil;
        // 识别身份证
        image = self.idImageView.image;
        path = @"/rest/160601/ocr/ocr_idcard.json";
        host = @"https://dm-51.data.aliyun.com";
    

    NSData * imgData = UIImageJPEGRepresentation(image, 1.0);
    NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSString *appcode = @"a15eccfb9e244cc899edfe4152178c0f";
    
    NSString *method = @"POST";
    NSString *querys = @"";
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    NSString *bodys = [NSString stringWithFormat:@"{\"image\":\"%@\",\"configure\":\"{\\\"side\\\":\\\"face\\\"}\"}",encodedImageStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  10];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    //根据API的要求，定义相对应的Content-Type
    [request addValue: @"application/json; charset=UTF-8" forHTTPHeaderField: @"Content-Type"];
    NSData *data = [bodys dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody: data];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                      
            dispatch_sync(dispatch_get_main_queue(), ^{
                // 回归主线程
                if (!error) {
                    // 识别成功
                    NSError * dataErr = nil;
                    NSDictionary *bodyDic = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableLeaves error:&dataErr];
                    //打印应答中的body
                    NSLog(@"Response body: %@" , bodyDic);
                    if (![bodyDic[@"name"] isEqualToString:self.nameTF.text]) {
                        [MBProgressHUD showError:@"身份证姓名与填写姓名不一致，身份验证失败" toView:nil];
                    }else if (![bodyDic[@"num"] isEqualToString:self.idNumTF.text]){
                        [MBProgressHUD showError:@"身份证号码与填写的身份证号码不一致，身份验证失败" toView:nil];
                    }else{
                    // 身份证验证成功
                        _idParam[@"name"] = bodyDic[@"name"];
                        _idParam[@"sfz"]  = bodyDic[@"num"];
                        self.idSuccess = YES;
                        if (self.driveSuccess) {
                            // 如果驾驶证已经验证成功，则整个验证完成
                            // > 向后台完善，身份证，驾驶证信息
                            [self completeUserInfo];
                        }
                    }
                    
                }else{
                    // 识别失败
                    
                }
            });
            
                                                       
                                                       
                }];
    
    [task resume];
    
}

#pragma mark - 识别驾驶证
- (void) certifyDriverCard{

    // 参数准备
    UIImage *  image = nil;
    NSString * path  = nil;
    NSString * host  = nil;
        // 识别驾驶证
        image = self.driveImageView.image;
        path = @"/rest/160601/ocr/ocr_driver_license.json";
        host = @"https://dm-52.data.aliyun.com";
    
    NSData * imgData = UIImageJPEGRepresentation(image, 1.0);
    NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSString *appcode = @"a15eccfb9e244cc899edfe4152178c0f";
    
    NSString *method = @"POST";
    NSString *querys = @"";
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    NSString *bodys = [NSString stringWithFormat:@"{\"image\":\"%@\",\"configure\":\"{\\\"side\\\":\\\"face\\\"}\"}",encodedImageStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  10];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    //根据API的要求，定义相对应的Content-Type
    [request addValue: @"application/json; charset=UTF-8" forHTTPHeaderField: @"Content-Type"];
    NSData *data = [bodys dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody: data];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                       
        dispatch_sync(dispatch_get_main_queue(), ^{
        // 回归主线程
        if (!error) {
          // 识别成功
        NSError * dataErr = nil;
         NSDictionary *bodyDic = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableLeaves error:&dataErr];
                                                               
         //打印应答中的body
          NSLog(@"Response body: %@" , bodyDic);
//            if ([bodyDic[@"name"] isEqualToString:self.nameTF.text]) {
//                [MBProgressHUD showError:@"驾驶证姓名与所填写的姓名不一致，身份认证失败" toView:nil];
//            }else{
            _driveParam[@"jsz"] = bodyDic[@"num"];
            _driveParam[@"type"] = bodyDic[@"vehicle_type"];
            _driveParam[@"time1"]= bodyDic[@"start_date"];
            _driveParam[@"time2"]=  @"20180224";
                self.driveSuccess = YES;
                if (self.idSuccess ) {
                    // 如果身份证已经验证成功，则全部验证完成
                    // > 向后台完善用户的身份证和驾驶证信息
                    [self completeUserInfo];
                }
           // }
              }else{
          // 识别失败
                                                               
            }
           });
         }];
    
    [task resume];
}

#pragma mark - 上传身份证和驾驶证信息
- (void) completeUserInfo{
    
//    __block  BOOL idSuccess = NO;
//    __block BOOL driveSuccess = NO;

    [WSUtil wsBoolRequestWithName:@"update_user_sfz" andParam:_idParam success:^(BOOL isSuccess) {
        
      //  idSuccess = YES;
        if (isSuccess ) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"身份证认证成功" toView:nil];
            
            [WSUtil wsBoolRequestWithName:@"update_user_driver" andParam:_driveParam success:^(BOOL isSuccess) {
                    
                    if (isSuccess ) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [MBProgressHUD showSuccess:@"驾驶证认证成功" toView:nil];
                        
                        NSDictionary * dic = @{@"tel":[User getUser].tel,@"status":@"2"};
                        [WSUtil wsBoolRequestWithName:@"set_user_loginstatus" andParam:dic success:^(BOOL isSuccess) {
                            if (isSuccess) {
                                //
                                [MBProgressHUD showSuccess:@"实名认证成功" toView:nil];
                                /** 重新获取用户数据 */
                                [self getUserData];
                            }
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            [MBProgressHUD showSuccess:@"修改状态失败" toView:nil];
                        }];
                    }else{
                        [MBProgressHUD showError:@"驾驶证认证失败" toView:nil];
                    }
                    
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }else{
        
            [MBProgressHUD showError:@"身份证认证失败" toView:nil];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
   
}

#pragma mark - 更改用户状态
-(void) getUserData{

    NSDictionary * pDic = @{@"tel":[User getUser].tel};
    
    [WSUtil wsRequestWithName:@"get_user" andParam:pDic success:^(NSArray *dataArr) {
        // 用户信息
        NSLog(@"用户信息= %@",dataArr);
        // 用户信息给到user
        User * cU = [User getUser];
        [cU setUserDataWithInfoData:dataArr[0]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void) setNav{
    
    self.title = @"实名认证";
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_gray"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    // [rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [rightBtn setTitleColor:kGreenColor forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
}

- (void) leftBtn:(UIButton *)btn{
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void) rightAction{
    
    NSLog(@"联系客服");
}
@end
