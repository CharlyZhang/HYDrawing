//
//  BottomBarView.m
//  HYDrawing
//
//  Created by CharlyZhang on 15/7/17.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import "BottomBarView.h"

@interface BottomBarView()<UIScrollViewDelegate>
{
}

@property (nonatomic, strong) UIScrollView *toolsScrollView;

@end

@implementation BottomBarView

#pragma mark - Properties

- (WDColorWell*)colorWheelButton {
//    if (!_colorWheelButton) {
//        _colorWheelButton = [[UIButton alloc] init];
//        [_colorWheelButton setImage:[UIImage imageNamed:@"color_wheel"] forState:UIControlStateNormal];
//        [_colorWheelButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
//        _colorWheelButton.tag = COLORWHEEL_BTN;
//    }

    if (!_colorWheelButton) {
        _colorWheelButton = [[WDColorWell alloc] initWithFrame:CGRectMake(0, 0, 74, 98)];
        [_colorWheelButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        _colorWheelButton.tag = COLORWHEEL_BTN;

    }
    return _colorWheelButton;
}

- (UIButton*)eraserButton {
    if (!_eraserButton) {
        _eraserButton = [[UIButton alloc]init];
        [_eraserButton setImage:[UIImage imageNamed:@"eraser"] forState:UIControlStateNormal];
        [_eraserButton setImage:[UIImage imageNamed:@"eraser_sel"] forState:UIControlStateSelected];
        [_eraserButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        _eraserButton.tag = ERASER_BTN;
    }
    return _eraserButton;
}

- (UIButton*)pencilButton {
    if (!_pencilButton) {
        _pencilButton = [[UIButton alloc]init];
        [_pencilButton setImage:[UIImage imageNamed:@"pencil"] forState:UIControlStateNormal];
        [_pencilButton setImage:[UIImage imageNamed:@"pencil_sel"] forState:UIControlStateSelected];
        [_pencilButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        _pencilButton.tag = PENCIL_BTN;
    }
    return _pencilButton;
}

- (UIButton*)markerPenButton {
    if (!_markerPenButton) {
        _markerPenButton = [[UIButton alloc]init];
        [_markerPenButton setImage:[UIImage imageNamed:@"marker"] forState:UIControlStateNormal];
        [_markerPenButton setImage:[UIImage imageNamed:@"marker_sel"] forState:UIControlStateSelected];
        [_markerPenButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        _markerPenButton.tag = MARKERPEN_BTN;
    }
    
    return _markerPenButton;
}

- (UIButton*)colorBrushButton {
    if (!_colorBrushButton) {
        _colorBrushButton = [[UIButton alloc]init];
        [_colorBrushButton setImage:[UIImage imageNamed:@"color_brush"] forState:UIControlStateNormal];
        [_colorBrushButton setImage:[UIImage imageNamed:@"color_brush_sel"] forState:UIControlStateSelected];
        [_colorBrushButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        _colorBrushButton.tag = COLORBRUSH_BTN;
    }
    
    return _colorBrushButton;
}

- (UIButton*)crayonButton {
    if (!_crayonButton) {
        _crayonButton = [[UIButton alloc]init];
        [_crayonButton setImage:[UIImage imageNamed:@"crayon"] forState:UIControlStateNormal];
        [_crayonButton setImage:[UIImage imageNamed:@"crayon_sel"] forState:UIControlStateSelected];
        [_crayonButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        _crayonButton.tag = CRAYON_BTN;
    }
    
    return _crayonButton;
}

- (UIButton*)bucketButton {
    if (!_bucketButton) {
        _bucketButton = [[UIButton alloc]init];
        [_bucketButton setImage:[UIImage imageNamed:@"bucket"] forState:UIControlStateNormal];
        [_bucketButton setImage:[UIImage imageNamed:@"bucket_sel"] forState:UIControlStateSelected];
        [_bucketButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        _bucketButton.tag = BUCKET_BTN;
    }
    
    return _bucketButton;
}

- (UIButton*)shapeboxButton {
    if (!_shapeboxButton) {
        _shapeboxButton = [[UIButton alloc]init];
        [_shapeboxButton setImage:[UIImage imageNamed:@"shapebox"] forState:UIControlStateNormal];
        [_shapeboxButton setImage:[UIImage imageNamed:@"shapebox_sel"] forState:UIControlStateSelected];
        [_shapeboxButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        _shapeboxButton.tag = SHAPEBOX_BTN;
    }
    return _shapeboxButton;
}

- (UIButton*)eyedropperButton {
    if (!_eyedropperButton) {
        _eyedropperButton = [[UIButton alloc]init];
        [_eyedropperButton setImage:[UIImage imageNamed:@"eyedropper"] forState:UIControlStateNormal];
        [_eyedropperButton setImage:[UIImage imageNamed:@"eyedropper_sel"] forState:UIControlStateSelected];
        [_eyedropperButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        _eyedropperButton.tag = EYEDROPPER_BTN;
    }
    
    return _eyedropperButton;
}

- (UIButton*)canvasButton {
    if (!_canvasButton) {
        _canvasButton = [[UIButton alloc]init];
        [_canvasButton setImage:[UIImage imageNamed:@"canvas"] forState:UIControlStateNormal];
        [_canvasButton setImage:[UIImage imageNamed:@"canvas_sel"] forState:UIControlStateSelected];
        [_canvasButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        _canvasButton.tag = CANVAS_BTN;
    }
    
    return _canvasButton;
}

- (UIButton*)clipButton {
    if (!_clipButton) {
        _clipButton = [[UIButton alloc]init];
        [_clipButton setImage:[UIImage imageNamed:@"clip"] forState:UIControlStateNormal];
        [_clipButton setImage:[UIImage imageNamed:@"clip_sel"] forState:UIControlStateSelected];
        [_clipButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        _clipButton.tag = CLIP_BTN;
    }
    
    return _clipButton;
}

- (UIButton*)layersButton {
    if (!_layersButton) {
        _layersButton = [[UIButton alloc]init];
        [_layersButton setImage:[UIImage imageNamed:@"layer"] forState:UIControlStateNormal];
        [_layersButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        _layersButton.tag = LAYERS_BTN;
    }
    
    return _layersButton;
}

- (void)setCurrentButton:(UIButton*)currentButton{
    _currentButton.selected = NO;
    currentButton.selected = YES;
    _currentButton = currentButton;
}

- (UIScrollView*)toolsScrollView{
    if (!_toolsScrollView) {
        _toolsScrollView = [[UIScrollView alloc] init];
        [_toolsScrollView addSubview:self.pencilButton];
        [_toolsScrollView addSubview:self.markerPenButton];
        [_toolsScrollView addSubview:self.colorBrushButton];
        [_toolsScrollView addSubview:self.crayonButton];
        [_toolsScrollView addSubview:self.bucketButton];
        [_toolsScrollView addSubview:self.shapeboxButton];
        [_toolsScrollView addSubview:self.eyedropperButton];
        [_toolsScrollView addSubview:self.canvasButton];
        [_toolsScrollView addSubview:self.clipButton];

        [self addConstrainsForScrollView];
        
        /// setting
        _toolsScrollView.directionalLockEnabled = YES;
    }
    
    return _toolsScrollView;
}

//- (UIButton&)
#pragma mark - UIView Methods

- (instancetype)initWithWellColor:(WDColor*) color {
    if(self = [super init]) {
        /// add subviews
        UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottom_bar"]];
        [self addSubview:backgroundView];
        self.frame = CGRectMake(0, 0,backgroundView.frame.size.width,backgroundView.frame.size.height);
        
        self.colorWheelButton.color = color;
        [self addSubview:self.colorWheelButton];
        [self addSubview:self.eraserButton];
        [self addSubview:self.toolsScrollView];
        [self addSubview:self.layersButton];
        /// add constraints
        [self addConstrainsForBottomView];
        
        /// setting
        self.currentButton = self.pencilButton;
        
    }
    
    return self;
}

#pragma mark - BottomBarView Methods

- (void) addConstrainsForBottomView {
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_colorWheelButton,_eraserButton,_toolsScrollView,_layersButton);
    NSDictionary *metrics = @{@"hPadding1" :@11,@"hPadding2" :@13,@"vHeight":@98,@"vWidth":@73};
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:@"H:|-hPadding1-[_colorWheelButton(vWidth)]-hPadding1-[_eraserButton(vWidth)]-hPadding1-[_toolsScrollView]-hPadding2-[_layersButton(vWidth)]-hPadding2-|"
                            options:0
                            metrics:metrics
                            views:viewsDictionary];
    
    /// deal with vertical constraints
    _colorWheelButton.translatesAutoresizingMaskIntoConstraints = NO;
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint
                            constraintsWithVisualFormat:@"V:[_colorWheelButton(vHeight)]|"
                            options:0
                            metrics:metrics
                            views:viewsDictionary]];
    
    _eraserButton.translatesAutoresizingMaskIntoConstraints = NO;
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint
                                                              constraintsWithVisualFormat:@"V:[_eraserButton(vHeight)]|"
                                                              options:0
                                                              metrics:metrics
                                                              views:viewsDictionary]];
    
    _toolsScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint
                                                              constraintsWithVisualFormat:@"V:|[_toolsScrollView]|"
                                                              options:0
                                                              metrics:metrics
                                                              views:viewsDictionary]];
    
    _layersButton.translatesAutoresizingMaskIntoConstraints = NO;
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint
                                                              constraintsWithVisualFormat:@"V:[_layersButton(vHeight)]|"
                                                              options:0
                                                              metrics:metrics
                                                              views:viewsDictionary]];
    [self addConstraints:constraints];
}

- (void) addConstrainsForScrollView {
    NSArray *keys = [NSArray arrayWithObjects:@"_pencilButton",@"_markerPenButton",@"_colorBrushButton",@"_crayonButton",@"_bucketButton",@"_shapeboxButton",@"_eyedropperButton",@"_canvasButton",@"_clipButton",nil];
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_pencilButton,_markerPenButton,_colorBrushButton,_crayonButton,_bucketButton,_shapeboxButton,_eyedropperButton,_canvasButton,_clipButton);
    NSDictionary *metrics = @{@"hPadding" :@7,@"vPadding" :@5,@"vHeight":@98,@"vWidth":@73};
    NSArray *constraints = [[NSArray alloc]init];
    NSString *lastCmpObj = @"|";
    
    NSString *vfString1, *vfString2;
    NSString *key;
    for(key in keys){
        const char* cLastStr = [lastCmpObj UTF8String];
        const char *cBtnName = [key UTF8String];
        UIButton *btn = (UIButton*)viewsDictionary[key];
    
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        
        if ([lastCmpObj isEqualToString:@"|"]) {
            vfString1 = [NSString stringWithFormat: @"H:|-hPadding-[%s(vWidth)]",cBtnName];
        }
        else {
            vfString1 = [NSString stringWithFormat: @"H:[%s]-hPadding-[%s(vWidth)]",cLastStr,cBtnName];
        }
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint
                                                                 constraintsWithVisualFormat:vfString1
                                                                 options:0
                                                                 metrics:metrics
                                                                 views:viewsDictionary]];
        
        vfString2 = [NSString stringWithFormat:@"V:|-vPadding-[%s(vHeight)]|",cBtnName];
        constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint
                                                                 constraintsWithVisualFormat:vfString2
                                                                 options:0
                                                                 metrics:metrics
                                                                 views:viewsDictionary]];
        
        lastCmpObj = (NSString*)key;
        
//        NSLog(@"%@\n%@\n\n",vfString1,vfString2);
        
    };
    
    // add last horizonal constraints
    vfString1 = [NSString stringWithFormat: @"H:[%s]-hPadding-|",[lastCmpObj UTF8String]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint
                                                              constraintsWithVisualFormat:vfString1
                                                              options:0
                                                              metrics:metrics
                                                              views:viewsDictionary]];
    
//    NSLog(@"%@\n",vfString1);
    
    [self.toolsScrollView addConstraints:constraints];
}

- (void) setFrameForScrollButtons {
    
}

#pragma mark - Actions

- (void)tapButton:(UIButton*)sender{
    /// set it as current button, if it is a dynamic one
    if(sender.tag > FIXED_BTN_SEPERATOR)    self.currentButton = sender;
    [self.delegate bottomBarView:self forButtonAction:sender];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
