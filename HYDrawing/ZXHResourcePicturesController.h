//
//  ZXHResourcePicturesController.h
//  HYDrawing
//
//  Created by zhuxuhong on 16/4/11.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXHResourceContentController.h"

@protocol ResourceImageSelectDelegate <NSObject>

-(void)didSelectImage: (UIImage*)image;

@end


@interface ZXHResourcePicturesController : UIViewController<ImageSelectDelegate>

@property(nonatomic, weak)id delegate;

@end
