//
//  ZXHCanvasBackgroundController.m
//  HYDrawing
//
//  Created by macbook on 15/8/20.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import "ZXHCanvasBackgroundController.h"
#import "ZXHCanvasBackgroundCell.h"
#import "HYBrushCore.h"

@interface ZXHCanvasBackgroundController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation ZXHCanvasBackgroundController
{
    NSMutableArray *_dataSource;
    CGSize preferSize;
    UICollectionView *_collectionView;
}

-(instancetype)initWithPreferredContentSize:(CGSize)size{
    if (self = [super init]) {
        self.preferredContentSize = size;
        preferSize = size;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 数据
    [self initData];
    
    // UI
    [self createUI];
}

#pragma mark 初始数据
-(void)initData{
    _dataSource = [NSMutableArray new];
    
    for (int j=0; j<3; j++) {
        for (int i=1; i<=8; i++) {
            NSString *name = [NSString stringWithFormat:@"thumb%d.png",i];
            if (i==1) {
                name = @"thumb1.jpg";
            }
            UIImage *img = [UIImage imageNamed:name];
            [_dataSource addObject:img];
        }
    }
}

#pragma mark 创建UI
-(void)createUI{
    // collectionView
    [self createCollectionView];
}

-(void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, preferSize.width, preferSize.height-28) collectionViewLayout:flowLayout];
    
    // 注册xib
    [_collectionView registerNib:[UINib nibWithNibName:@"ZXHCanvasBackgroundCell" bundle:nil] forCellWithReuseIdentifier:@"CanvasBackgroundCell"];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor clearColor];
}


#pragma mark <UICollectionViewDataSource>
// 行数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

// 大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *img = [UIImage imageNamed:@"canvasBg_item_bg"];
    return CGSizeMake(img.size.width, img.size.height);
}

// 边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

// 复用
- (ZXHCanvasBackgroundCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZXHCanvasBackgroundCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CanvasBackgroundCell" forIndexPath:indexPath];
    cell.imgView.image = _dataSource[indexPath.item];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
// 选中item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[HYBrushCore sharedInstance]renderBackgroundInFixedLayer:_dataSource[indexPath.item]];
}

@end
