//
//  ClipRegionView.m
//  截图
//
//  Created by macbook on 15/8/18.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import "ClipRegionView.h"
#import "Macro.h"

@implementation ClipRegionView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        self = [[NSBundle mainBundle]loadNibNamed:@"ClipRegionView" owner:self options:nil][0];
        self.frame = frame;
        self.backgroundColor = kColor(255, 255, 255, 0.8);
        
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        // pin手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchGesture:)];
        self.gestureRecognizers = @[pinch];
    }
    
    return self;
}

// 触点
-(void)createDragPoints{
    [self createDragPointWithView:self.btnLeftTop position:kDragPoint01];
    [self createDragPointWithView:self.btnRightTop position:kDragPoint02];
    [self createDragPointWithView:self.btnLeftBottom position:kDragPoint03];
    [self createDragPointWithView:self.btnRightBottom position:kDragPoint04];
}

-(void)createDragPointWithView:(UIView*)view position:(CGPoint)point{
    view = [[UIView alloc]initWithFrame:CGRectMake(point.x, point.y, kDragPointWidth, kDragPointWidth)];
    
    [self addSubview:view];
}

-(void)handlePinchGesture:(UIPinchGestureRecognizer*)pinch{
    if (pinch.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = pinch.scale;
        
        CGRect frame = self.frame;
        frame.size.width *= scale;
        frame.size.height *= scale;
        self.frame = frame;
        
        pinch.scale = 1;
    }
}


@end
