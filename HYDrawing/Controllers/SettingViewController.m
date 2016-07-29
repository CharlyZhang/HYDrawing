//
//  SettingViewController.m
//  HYDrawing
//
//  Created by CharlyZhang on 15/11/27.
//  Copyright © 2015年 Founder. All rights reserved.
//

#import "SettingViewController.h"
#import "Macro.h"

#define CELL_INDENTIFIER    @"SettingTableViewCell"
#define CELL_WIDTH      107.f
#define CELL_HEIGHT     50.f
#define BORDER_WIDTH    2.f
#define CORNER_RADIUS   10.f

#pragma mark - TabelView Cell

@interface TableviewCell : UITableViewCell

@property (nonatomic) BOOL isLastCell;

@end

@implementation TableviewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = kFocusedColor;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.isLastCell)  return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, BORDER_WIDTH);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:145/255.0 green:105/255.0 blue:33/255.0 alpha:1.0f].CGColor);
    CGFloat lengths[] = {5,5};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, 5, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width - 5,rect.size.height);
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

@end

#pragma mark - TabelView

@interface SettingViewController ()
{
    NSArray *itemTitles;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[TableviewCell class] forCellReuseIdentifier:CELL_INDENTIFIER];
    [self.tableView setRowHeight:CELL_HEIGHT];
    [self.tableView setBackgroundColor:kBackgroundColor];
    self.tableView.layer.borderWidth = BORDER_WIDTH;
    self.tableView.layer.borderColor = kBorderColor.CGColor;
    self.tableView.layer.cornerRadius = CORNER_RADIUS;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
	
    itemTitles = [NSArray arrayWithObjects:@"保存绘制",@"清空图层",@"变换图层", nil];
	
	self.preferredContentSize = CGSizeMake(CELL_WIDTH, CELL_HEIGHT*itemTitles.count + BORDER_WIDTH);
	
}


#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itemTitles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_INDENTIFIER forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell) {
        cell = [[TableviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_INDENTIFIER];
    }
    
    cell.textLabel.text = [itemTitles objectAtIndex:indexPath.row];
    cell.isLastCell = (indexPath.row == itemTitles.count - 1);
    
    return cell;
}

#pragma mark Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: // save painting
            [self.delegate settingViewControllerSavePainting:self];
            break;
        case 1: // clear layer
            [self.delegate settingViewControllerClearLayer:self];
            break;
        case 2: // transform layer
            [self.delegate settingViewControllerTransformLayer:self];
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
