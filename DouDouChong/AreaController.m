//
//  AreaController.m
//  DouDouChong
//
//  Created by PC on 2018/3/5.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "AreaController.h"
#import "pinyin 2.h"

@interface AreaController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView * tableView;

@end

static NSString * areaCell = @"areaCell";

@implementation AreaController{


    NSArray * _areaArr;
    
    NSMutableDictionary * _totalDic;
    
    // 取消确认按钮
    UIButton * _cAndSBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    [self setSubViews];
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, kWidth, kHeight-70)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:areaCell];
    [self.view addSubview:self.tableView];
    
}

- (void) loadData{

    _areaArr = @[@"滨海市",@"临朐县",@"青州市",@"潍坊市",@"全福元",@"朐山",@"北京市",@"烟台市",@"青岛市",@"菏泽市",@"日照市",@"莱芜市",@"淄博市",@"威海市",@"临沂市",@"德州市",@"滨州市",@"枣庄市",@"泰安市",@"济南市",@"聊城市",@"上海市",@"济宁市",@"寿光市",@"诸城市",@"章丘市"];
    
    //> 存放字典数组 已首字母为 Key
  //  NSMutableArray * totalArr = [[NSMutableArray alloc] init];
    _totalDic = [[NSMutableDictionary alloc] init];
    
    for (int i = 0;i<_areaArr.count;i++) {
        NSString * cName = _areaArr[i];
        char c=pinyinFirstLetter([cName characterAtIndex:0])-32;
        
        NSString * fLetter=[NSString stringWithFormat:@"%c",c];
        
        NSArray * keys = _totalDic.allKeys;
        if (![keys containsObject:fLetter]) {
            // 不包含该首字母
            NSMutableArray * letterArr = [[NSMutableArray alloc] init];
            [letterArr addObject:cName];
            _totalDic[fLetter] = letterArr;
            
        }else{
        // 已存在该首字母
            
            NSMutableArray * lArr = [[NSMutableArray alloc] initWithArray:_totalDic[fLetter]];
            [lArr addObject:cName];
            _totalDic[fLetter] = lArr;
        
            
        }
        
        NSLog(@"%@",fLetter);
    }
    
    
}

#pragma mark 
- (void) setSubViews{
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:246/255.0 alpha:1];
    
    UIView *tbView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 70)];
    tbView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tbView];
    
    UITextField * cityTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 35, kWidth-120, 35)];
    cityTF.delegate = self;
    cityTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    cityTF.placeholder = @"请输入要查询的城市";
    cityTF.borderStyle = UITextBorderStyleNone;
    [cityTF addTarget:self action:@selector(searchChangeValueAction:) forControlEvents:UIControlEventEditingChanged];
    [tbView addSubview:cityTF];

    _cAndSBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-85, 35, 85, 30)];
//    _cAndSBtn.backgroundColor = [UIColor redColor];
    _cAndSBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_cAndSBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cAndSBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _cAndSBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_cAndSBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [tbView addSubview:_cAndSBtn];
    
    
}

-(void) searchChangeValueAction:(UITextField *)tf{

    if (tf.text.length > 0) {
        [_cAndSBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_cAndSBtn setTitleColor:kGreenColor forState:UIControlStateNormal];
    }else{
    
        [_cAndSBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cAndSBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

//- (BOOL)textFieldShouldClear:(UITextField *)textField{
//
//    return YES;
//    
//}

#pragma mark - TF代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * letterArr1 = _totalDic.allKeys;
    NSArray *letterArr = [letterArr1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString * key = letterArr[section];
    
    NSArray * cArr = _totalDic[key];
    return cArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:areaCell];
    
    NSArray * letterArr1 = _totalDic.allKeys;
    NSArray *letterArr = [letterArr1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString * key = letterArr[indexPath.section];
    
    NSArray * cArr = _totalDic[key];
    cell.textLabel.text = cArr[indexPath.row];
    
    return cell;
    
}
#pragma mark - 点击选择区域
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"区域选择：临朐，青州");
    
    
}


- (nullable NSArray<NSString *> *) sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    
//    /** 记录每一个省的序号，虽然不是每一个都放进数组之中 */
//    NSInteger newIndex=0;
//    
//    NSMutableArray * letterArray=[NSMutableArray array];
//    for (NSString * pName in self.provinceArray) {
//        
//        
//        char c=pinyinFirstLetter([pName characterAtIndex:0])-32;
//        
//        NSString * fLetter=[NSString stringWithFormat:@"%c",c];
//        /** 重庆多音字，需要特殊处理 */
//        if ([pName  isEqualToString:@"重庆"]) {
//            fLetter=@"C";
//        }
//        /** 拒绝同名 */
//        if (![letterArray containsObject:fLetter]) {
//            [letterArray addObject:fLetter];
//            
//            /** 新出现首字母的省的序号放进数组 */
//            [self.indexArray addObject:@(newIndex)];
//        }
//        newIndex ++;
//    }
//    
//    return letterArray;
    
    NSArray * letterArr1 = _totalDic.allKeys;
    NSArray *letterArr = [letterArr1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    return letterArr;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{

    NSArray * letterArr1 = _totalDic.allKeys;
    NSArray *letterArr = [letterArr1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    return letterArr.count;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    NSArray * letterArr1 = _totalDic.allKeys;
    NSArray *letterArr = [letterArr1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    return letterArr[section];
}







#pragma mark - 退出页面
- (void) cancelAction:(UIButton *)btn{

    
    NSString * title = btn.titleLabel.text;
    if ([title isEqualToString:@"取消"]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
    
        NSLog(@"确认选中城市");
    }
    
    
    
}



@end
