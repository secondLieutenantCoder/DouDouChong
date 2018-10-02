//
//  UserInfoController.m
//  DouDouChong
//
//  Created by PC on 2018/6/22.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "UserInfoController.h"
#import "CertifyController.h"
#import "EditUserController.h"

@interface UserInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *stateLab;

@end

@implementation UserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:246/255.0 alpha:1];
    
    self.headImg.layer.cornerRadius = 30;
    self.headImg.layer.masksToBounds = YES;
    
    self.headImg.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headAction)];
    [self.headImg addGestureRecognizer:tap];
    self.headImg.contentMode = UIViewContentModeScaleAspectFill;
    
}



- (IBAction)backAction:(id)sender {
    
    
}

- (IBAction)editAction:(id)sender {
    
    
}

- (IBAction)shimingAction:(id)sender {
    
    CertifyController * certifyVC = [[CertifyController alloc] init];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:certifyVC];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark - 设置头像
- (void) headAction{

    [self pickPhotos];
}

- (void)pickPhotos{
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
        // 身份证长款1.5
        vc.allowsEditing = YES;
        vc.showsCameraControls = YES;
        
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
        
        vc.allowsEditing = YES;
       // vc.showsCameraControls = YES;
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
    
   
    self.headImg.image = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


- (void) setNav{
    
    self.title = @"我的资料";
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_gray"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
    // [rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [rightBtn setTitle:@"编辑资料" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
}

#pragma mark - edit
- (void) rightAction{
    
    NSLog(@"Edit");
    EditUserController * editVC = [[EditUserController alloc] init];
    
    [self.navigationController   pushViewController:editVC animated:YES];
}

#pragma mark - 返回
- (void) leftBtn:(UIButton *)btn{
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


@end
