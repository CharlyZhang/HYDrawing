//
//  ZXHCanvasBackgroundCell.m
//  HYDrawing
//
//  Created by macbook on 15/8/20.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import "ZXHCanvasBackgroundCell.h"
#import "Macro.h"

@implementation ZXHCanvasBackgroundCell

- (void)awakeFromNib {
    self.backgroundColor = kImageColor(@"canvasBg_item_bg");
    self.imgView.clipsToBounds = YES;
    self.imgView.layer.cornerRadius = 4;
}

@end
