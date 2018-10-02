//
//  XCTableViewCell.h
//  DouDouChong
//
//  Created by PC on 2018/5/30.
//  Copyright © 2018年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;

/** 行程订单状态  */
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@end
