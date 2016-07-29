//
//  ZXHPaintingListController.m
//  HYDrawing
//
//  Created by macbook on 15/8/24.
//  Copyright (c) 2015年 Founder. All rights reserved.
//

#import "ZXHPaintingListController.h"
#import "Macro.h"
#import "ZXHPaintingListCell.h"
#import "HYBrushCore.h"
#import "PaintingNameManager.h"

@interface ZXHPaintingListController ()<UITableViewDataSource,UITableViewDelegate,PaintingListCellDelegate>

@property (nonatomic, strong) NSString* defaultFileName;

@end

@implementation ZXHPaintingListController
{
    UIButton *editButton;
    UIButton *addButton;
    UITableView *tbView;
    CGSize preferredSize;
    BOOL isListEditing;
    NSInteger currentSelectedIndex;
    NSArray *paintingNames;
    NSMutableDictionary *thumbnailsMap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    preferredSize = self.preferredContentSize;
    isListEditing = NO;
    
    [self createUI];
    
    paintingNames = [[PaintingNameManager sharedInstance] allNames];
    NSString *activeName = [HYBrushCore sharedInstance].activePaintingName;
    currentSelectedIndex = [paintingNames indexOfObject:activeName];
    thumbnailsMap = [[NSMutableDictionary alloc]init];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSelectedIndex inSection:0];
    [tbView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark UI
-(void)createUI{
    // 编辑按钮
    UIImage *img = kImage(@"list_btn_edit_normal");
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(preferredSize.width-40-10, 8+42/2-40/2, 40, 40);
    [editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setImage:img forState:UIControlStateNormal];
    [self.view addSubview:editButton];
    
    // 添加按钮
    UIImage *image = kImage(@"layer_topbar_btnadd");
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:image forState:UIControlStateNormal];
    [addButton setFrame:CGRectMake(10,8+42/2-40/2, 40, 40)];
    [addButton addTarget:self action:@selector(addNewPainting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    // 表格
    tbView = [[UITableView alloc]initWithFrame:CGRectMake(2, 55, preferredSize.width-4, preferredSize.height-60)];
    [self.view addSubview:tbView];
    tbView.dataSource = self;
    tbView.delegate = self;
    tbView.rowHeight = 130;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册xib
    [tbView registerNib:[UINib nibWithNibName:@"ZXHPaintingListCell" bundle:nil] forCellReuseIdentifier:@"PaintingListCell"];
    tbView.backgroundColor = [UIColor clearColor];
}

#pragma mark 编辑
-(void)editButtonClicked:(UIButton*)btn{
    if (!isListEditing) {
        [btn setImage:kImage(@"list_btn_edit_selected") forState:0];
        [addButton setHidden:YES];
    }else{
        [btn setImage:kImage(@"list_btn_edit_normal") forState:0];
        [addButton setHidden:NO];
    }
    isListEditing = !isListEditing;
    
    [tbView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSelectedIndex inSection:0];
    [tbView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)addNewPainting: (UIButton*) button {
    NSString *newFilePath = [[PaintingNameManager sharedInstance] newDefaultFilePath];
    if ([[HYBrushCore sharedInstance] createPaintingAt: newFilePath]) {
        [[HYBrushCore sharedInstance]draw];
        [self refreshData];
    }
}

#pragma mark 表格回调
// 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return paintingNames.count;
}

// 复用
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXHPaintingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaintingListCell"];
    cell.delegate = self;
    
    if (!isListEditing) {
        cell.btnDelete.hidden = YES;
        cell.btnRename.hidden = YES;
        cell.imgViewRightCons.constant = 20;
        cell.nameLabelRightCons.constant = 20;
    }else{
        cell.btnDelete.hidden = NO;
        cell.btnRename.hidden = NO;
        cell.imgViewRightCons.constant = 8;
        cell.nameLabelRightCons.constant = 10;
    }
    
    NSString *pName = [paintingNames objectAtIndex:indexPath.row];
    UIImage *image = [thumbnailsMap objectForKey:pName];
    if (!image || currentSelectedIndex == indexPath.row){
        NSString *tPath = [[PaintingNameManager sharedInstance]pathOfDefaultName:pName];
        image = [[HYBrushCore sharedInstance] getThumbnailOfPaintingAt:tPath];
        [thumbnailsMap setObject:image forKey:pName];
    }
    
    cell.imageView.image = image;
    cell.nameLabel.text = pName;
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"list_cell_selectedBg"]];
    cell.cellIdx = indexPath.row;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXHPaintingListCell *cell = (ZXHPaintingListCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setBorderStyleWithColor:kCommenSkinColor];
    
    if (indexPath.row != currentSelectedIndex) {
        currentSelectedIndex = indexPath.row;
        
        NSString *activePaintingPath = [[PaintingNameManager sharedInstance] pathOfDefaultName:[paintingNames objectAtIndex:currentSelectedIndex]];
        
        [self.delegate paintingListController:self loadPaintingFrom:activePaintingPath];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZXHPaintingListCell *cell = (ZXHPaintingListCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setBorderStyleWithColor:kCommenCyanColor];
}


- (void)refreshData
{
    paintingNames = [[PaintingNameManager sharedInstance] allNames];
    
    [tbView reloadData];
    
    NSString *activeName = [HYBrushCore sharedInstance].activePaintingName;
    currentSelectedIndex = [paintingNames indexOfObject:activeName];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentSelectedIndex inSection:0];
    [tbView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)paintingListCellDeleteItem:(ZXHPaintingListCell *)paintingListCell
{
    NSString *activePaintingName = [paintingNames objectAtIndex:paintingListCell.cellIdx];
    NSString *activePaintingPath = [[PaintingNameManager sharedInstance] pathOfDefaultName:activePaintingName];
    [[HYBrushCore sharedInstance] removePaintingAt:activePaintingPath];
    
    if (paintingNames.count == 1) {
        activePaintingPath = [[PaintingNameManager sharedInstance]newDefaultFilePath];
        if (![[HYBrushCore sharedInstance] createPaintingAt:activePaintingPath])
        {
            NSLog(@"create new painting failed!");
            return;
        };
        [self refreshData];
    }
    else {
        NSUInteger index = paintingListCell.cellIdx;
        if (index == paintingNames.count-1)  index--;
        [self refreshData];
        activePaintingName = [paintingNames objectAtIndex:index];
        activePaintingPath = [[PaintingNameManager sharedInstance] pathOfDefaultName:activePaintingName];
        [[HYBrushCore sharedInstance] createPaintingAt:activePaintingPath];
    }
    
    [[HYBrushCore sharedInstance] draw];
    
    // 删除选中行
    NSIndexPath *curIndexPath = [NSIndexPath indexPathForRow:paintingListCell.cellIdx inSection:0];
    [tbView deleteRowsAtIndexPaths:@[curIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [self refreshData];
}

@end
