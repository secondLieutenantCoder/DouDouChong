//
//  XCTableViewCell.m
//  DouDouChong
//
//  Created by PC on 2018/5/30.
//  Copyright © 2018年 PC. All rights reserved.
//

#import "XCTableViewCell.h"

@implementation XCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.borderWidth = 0.6;
    self.backView.layer.borderColor = [UIColor darkTextColor].CGColor;
    
    // 订单状态
    [self.stateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -85)];
    [self.stateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
