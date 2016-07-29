//
//  LayersCell.m
//  HYDrawing
//
//  Created by macbook on 15/8/10.
//  Copyright (c) 2015年 Founder. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LayersCell.h"
#import "Macro.h"

@implementation LayersCell

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        // 设置默认值
        _isVisible = YES;
        _isLocked = NO;
    }
    return self;
}

-(void)awakeFromNib{
    self.backgroundColor = kCommenSkinColor;

    [self setOutlineViewBorderWithColor:kCommenCyanColor];
    self.outlineWidthCons.constant = 90*kScreenScale;
 
//    NSLog(@"---%f",kScreenScale);
    self.outlineView.backgroundColor = kImageColor(@"layer_showimg_bg");
}

// 轮廓样式
-(void)setOutlineViewBorderWithColor:(UIColor *)color{
    _outlineView.layer.borderWidth = 2;
    _outlineView.layer.borderColor = color.CGColor;
    _outlineView.layer.cornerRadius = 4;
    
}

// 选中cell的背景图片
-(UIView *)selectedBackgroundView{
    UIView *view = (UIView *)[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"layer_cell_selected_bg"]];
    return view;
}

- (IBAction)setUnvisibleOr:(UIButton *)sender {

    if (_isVisible) {
        [sender setImage:[UIImage imageNamed:@"layer_invisible"] forState:0];
    }else{
        [sender setImage:[UIImage imageNamed:@"layer_visible"] forState:0];
    }
    
    _isVisible = !_isVisible;
//    NSLog(@"row: %ld",_rowIndex);
    
    // 是否可见
    if (_changeVisible) {
        self.changeVisible(_isVisible,_rowIndex);
    }
}

- (IBAction)setLockOr:(UIButton *)sender {
    if (!_isLocked) {
        [sender setImage:[UIImage imageNamed:@"layer_lock"] forState:0];
    }else{
        [sender setImage:[UIImage imageNamed:@"layer_unlock"] forState:0];
    }
    
    _isLocked = !_isLocked;
    // 是否锁定
    self.changeLocked(_isLocked,_rowIndex);
}
@end
