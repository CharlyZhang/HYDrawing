//
//  CliperView.m
//  截图
//
//  Created by macbook on 15/8/18.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import "CliperView.h"
#import "ClipRegionView.h"


// 默认截图区域大小
#define kCliperViewDefaultWidth 200
#define kClipeMinWidth 100

@implementation CliperView
{
    ClipRegionView *regionView;
    CliperMenuView *menuView;
}

// 初始化
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColor(0, 0, 0, 0.3);
//        self.alpha = 0.0;
        self.isMoving = NO;
        
        // 创建截图显示视图
        CGSize size = frame.size;
        CGFloat x = (size.width-kCliperViewDefaultWidth)/2;
        CGFloat y = (size.height-kCliperViewDefaultWidth)/2;
        
        regionView = [[ClipRegionView alloc]initWithFrame:CGRectMake(x, y, kCliperViewDefaultWidth, kCliperViewDefaultWidth)];
        [self addSubview:regionView];
        
        [self showCliperMenu];
    }
    
    return self;
}

#pragma mark CliperMenuViewDelegate
-(void)removeMenu{
    [menuView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)confirmClip{
    NSLog(@"确认裁剪: %@",NSStringFromCGRect(regionView.frame));
    [self removeMenu];
}

#pragma mark 显示菜单
-(void)showCliperMenu{
    if (!menuView) {
        menuView = [CliperMenuView sharedCliperMenuView];
        [[UIApplication sharedApplication].keyWindow addSubview:menuView];
        menuView.delegate = self;
    }
    
    menuView.hidden = NO;
    CGRect menuFrame = menuView.frame;
    CGRect regionFrame = regionView.frame;
    
    CGFloat _x = menuFrame.origin.x;
    CGFloat _y = menuFrame.origin.y;
    CGFloat _width = menuFrame.size.width;
    CGFloat _height = menuFrame.size.height;
    
    _x = regionFrame.size.width/2 - _width/2 + regionFrame.origin.x;
    _y = regionFrame.size.height + regionFrame.origin.y;
    
    if (_x < 0) {
        _x = 0;
    }
    if (_x > kScreenW) {
        _x = kScreenW - _width;
    }
    
    if (_y < 0) {
        _y = _height;
    }
    if (_y > kScreenH) {
        _y = kScreenH - _height;
    }
    
    menuView.frame = CGRectMake(_x, _y, _width, _height);
}

#pragma mark 触摸事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    [self setDragPointWithTouch:touch withEvent:event];
}


// 设置拖拽点
-(void)setDragPointWithTouch:(UITouch*)touch withEvent:(UIEvent *)event{
    CGRect frame = regionView.frame;
    
    if (regionView.btnLeftTop == touch.view) {
        NSLog(@"左上");
        self.startType = 0;
        regionView.layer.anchorPoint = CGPointMake(1, 1);
    }
    
    if (regionView.btnRightTop == touch.view) {
        NSLog(@"右上");
        self.startType = 1;
        regionView.layer.anchorPoint = CGPointMake(0, 1);
    }
    
    if (regionView.btnLeftBottom == touch.view) {
        NSLog(@"左下");
        self.startType = 2;
        regionView.layer.anchorPoint = CGPointMake(1, 0);
    }
    
    if (regionView.btnRightBottom == touch.view) {
        NSLog(@"右下");
        self.startType = 3;
        regionView.layer.anchorPoint = CGPointMake(0, 0);
    }
    
    if (regionView == touch.view){
        NSLog(@"区域");
        self.startType = 4;
        regionView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    
    // 恢复原来位置
    regionView.frame = frame;
}

#pragma mark 开始拖动
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // 隐藏菜单
    menuView.hidden = YES;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint curLocation = [touch locationInView:self];
    CGPoint preLocation = [touch previousLocationInView:self];
    CGPoint deltaP = CGPointMake(curLocation.x - preLocation.x, curLocation.y - preLocation.y);
    
    CGRect regionBounds = regionView.bounds;
    if (regionBounds.size.width <= kClipeMinWidth) {
        regionBounds.size.width = kClipeMinWidth;
    }
    if (regionBounds.size.height <= kClipeMinWidth) {
        regionBounds.size.height = kClipeMinWidth;
    }
    
    switch (_startType) {
        case 0:
            regionBounds.size.width -= deltaP.x;
            regionBounds.size.height -= deltaP.y;

            regionView.layer.bounds = regionBounds;
            break;
        case 1:
            regionBounds.size.width += deltaP.x;
            regionBounds.size.height -= deltaP.y;
            
            regionView.layer.bounds = regionBounds;
            break;
        case 2:
            regionBounds.size.width -= deltaP.x;
            regionBounds.size.height += deltaP.y;
            
            regionView.layer.bounds = regionBounds;
            break;
        case 3:
            regionBounds.size.width += deltaP.x;
            regionBounds.size.height += deltaP.y;
            
            regionView.layer.bounds = regionBounds;
            break;
        case 4:
        {
            CGPoint newCenter = CGPointMake(regionView.center.x + deltaP.x, regionView.center.y + deltaP.y);
            regionView.center = newCenter;
        }
            break;
        default:
            break;
    }
    
    [self resetSubviewsBouds];
}

