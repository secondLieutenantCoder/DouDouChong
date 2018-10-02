//
//  NearByTabCell.h
//  DouDouChong
//
//  Created by PC on 2018/4/27.
//  Copyright © 2018年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NearByTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *carImgView;

@property (weak, nonatomic) IBOutlet UILabel *carNum;
@property (weak, nonatomic) IBOutlet UILabel *contunuePower;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *belongArea;
@property (weak, nonatomic) IBOutlet UILabel *guiShu;

@property (weak, nonatomic) IBOutlet UIView *buttomView;


/** 我 当前的位置坐标 */
@property (nonatomic,assign) CLLocationCoordinate2D myLocation;
/** 反地理编码坐标 */
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@end
