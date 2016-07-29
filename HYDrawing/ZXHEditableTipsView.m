//
//  ZXHEditableTipsView.m
//  HYDrawing
//
//  Created by macbook on 15/8/14.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import "ZXHEditableTipsView.h"
#import "Macro.h"

@implementation ZXHEditableTipsView

static ZXHEditableTipsView *tipsView;

+(id)defaultTipsView{
    if (!tipsView) {
//        CGFloat bottomBarH = 119;
        
        tipsView = [[NSBundle mainBundle]loadNibNamed:@"ZXHEditableTipsView" owner:self options:nil][0];
        tipsView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        tipsView.backgroundColor = [UIColor clearColor];
        tipsView.alpha = 0;
        // 提示图片
        tipsView.visibleView.hidden = NO;
        tipsView.lockedView.hidden = NO;
    }
    
    return tipsView;
}

#pragma mark 手势
-(void)showTips{
    // 显示提示
    if (_visible) {
        self.visibleView.hidden = YES;
    }else{
        self.visibleView.hidden = NO;
    }
    
    if (!_locked) {
        self.lockedView.hidden = YES;
    }else{
        self.lockedView.hidden = NO;
    }
    
    if (!_visible || _locked) {
        [UIView animateWithDuration:0.05 animations:^{
            self.alpha = 1;
        }];
        
        if(!_visible && _locked){
            self.superViewWidthCons.constant = 150;
        }else
            self.superViewWidthCons.constant = 70;
    }
}

-(void)dismissTips{

    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [tipsView removeFromSuperview];
    }];
}

@end
