//
//  SlideView.h
//  DouDouChong
//
//  Created by PC on 2018/3/6.
//  Copyright © 2018年 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideProtocol <NSObject>


/** 侧边栏按钮的点击事件 */
- (void) slideAction:(NSInteger )actionTag;

@end

@interface SlideView : UIView


@property (nonatomic,weak) id<SlideProtocol> slideDelegate;

- (void) reloadSlideInfo;


@end
