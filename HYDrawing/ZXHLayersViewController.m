//
//  ZXHLayersViewController.m
//  HYDrawing
//
//  Created by macbook on 15/8/10.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import "ZXHLayersViewController.h"
#import "Macro.h"
#import "LayersCell.h"
#import "HYBrushCore.h"
#import "ZXHEditableTipsView.h"
#import "Actions.h"

NSString *LayersCountChange = @"LayersCountChange";
NSString *LayersOperation = @"LayersOperation";

@interface ZXHLayersViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>


@end

@implementation ZXHLayersViewController
{
    
    UISlider *_alphaSlider;
    UILabel *_alphaLabel;
    NSInteger _curLayerIndex;
    ZXHEditableTipsView *_tipsView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.layersCount = [[HYBrushCore sharedInstance]getLayersNumber];
    [_tbView reloadData];
    
    _curLayerIndex = [[HYBrushCore sharedInstance] getActiveLayerIndex];
    [self selectRowAtIndexPath:_curLayerIndex];
}

#pragma mark 不可见、锁定提示
-(void)showEditableTipsView{
    if (!_tipsView) {
        _tipsView = [[ZXHEditableTipsView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:_tipsView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 层数
    self.layersCount = [[HYBrushCore sharedInstance]getLayersNumber];
    
    // 初始化UI
    [self createUI];
    
    // 是否可以继续创建层
    // 观察者
    [self addObserver:self forKeyPath:@"layersCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(layersCountChanged:) name:LayersCountChange object:nil];
}

- (void) layersCountChanged:(NSNotification*)notification
{
    self.layersCount = [[HYBrushCore sharedInstance]getLayersNumber];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark 观察者
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"layersCount"]) {
        [self canContinueCreateLayer];
    }
}

#pragma mark UI
-(void)createUI{
    UIImage *bgImg = [UIImage imageNamed:@"layers_popover_bg"];
    CGFloat w = bgImg.size.width;
    CGFloat h = bgImg.size.height-20;
    
    // 1.topToolBar
    [self buildTopToolBar];
    
    // 2.tableView
    [self buildTableViewWithWidth:w height:h];
    
    // 3.bottomToolBar
    [self buildBottomToolBarWithWidth:w height:h];

}

#pragma mark 图层操作

// 删除
-(void)deleteLayer:(UIButton*)btn{
    if (self.layersCount == 1) {
        LayersCell *cell = (LayersCell *)[_tbView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        // 清除画布
        cell.imgView.image = nil;
        [[HYBrushCore sharedInstance]clearLayer:0];
        return;
    }
    
    Actions *action = [Actions createDeletingLayerAction:_curLayerIndex];
    NSDictionary *info = @{@"Action":action};
    [[NSNotificationCenter defaultCenter]postNotificationName:LayersOperation object:nil userInfo:info];
    
    // 选中下一行
    if (_curLayerIndex == self.layersCount-1) {
        _curLayerIndex --;
        if (_curLayerIndex < 0) {
            return;
        }
    }
    
    // 删除选中行
    [[HYBrushCore sharedInstance] deleteActiveLayer];
    self.layersCount = [[HYBrushCore sharedInstance]getLayersNumber];
    
    NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:_curLayerIndex inSection:0];
    [_tbView deleteRowsAtIndexPaths:@[curIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [_tbView reloadData];
    
    [self selectRowAtIndexPath:_curLayerIndex];
}

// 是否按钮可用
-(BOOL)canContinueCreateLayer{
    if (self.layersCount == 10) {
        _topToolBar.btnCopy.enabled = NO;
        _topToolBar.btnAdd.enabled = NO;
        return NO;
    }else{
        _topToolBar.btnCopy.enabled = YES;
        _topToolBar.btnAdd.enabled = YES;
        return YES;
    }
    return YES;
}

// 拷贝
-(void)copyLayer:(UIButton*)btn{
    if ([self canContinueCreateLayer]) {
        // 复制图层
        [[HYBrushCore sharedInstance] duplicateActiveLayer];
        [self createNewLayer];
        
        Actions *action = [Actions createDuplicatingLayerAction:_curLayerIndex];
        NSDictionary *info = @{@"Action":action};
        [[NSNotificationCenter defaultCenter]postNotificationName:LayersOperation object:nil userInfo:info];
    }
}

-(void)createNewLayer{
    self.layersCount = [[HYBrushCore sharedInstance]getLayersNumber];
    
    // 插入行
    NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:_curLayerIndex inSection:0];
    [_tbView insertRowsAtIndexPaths:@[curIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    NSMutableArray *arr = [NSMutableArray new];
    for (NSInteger i=0; i<_curLayerIndex; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        [arr addObject:index];
    }
    
    [_tbView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];

    [_tbView reloadData];
    
    // 选中
    [self selectRowAtIndexPath:_curLayerIndex];
}

// 添加
-(void)addLayer:(UIButton*)btn{
    if ([self canContinueCreateLayer]) {
        // 添加图层
        [[HYBrushCore sharedInstance] addNewLayer];
        [self createNewLayer];
        
        Actions *action = [Actions createAddingLayerAction:_curLayerIndex];
        NSDictionary *info = @{@"Action":action};
        [[NSNotificationCenter defaultCenter]postNotificationName:LayersOperation object:nil userInfo:info];
    }
}


// ++++ 选中某行并设置样式
-(void)selectRowAtIndexPath:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tbView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    // 设置样式
    LayersCell *cell = (LayersCell *)[_tbView cellForRowAtIndexPath:indexPath];
    [cell setOutlineViewBorderWithColor:kBackgroundColor];
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"layer_cell_selected_bg"]];
    
    // 是否可编辑
    BOOL locked = [[HYBrushCore sharedInstance]isLockedofLayer:index];
    if (locked) {
        _topToolBar.btnDelete.enabled = NO;
    }else{
        _topToolBar.btnDelete.enabled = YES;
    }
    
    // 设置选中层
    [[HYBrushCore sharedInstance] setActiveLayer:cell.rowIndex];
//    NSLog(@"getActiveLayer: %ld",[[HYBrushCore sharedInstance] getActiveLayerIndex]);
    
    // 层数
    self.layersCount = [[HYBrushCore sharedInstance] getLayersNumber];
    
    cell.outlineView.backgroundColor = kImageColor(@"layer_showimg_bg");
    
    // 设置透明数值
    [self setLayerAlphaInfo:[[HYBrushCore sharedInstance] getOpacityOfLayer:_curLayerIndex]];
}

#pragma mark 透明度属性
-(void)setLayerAlphaInfo:(CGFloat)value{
    _alphaSlider.value = value;
    
    value *= 100;
    _alphaLabel.text = [NSString stringWithFormat:@"%ld%%",(NSInteger)value];
}

#pragma mark - 创建顶部工具栏
-(void)buildTopToolBar{
    _topToolBar = [[NSBundle mainBundle]loadNibNamed:@"ZXHLayerTopBar" owner:self options:nil][0];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 215, 44)];
    
    [self.view addSubview:bgView];
    [bgView addSubview:_topToolBar];
    
    [_topToolBar.btnDelete addTarget:self action:@selector(deleteLayer:) forControlEvents:UIControlEventTouchUpInside];
    [_topToolBar.btnCopy addTarget:self action:@selector(copyLayer:) forControlEvents:UIControlEventTouchUpInside];
    [_topToolBar.btnAdd addTarget:self action:@selector(addLayer:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 创建表格
-(void)buildTableViewWithWidth:(CGFloat)w height:(CGFloat)h{
    _tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, w, h-104)];
    _tbView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tbView];
    _tbView.dataSource = self;
    _tbView.delegate = self;
    _tbView.rowHeight = 124;
    [_tbView registerNib:[UINib nibWithNibName:@"LayersCell" bundle:nil] forCellReuseIdentifier:@"LayersCellId"];
    _tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 可编辑状态
    _tbView.editing = YES;
    _tbView.allowsSelectionDuringEditing = YES;
}

