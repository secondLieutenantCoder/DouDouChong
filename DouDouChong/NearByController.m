//
//  NearByController.m
//  DouDouChong
//
//  Created by PC on 2018/4/27.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "NearByController.h"
#import "NearByTabCell.h"
#import "PopSelectViewController.h"

@interface NearByController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,ChangeTextFiledProtocol>

@property (nonatomic,strong) UITableView * tableView;

/** 距离/续航选择按钮 **/
@property (nonatomic,strong) UIButton * typeBtn;

@end

static NSString * nearCell = @"nearByCell";

@implementation NearByController

-(UITableView *)tableView{

    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.rowHeight  = 150;
        [_tableView registerNib:[UINib nibWithNibName:@"NearByTabCell" bundle:nil] forCellReuseIdentifier:nearCell];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    self.title = @"查看附近车辆";
    
    [self.view addSubview:self.tableView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.typeBtn setTitle:@"距离优先" forState:UIControlStateNormal];
    // > 车辆数据排序
    // > 距离优先
    
    for (int i = 0; i<self.nearCarArr.count; i++) {
        
        for (int j=0; j<self.nearCarArr.count-i-1; j++) {
            NSDictionary * d1 = self.nearCarArr[j];
            NSDictionary * d2 = self.nearCarArr[j+1];
            
            CLLocationCoordinate2D p1 = CLLocationCoordinate2DMake([d1[@"lat"] doubleValue], [d1[@"lon"] doubleValue]);
            CLLocationCoordinate2D p2 = CLLocationCoordinate2DMake([d2[@"lat"] doubleValue], [d2[@"lon"] doubleValue]);
            
            double distance1 = [self distanceBetweenOrderBy:self.myLocation :p1];
            double distance2 = [self distanceBetweenOrderBy:self.myLocation :p2];
            
            if (distance1 > distance2) {
                NSDictionary * tmp = d2;
                
                self.nearCarArr[j+1] = self.nearCarArr[j];
                
                self.nearCarArr[j]  = tmp;
            }
        }
    }
    [self.tableView reloadData];
    

    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    
}

-(void) setNav{
    
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"arrow_left_gray"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];

    self.typeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
   // [slideBtn setImage:[UIImage imageNamed:@"main_personcenter_img"] forState:UIControlStateNormal];
    [self.typeBtn setTitle:@"距离优先" forState:UIControlStateNormal];
    [self.typeBtn addTarget:self action:@selector(slideAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.typeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    UIBarButtonItem * slideItem = [[UIBarButtonItem alloc] initWithCustomView:self.typeBtn];
    
    self.navigationItem.rightBarButtonItem = slideItem;

}
- (void) slideAction:(UIButton *) btn{

    NSLog(@"距离优先");
    PopSelectViewController * tipVC  = [[PopSelectViewController alloc] initWithNibName:@"PopSelectViewController" bundle:[NSBundle mainBundle]];
    tipVC.itemArr = @[@{@"name":@"距离优先"},@{@"name":@"续航优先"}];
    tipVC.popDelegate = self;
    tipVC.preferredContentSize = CGSizeMake(120, 90);
    tipVC.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController * popVC = tipVC.popoverPresentationController;
    popVC.delegate = self;
    popVC.sourceView = btn;
    popVC.sourceRect = CGRectMake(btn.frame.size.width*12/13.0, btn.frame.size.height, 0, 0);
    tipVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:tipVC animated:YES completion:nil];
    
}
#pragma mark - popViewController 的代理方法，实现该方法才能够局部弹出控制器
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    
    return UIModalPresentationNone;
}

