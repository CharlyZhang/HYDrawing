//
//  ZXHResourceContentController.h
//  HYDrawing
//
//  Created by zhuxuhong on 16/4/11.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ResourcePictureCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@protocol ImageSelectDelegate <NSObject>

-(void)didSelectImage: (UIImage*)image;

@end


@interface ZXHResourceContentController : UIViewController

@property(nonatomic, weak)id delegate;

@end
