//
//  ZXHShapeBoxController.h
//  HYDrawing
//
//  Created by macbook on 15/8/19.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXHShapeBoxController : UIViewController

-(instancetype)initWithPreferredContentSize:(CGSize)size;

@property(nonatomic,assign)id delegate;

@end


// --- 协议
@protocol ShapeBoxControllerDelegate <NSObject>

@required

// 选择了形状
-(void)didSelectedShape:(UIImage*)img;

// 切换背景图片
-(void)changePopoverBgImage:(BOOL)type;

@end