// resetBounds
-(void)resetSubviewsBouds{
    CGSize size = regionView.frame.size;
    
    regionView.btnLeftTop.frame = [self makeRectWithPoint:CGPointMake(0, 0)];
    regionView.btnRightTop.frame = [self makeRectWithPoint:CGPointMake(size.width-kDragPointWidth, 0)];
    regionView.btnLeftBottom.frame = [self makeRectWithPoint:CGPointMake(0, size.height-kDragPointWidth)];
    regionView.btnRightBottom.frame = [self makeRectWithPoint:CGPointMake(size.width-kDragPointWidth, size.height-kDragPointWidth)];
}

-(CGRect)makeRectWithPoint:(CGPoint)point{
    return CGRectMake(point.x, point.y, kDragPointWidth, kDragPointWidth);
}

#pragma mark 事件拦截
-(UIView *)hitTest:(CGPoint)loc withEvent:(UIEvent *)event{
    CGPoint locLT = [self convertPoint:loc toView:regionView.btnLeftTop];
    CGPoint locRT = [self convertPoint:loc toView:regionView.btnRightTop];
    CGPoint locLB = [self convertPoint:loc toView:regionView.btnLeftBottom];
    CGPoint locRB = [self convertPoint:loc toView:regionView.btnRightBottom];
    CGPoint locRegion = [self convertPoint:loc toView:regionView];
    CGPoint locMenu = [self convertPoint:loc toView:menuView];
    
    if ([regionView.btnLeftTop pointInside:locLT withEvent:event]) {
        return regionView.btnLeftTop;
    }
    
    if ([regionView.btnRightTop pointInside:locRT withEvent:event]) {
        return regionView.btnRightTop;
    }
    
    if ([regionView.btnLeftBottom pointInside:locLB withEvent:event]) {
        return regionView.btnLeftBottom;
    }
    
    if ([regionView.btnRightBottom pointInside:locRB withEvent:event]) {
        return regionView.btnRightBottom;
    }
    
    if ([regionView pointInside:locRegion withEvent:event]){
        return regionView;
    }
    
    if ([menuView pointInside:locMenu withEvent:event]){
        return menuView;
    }
    
    return self;
}


#pragma mark 拖动结束
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // 菜单栏
    [self showCliperMenu];
    
//    NSLog(@"frame: %@",NSStringFromCGRect(regionView.frame));
//    NSLog(@"bounds: %@",NSStringFromCGRect(regionView.bounds));
    //    NSLog(@"layer: %@",NSStringFromCGPoint(regionView.layer.anchorPoint));
}
@end
