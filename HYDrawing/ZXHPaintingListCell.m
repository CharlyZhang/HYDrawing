//
//  ZXHPaintingListCell.m
//  HYDrawing
//
//  Created by macbook on 15/8/24.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import "ZXHPaintingListCell.h"
#import "Macro.h"

@implementation ZXHPaintingListCell



- (void)awakeFromNib {
    [self setBorderStyleWithColor:kCommenCyanColor];
    
    self.backgroundColor = [UIColor clearColor];
    [self.btnDelete addTarget:self action:@selector(deletePainting:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setBorderStyleWithColor:(UIColor*)color{
    self.imgView.clipsToBounds = YES;
    self.imgView.layer.cornerRadius = 8;
    self.imgView.layer.borderWidth = 2;
    self.imgView.layer.borderColor = color.CGColor;
    
    self.nameLabel.backgroundColor = kColor(255, 255, 255, 0.5);
}

- (void)deletePainting:(UIButton*)sender {
    [self.delegate paintingListCellDeleteItem:self];
}

@end
