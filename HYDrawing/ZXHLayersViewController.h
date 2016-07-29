//
//  ZXHLayersViewController.h
//  HYDrawing
//
//  Created by macbook on 15/8/10.
//  Copyright (c) 2015年 Founder. All rights reserved.
//
#import "ZXHLayerTopBar.h"
#import <UIKit/UIKit.h>

@interface ZXHLayersViewController : UIViewController

@property(nonatomic,strong)ZXHLayerTopBar *topToolBar;
@property(nonatomic,assign)NSInteger layersCount;
@property(nonatomic,strong)UITableView *tbView;

@end
