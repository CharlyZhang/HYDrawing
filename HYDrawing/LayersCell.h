//
//  LayersCell.h
//  HYDrawing
//
//  Created by macbook on 15/8/10.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayersCell : UITableViewCell

// 点击的所在行
@property(nonatomic,assign)NSInteger rowIndex;

@property (weak, nonatomic) IBOutlet UIButton *btnVisible;
@property (weak, nonatomic) IBOutlet UIButton *btnUnlock;
@property (weak, nonatomic) IBOutlet UIView *outlineView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

- (IBAction)setUnvisibleOr:(UIButton *)sender;
- (IBAction)setLockOr:(UIButton *)sender;

-(void)setOutlineViewBorderWithColor:(UIColor*)color;

@property(nonatomic,assign)BOOL isVisible;
@property(nonatomic,assign)BOOL isLocked;

// Block传递可见 锁定
@property(nonatomic,copy)void (^changeVisible)(BOOL visible,NSInteger row);
@property(nonatomic,copy)void (^changeLocked)(BOOL locked,NSInteger row);

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outlineWidthCons;

// 透明度
@property(nonatomic,assign)CGFloat opacity;

@end