#pragma mark - 创建底部工具栏
-(void)buildBottomToolBarWithWidth:(CGFloat)w height:(CGFloat)h{
    UIView *bottomToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, h-62, w,44)];
    bottomToolBar.backgroundColor = kBarColor;
    [self.view addSubview:bottomToolBar];
    
    // 滑动条
    _alphaSlider = [[UISlider alloc]initWithFrame:CGRectMake(10, (44-10)/2, w-70, 10)];
    _alphaSlider.minimumValue = 0.0;
    _alphaSlider.maximumValue = 1.0;
    _alphaSlider.layer.cornerRadius = 4;
    _alphaSlider.backgroundColor = kImageColor(@"slider_layer_track_bg");
    _alphaSlider.minimumTrackTintColor = [UIColor clearColor];
    _alphaSlider.maximumTrackTintColor = [UIColor clearColor];
    [_alphaSlider setThumbImage:kImage(@"slider_layer_thumb_bg") forState:0];
    
    [_alphaSlider addTarget:self action:@selector(changeLayerAlpha:) forControlEvents:UIControlEventValueChanged];
    [bottomToolBar addSubview:_alphaSlider];
    
    // 数值文本
    _alphaLabel = [[UILabel alloc]initWithFrame:CGRectMake(_alphaSlider.bounds.size.width+20, (44-20)/2, 50, 20)];
    _alphaLabel.font = kFontSize(14);
    _alphaLabel.textColor = kBorderColor;
    [bottomToolBar addSubview:_alphaLabel];
    
    [self setLayerAlphaInfo:[[HYBrushCore sharedInstance]getOpacityOfLayer:_curLayerIndex]];
}
// 返回当前cell
-(LayersCell*)cellAtIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    LayersCell *cell = (LayersCell*)[_tbView cellForRowAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - 改变图层透明度
-(void)changeLayerAlpha:(UISlider*)slider{
    [self setLayerAlphaInfo:slider.value];
   
    // 设置图层透明度
    [[HYBrushCore sharedInstance] setActiveLayerOpacity:slider.value];
    
    LayersCell *cell = [self cellAtIndex:_curLayerIndex];
    cell.imgView.alpha = slider.value;
}

#pragma mark 表格视图回调
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _layersCount;
}

