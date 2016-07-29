//
//  CliperMenuView.m
//  截图
//
//  Created by macbook on 15/8/18.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import "CliperMenuView.h"

@implementation CliperMenuView

static CliperMenuView *menu;

+(id)sharedCliperMenuView{
    if (!menu) {
        menu = [[NSBundle mainBundle]loadNibNamed:@"CliperMenuView" owner:self options:nil][0];
    }
    return menu;
}

- (IBAction)btnCancelClick:(UIButton *)sender{
    [self.delegate removeMenu];
}

- (IBAction)btnOkClick:(UIButton *)sender {
    [self.delegate confirmClip];
}

@end
