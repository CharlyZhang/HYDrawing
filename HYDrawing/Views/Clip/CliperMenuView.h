//
//  CliperMenuView.h
//  截图
//
//  Created by macbook on 15/8/18.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CliperMenuView : UIView

@property (weak, nonatomic) UIButton *btnOk;
@property (weak, nonatomic) UIButton *btnCancel;
@property (nonatomic,assign)id delegate;
- (IBAction)btnCancelClick:(UIButton *)sender;
- (IBAction)btnOkClick:(UIButton *)sender;

// 单例
+(id)sharedCliperMenuView;

@end


@protocol CliperMenuViewDelegate <NSObject>

@required
-(void)removeMenu;
-(void)confirmClip;

@end