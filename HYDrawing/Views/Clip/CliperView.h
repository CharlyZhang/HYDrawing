//
//  CliperView.h
//  截图
//
//  Created by macbook on 15/8/18.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CliperMenuView.h"
#import "Macro.h"


@interface CliperView : UIView<CliperMenuViewDelegate>

@property(nonatomic,assign)BOOL isMoving;
@property(nonatomic,assign)NSInteger startType;
@property(nonatomic,assign)CGFloat alphaInRegion;
//@property(nonatomic,strong)CliperMenuView *menuView;

@end