#pragma mark - popVC代理方法
- (void) changeTextFiledContentWith:(NSString *)newContent{

    [MBProgressHUD showSuccess:newContent toView:nil];
    
  //  [self.typeBtn setTitle:newContent forState:UIControlStateNormal];
    
    if ([newContent isEqualToString:self.typeBtn.titleLabel.text]) {// 和原来一样不用改变
        //
    }else{
        // 根据选择对车辆排序
        
        if ([newContent isEqualToString:@"续航优先"]) {
        // > 续航优先
//            NSMutableArray * dataArr = [[NSMutableArray alloc] init];
            for (int i = 0; i<self.nearCarArr.count; i++) {
                
                for (int j=0; j<self.nearCarArr.count-i-1; j++) {
                    NSDictionary * d1 = self.nearCarArr[j];
                    NSDictionary * d2 = self.nearCarArr[j+1];
                    
                    NSInteger distance1 = [d1[@"continue_dis"] integerValue];
                    NSInteger distance2 = [d2[@"continue_dis"] integerValue];
                    
                    if (distance1 > distance2) {
                        NSDictionary * tmp = d2;
                        
                        self.nearCarArr[j+1] = self.nearCarArr[j];
                        
                        self.nearCarArr[j]  = tmp;
                    }
                }
            }
            [self.tableView reloadData];
            
        }else{
        // > 距离优先
            
            for (int i = 0; i<self.nearCarArr.count; i++) {
                
                for (int j=0; j<self.nearCarArr.count-i-1; j++) {
                    NSDictionary * d1 = self.nearCarArr[j];
                    NSDictionary * d2 = self.nearCarArr[j+1];
                    
                    CLLocationCoordinate2D p1 = CLLocationCoordinate2DMake([d1[@"lat"] doubleValue], [d1[@"lon"] doubleValue]);
                    CLLocationCoordinate2D p2 = CLLocationCoordinate2DMake([d2[@"lat"] doubleValue], [d2[@"lon"] doubleValue]);
                    
                    double distance1 = [self distanceBetweenOrderBy:self.myLocation :p1];
                    double distance2 = [self distanceBetweenOrderBy:self.myLocation :p2];
                    
                    if (distance1 > distance2) {
                        NSDictionary * tmp = d2;
                        
                        self.nearCarArr[j+1] = self.nearCarArr[j];
                        
                        self.nearCarArr[j]  = tmp;
                    }
                }
            }
            [self.tableView reloadData];
        }
    }
    
   [self.typeBtn setTitle:newContent forState:UIControlStateNormal];
}

#pragma mark * 计算两个坐标之间的距离
-(double)distanceBetweenOrderBy:(CLLocationCoordinate2D) p1 :(CLLocationCoordinate2D) p2{
    
    double lat1 = p1.latitude;
    double lng1 = p1.longitude;
    double lat2 = p2.latitude;
    double lng2 = p2.longitude;
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    
    return  distance;
    
}

- (void)leftBtn:(UIButton *)btn{

    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.nearCarArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

   NearByTabCell * cell = [tableView dequeueReusableCellWithIdentifier:nearCell];
    NSDictionary * cDic = self.nearCarArr[indexPath.row];
    cell.carNum.text = cDic[@"num"];
    cell.belongArea.text = cDic[@"city"];
    cell.contunuePower.text = [NSString stringWithFormat:@"%ld%% | 续航约%@km",[cDic[@"continue_ele"] integerValue],cDic[@"continue_dis"]];
    cell.myLocation = self.myLocation;
    CLLocationCoordinate2D chooseOne = CLLocationCoordinate2DMake([cDic[@"lat"] doubleValue], [cDic[@"lon"] doubleValue]);
    cell.coordinate  = chooseOne;
    
    return cell;
}

#pragma mark - 选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UIViewController * vc = [[UIViewController alloc] init];
//    vc.title = @"tmp";
//    vc.view.backgroundColor = [UIColor redColor];
//    [self.navigationController pushViewController:vc animated:YES];
//    
    // > 返回main 和 车辆的位置信息
    NSDictionary * cDic = self.nearCarArr[indexPath.row];
    [self.nearDelegate chooseNearCarWithInfo:cDic];
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
