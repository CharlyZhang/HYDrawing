//
//  BottomBarView.h
//  HYDrawing
//
//  Created by CharlyZhang on 15/7/17.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WDColor.h"
#import "WDColorWell.h"

@class BottomBarView;

typedef enum BottomBarButtonType {
    /// fixed buttons
    UNSET_BTN = 0,
    COLORWHEEL_BTN,                 ///<
    LAYERS_BTN,
    /// dynamic buttons
    FIXED_BTN_SEPERATOR = 100,
    ERASER_BTN,
    PENCIL_BTN,
    MARKERPEN_BTN,
    COLORBRUSH_BTN,
    CRAYON_BTN,
    BUCKET_BTN,
    SHAPEBOX_BTN,
    EYEDROPPER_BTN,
    CANVAS_BTN,
    CLIP_BTN
} BottomBarButtonType;

@protocol BottomBarViewDelegate <NSObject>

@required
- (void)bottomBarView:(BottomBarView*)bottomBarView forButtonAction:(UIButton*)button;

@end

@interface BottomBarView : UIView
@property (nonatomic, weak) id<BottomBarViewDelegate> delegate;

@property (nonatomic, strong) WDColorWell* colorWheelButton;
@property (nonatomic, strong) UIButton* eraserButton;
@property (nonatomic, strong) UIButton* pencilButton;
@property (nonatomic, strong) UIButton* markerPenButton;
@property (nonatomic, strong) UIButton* colorBrushButton;
@property (nonatomic, strong) UIButton* crayonButton;
@property (nonatomic, strong) UIButton* bucketButton;
@property (nonatomic, strong) UIButton* shapeboxButton;
@property (nonatomic, strong) UIButton* eyedropperButton;
@property (nonatomic, strong) UIButton* canvasButton;
@property (nonatomic, strong) UIButton* clipButton;
@property (nonatomic, strong) UIButton* layersButton;

@property (nonatomic, weak) UIButton *currentButton;

- (instancetype)initWithWellColor:(WDColor*) color;

@end
