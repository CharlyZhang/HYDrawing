//
//  ClipRegionView.h
//  截图
//
//  Created by macbook on 15/8/18.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRegionSize self.frame.size
#define kDragPointWidth 20
#define kDragPoint01 CGPointMake(0, 0)
#define kDragPoint02 CGPointMake(kRegionSize.width-kDragPointWidth, 0)
#define kDragPoint03 CGPointMake(0, kRegionSize.height-kDragPointWidth)
#define kDragPoint04 CGPointMake(kRegionSize.width-kDragPointWidth, kRegionSize.height-kDragPointWidth)

@interface ClipRegionView : UIView
// 触点
@property (weak, nonatomic)IBOutlet UIView *btnLeftTop;
@property (weak, nonatomic)IBOutlet UIView *btnRightTop;
@property (weak, nonatomic)IBOutlet UIView *btnLeftBottom;
@property (weak, nonatomic)IBOutlet UIView *btnRightBottom;

@end
