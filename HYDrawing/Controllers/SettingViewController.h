//
//  SettingViewController.h
//  HYDrawing
//
//  Created by CharlyZhang on 15/11/27.
//  Copyright © 2015年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingViewController;

@protocol SettingViewControllerDelegate <NSObject>

@required

- (BOOL)settingViewControllerSavePainting:(SettingViewController *)settingController;
- (BOOL)settingViewControllerClearLayer:(SettingViewController *)settingController;
- (BOOL)settingViewControllerTransformLayer:(SettingViewController *)settingController;

@end


@interface SettingViewController : UITableViewController

@property (nonatomic, weak) id<SettingViewControllerDelegate> delegate;

@end
