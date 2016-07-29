//
//  ZXHResourceListController.m
//  HYDrawing
//
//  Created by zhuxuhong on 16/4/11.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import "ZXHResourceListController.h"

@interface ResourceListCell : UITableViewCell
@end

@implementation ResourceListCell

-(void)awakeFromNib{
	self.textLabel.textColor = [UIColor colorWithRed:106/255.0 green:106/255.0 blue:106/255.0 alpha:1];
	self.backgroundColor = [UIColor colorWithRed:254/255.0 green:251/255.0 blue:234/255.0 alpha:1];
}

-(void)setSelected:(BOOL)selected{
	if (selected) {
		self.textLabel.textColor = [UIColor whiteColor];
		
		UIView *bgView = [UIView new];
		bgView.backgroundColor = [UIColor colorWithRed:242/255.0 green:177/255.0 blue:74/255.0 alpha:1];
		self.selectedBackgroundView = bgView;
	}
}
@end


@implementation ZXHResourceListController
{
	NSIndexPath *_lastSelectedIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//hide seperator line
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//	NSLog(@"frame: %@", NSStringFromCGSize(self.preferredContentSize));
	
	_lastSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	
	[self.tableView setExclusiveTouch:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	ResourceListModel *model = (ResourceListModel*)_dataSource[section];
	if (model.isOn) {
		return model.chapts.count;
	}
	return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResourceListCell" forIndexPath:indexPath];
	NSArray *chapts = ((ResourceListModel*)_dataSource[indexPath.section]).chapts;
	NSDictionary *chapter = chapts[indexPath.row];
	
	cell.textLabel.text = chapter[@"name"];
	
	
	// 注意!!! selectedBackgroundView 非 backgroundColor
	if (_lastSelectedIndexPath == indexPath) {
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.backgroundColor = [UIColor colorWithRed:242/255.0 green:177/255.0 blue:74/255.0 alpha:1];
		[tableView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
	}else{
		cell.textLabel.textColor = [UIColor colorWithRed:106/255.0 green:106/255.0 blue:106/255.0 alpha:1];
		cell.backgroundColor = [UIColor whiteColor];
	}
	
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	CGFloat sectionHeight = 50;
	CGFloat paddingLeft = 15;
	CGFloat viewWidth = self.preferredContentSize.width;
	ResourceListModel *model = (ResourceListModel*)_dataSource[section];
	
	UIView *view = [UIView new];
	view.backgroundColor = [UIColor colorWithRed:254/255.0 green:251/255.0 blue:234/255.0 alpha:1];
	
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(paddingLeft, 0, 200, sectionHeight)];
	label.text = model.grade;
	[view addSubview:label];
	
	// border-bottom
	UIView *borderViewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 49, 320, 1)];
	borderViewBottom.backgroundColor = [UIColor colorWithRed:214/255.0 green:202/255.0 blue:126/255.0 alpha:1];
	[view addSubview:borderViewBottom];
	view.tag = section+1000;
	
	//tap 手势
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openOrCloseSection:)];
	[view addGestureRecognizer:tap];
	
	// arrow icon
	CGFloat x = viewWidth - 14 - paddingLeft;
	UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(x, sectionHeight/2-4, 14, 8)];
	
	if (model.isOn) {
		icon.image = [UIImage imageNamed:@"res_icon_arrow_up"];
	}else{
		icon.image = [UIImage imageNamed:@"res_icon_arrow_down"];
	}
	[view addSubview:icon];
	
	return  view;
}

// 卷展
-(void)openOrCloseSection: (UITapGestureRecognizer*)tap{
	NSInteger section = tap.view.tag - 1000;
	ResourceListModel *model = (ResourceListModel*)_dataSource[section];
	model.isOn = !model.isOn;
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

// 选中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (_lastSelectedIndexPath != indexPath) {
		
		// 切换数据
		[self changePictures:indexPath];
		
		_lastSelectedIndexPath = indexPath;
		[self.tableView reloadData];
	}
}


-(void)changePictures: (NSIndexPath*)indexPath{
	NSArray *chapts = ((ResourceListModel*)_dataSource[indexPath.section]).chapts;
	NSDictionary *chapter = chapts[indexPath.row];
	[self.delegate changePictures: chapter[@"images"] title: chapter[@"name"]];
}



@end
