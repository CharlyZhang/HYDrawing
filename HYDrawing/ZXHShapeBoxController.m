//
//  ZXHShapeBoxController.m
//  HYDrawing
//
//  Created by macbook on 15/8/19.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import "ZXHShapeBoxController.h"
#import "ZXHShapeBoxCell.h"
#import "Macro.h"

#define kBtnWidth [UIImage imageNamed:@"shapebox_btn_img_normal"].size.width
#define kBtnHeight [UIImage imageNamed:@"shapebox_btn_img_normal"].size.height

@interface ZXHShapeBoxController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@end

@implementation ZXHShapeBoxController
{
    NSMutableArray *_pictureData;
    NSMutableArray *_shapeData;
    NSMutableArray *_dataSource;
    UICollectionView *_collectionView;
    CGSize preferSize;
    BOOL isPictureType;
    UIButton *imgBtn;
    UIButton *shapeBtn;
}

-(instancetype)initWithPreferredContentSize:(CGSize)size{
    if (self = [super init]) {
        self.preferredContentSize = size;
        preferSize = size;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isPictureType = YES;
    
    // 数据
    [self initData];
    
    // UI
    [self createUI];
}

#pragma mark 初始数据
-(void)initData{
    _dataSource = [NSMutableArray new];
    _pictureData = [NSMutableArray new];
    _shapeData = [NSMutableArray new];

    for (int j=0; j<3; j++) {
        for (int i=1; i<=8; i++) {
            NSString *name = [NSString stringWithFormat:@"shape%d",i];
            UIImage *img = [UIImage imageNamed:name];
            [_shapeData addObject:img];
        }
    }
    
    for (int j=0; j<3; j++) {
        for (int i=1; i<=8; i++) {
            NSString *name = [NSString stringWithFormat:@"thumb%d",i];
            if (i==1) {
                name = @"thumb1.jpg";
            }
            UIImage *img = [UIImage imageNamed:name];
            [_pictureData addObject:img];
        }
    }
    
    // 默认数据
    [self changeDataSource:imgBtn];
}

#pragma mark 切换数据源
-(void)changeDataSource:(UIButton*)btn{
    [self.view setNeedsDisplay];
    if (btn == imgBtn) {
        self.view.backgroundColor = kImageColor(@"shapebox_img_bg");
        _dataSource = _pictureData;
        imgBtn.userInteractionEnabled = NO;
        shapeBtn.userInteractionEnabled = YES;
    }else{
        self.view.backgroundColor = kImageColor(@"shapebox_shape_bg");
        _dataSource = _shapeData;
        imgBtn.userInteractionEnabled = YES;
        shapeBtn.userInteractionEnabled = NO;
    }
    
    [_collectionView reloadData];
}

#pragma mark 创建UI
-(void)createUI{
    // collectionView
    [self createCollectionView];
    
    // 按钮
    [self createButtons];
}

-(void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(kBtnWidth, 10, preferSize.width-kBtnWidth, preferSize.height-28) collectionViewLayout:flowLayout];
    
    // 注册xib
    [_collectionView registerNib:[UINib nibWithNibName:@"ZXHShapeBoxCell" bundle:nil] forCellWithReuseIdentifier:@"ShapeBoxCell"];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 20;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor clearColor];
}


-(void)createButtons{
    imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imgBtn.frame = CGRectMake(0, 20, kBtnWidth, kBtnHeight);
    [imgBtn setImage:[UIImage imageNamed:@"shapebox_btn_img"] forState:UIControlStateNormal];
    [imgBtn setImage:[UIImage imageNamed:@"shapebox_btn_img"] forState:UIControlStateHighlighted];
    [self.view addSubview:imgBtn];
    [imgBtn addTarget:self action:@selector(changeDataSource:) forControlEvents:UIControlEventTouchDown];
    imgBtn.userInteractionEnabled = NO;
    
    shapeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shapeBtn.frame = CGRectMake(0, 70, kBtnWidth, kBtnHeight);
    [shapeBtn setImage:[UIImage imageNamed:@"shapebox_btn_shape"] forState:UIControlStateNormal];
    [shapeBtn setImage:[UIImage imageNamed:@"shapebox_btn_shape"] forState:UIControlStateHighlighted];
    [self.view addSubview:shapeBtn];
    [shapeBtn addTarget:self action:@selector(changeDataSource:) forControlEvents:UIControlEventTouchDown];
}


#pragma mark collectionView回调
// 个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}

// 大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (imgBtn.userInteractionEnabled) {
        return CGSizeMake(60, 60);
    }else{
        UIImage *img = [UIImage imageNamed:@"canvasBg_item_bg"];
        return CGSizeMake(img.size.width, img.size.height);
    }
}

// 边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

// 复用
-(ZXHShapeBoxCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   ZXHShapeBoxCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShapeBoxCell" forIndexPath:indexPath];
    cell.imgView.image = _dataSource[indexPath.item];
//    cell.backgroundColor = [UIColor redColor];
    cell.clipsToBounds = YES;
    
    if (shapeBtn.userInteractionEnabled) {
        cell.layer.cornerRadius = 4;
//        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"canvasBg_item_bg"]];
        cell.backgroundColor = [UIColor redColor];
    }else if (imgBtn.userInteractionEnabled){
        cell.layer.cornerRadius = 0;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

// 选中
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectedShape:_dataSource[indexPath.item]];
}

@end
