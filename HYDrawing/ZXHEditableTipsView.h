//
//  ZXHEditableTipsView.h
//  HYDrawing
//
//  Created by macbook on 15/8/14.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXHEditableTipsView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *visibleView;
@property (weak, nonatomic) IBOutlet UIImageView *lockedView;

@property(nonatomic,assign)BOOL visible;
@property(nonatomic,assign)BOOL locked;

+(id)defaultTipsView;
-(void)showTips;
-(void)dismissTips;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *superViewWidthCons;

@end