#pragma mark - 复用
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LayersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LayersCellId"];
    cell.rowIndex = indexPath.row;
    cell.positionLabel.text = [NSString stringWithFormat:@"%ld",self.layersCount-cell.rowIndex];
    
    // 设置锁定、显示图片
    [self setLayerVisibleAndLockingOfCell:cell];
    
    UIImage *layerImage = [[HYBrushCore sharedInstance] getLayerThumbnailOfIndex:indexPath.row];
    cell.imgView.image = layerImage;
    
    if (!cell.selected) {
        [cell setOutlineViewBorderWithColor:kCommenCyanColor];
    }else{
        [cell setOutlineViewBorderWithColor:kBackgroundColor];
    }
    
    // 获取某层的透明度 -- getOpacityOfLayer:
    cell.imgView.alpha = [[HYBrushCore sharedInstance]getOpacityOfLayer:cell.rowIndex];
    
    return cell;
}

// 设置锁定和选中
-(void)setLayerVisibleAndLockingOfCell:(LayersCell*)cell{
    // 设置图层的锁定,显示
    cell.changeLocked = ^(BOOL locked,NSInteger index){
        
        if (locked && index==_curLayerIndex) {
            // 锁了
            _topToolBar.btnDelete.enabled = NO;
        }else{
            _topToolBar.btnDelete.enabled = YES;
        }
        
        // 锁定图层
        [[HYBrushCore sharedInstance]setLocked:locked ofLayer:index];
    };
    
    cell.changeVisible = ^(BOOL visible,NSInteger index){
        
        if (!visible && index==_curLayerIndex) {
            // 不可见
        }else{
            
        }
        
        [[HYBrushCore sharedInstance]setVisibility:visible ofLayer:index];
    };
    
    BOOL visible = [[HYBrushCore sharedInstance]isVisibleOfLayer:cell.rowIndex];
    BOOL locked = [[HYBrushCore sharedInstance]isLockedofLayer:cell.rowIndex];
    cell.isVisible = visible;
    cell.isLocked = locked;
    
    if (!visible) {
        [cell.btnVisible setImage:[UIImage imageNamed:@"layer_invisible"] forState:0];
    }else{
        [cell.btnVisible setImage:[UIImage imageNamed:@"layer_visible"] forState:0];
    }
    
    if (locked) {
        [cell.btnUnlock setImage:[UIImage imageNamed:@"layer_lock"] forState:0];
    }else{
        [cell.btnUnlock setImage:[UIImage imageNamed:@"layer_unlock"] forState:0];
    }
}

// 选中cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _curLayerIndex = indexPath.row;
    
    [self selectRowAtIndexPath:indexPath.row];
}

// 取消选中时
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    LayersCell *cell = (LayersCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setOutlineViewBorderWithColor:kCommenCyanColor];
}

// 编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

// 可以拖动cell
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    LayersCell *cell1 = (LayersCell *)[tableView cellForRowAtIndexPath:sourceIndexPath];
    LayersCell *cell2 = (LayersCell *)[tableView cellForRowAtIndexPath:destinationIndexPath];
    
    NSLog(@"after: %ld",destinationIndexPath.row);
    NSInteger fromRow = sourceIndexPath.row;
    NSInteger toRow = destinationIndexPath.row;
    
    cell1.rowIndex = toRow;
    cell2.rowIndex = fromRow;
    // 改变数据源内容
    [[HYBrushCore sharedInstance]moveLayerFrom:fromRow to:toRow];
    
    [_tbView reloadData];
    if (cell1.selected) {
        [self selectRowAtIndexPath:toRow];
    }else{
        [self selectRowAtIndexPath:_curLayerIndex];
    }
}
@end
