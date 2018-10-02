//
//  DemoMenuController.m
//  DouDouChong
//
//  Created by PC on 2018/2/28.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "DemoMenuController.h"
//#import "DEMOHomeViewController.h"
#import "HomeController.h"
#import "DEMOSecondViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface DemoMenuController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@end

@implementation DemoMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0,184)];
   // view.backgroundColor = [UIColor whiteColor];
   // UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth-100)/2.0, 40, 100, 100)];
    
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    imageView.image = [UIImage imageNamed:@"superMan"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 50.0;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 3.0f;
    imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    imageView.layer.shouldRasterize = YES;
    imageView.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kWidth-160)/2.0, 150, 200, 24)];
    label.text = @"豆豆虫用户";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    //clearColor
    label.backgroundColor = [UIColor cyanColor];
    label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    [label sizeToFit];
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    [view addSubview:imageView];
    [view addSubview:label];
    
    [self.view addSubview:view];
    
    self.tableView = [[UITableView   alloc] initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 300)];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
   // self.tableView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.tableView];
    
    UIView * fView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-130, self.view.frame.size.width, 130)];
  //  fView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:fView];
}




#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        // 侧边栏第一项点击
        HomeController *homeViewController = [[HomeController alloc] init];
        navigationController.viewControllers = @[homeViewController];
        
    } else {
        // 侧边栏点击
        DEMOSecondViewController *secondViewController = [[DEMOSecondViewController alloc] init];
       // navigationController.viewControllers = @[secondViewController];
        [navigationController pushViewController:secondViewController animated:YES];
    }
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"home", @"Profile", @"Chats"];
        cell.textLabel.text = titles[indexPath.row];
    } else {
        NSArray *titles = @[@"John Appleseed", @"John Doe", @"Test User"];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}


@end
