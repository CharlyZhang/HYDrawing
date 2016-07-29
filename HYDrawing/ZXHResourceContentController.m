//
//  ZXHResourceContentController.m
//  HYDrawing
//
//  Created by zhuxuhong on 16/4/11.
//  Copyright © 2016年 Founder. All rights reserved.
//

#import "ZXHResourceContentController.h"
#import "ZXHResourceListController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "AFNetworking/AFNetworking.h"
#import "HYBrushCore.h"

@implementation ResourcePictureCell

@end

@interface ZXHResourceContentController ()<ResourcePicturesDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnDownloadAll;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ZXHResourceContentController
{
	NSArray *_images;
	NSString *_recordsPath;
	NSMutableDictionary *_queueList;
}

static NSString * const reuseIdentifier = @"ResourcePictureCell";

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_queueList = [NSMutableDictionary new];
	_recordsPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/downloads.plist"];
	if (![[NSFileManager defaultManager]fileExistsAtPath:_recordsPath]) {
		[[NSFileManager defaultManager]createFileAtPath:_recordsPath contents:nil attributes:nil];
		NSLog(@"downloads.plist created");
		[@{} writeToFile:_recordsPath atomically:true];
	}
}


-(void)changePictures:(NSArray *)images title:(NSString *)title{
	_images = images;
	_titleLabel.text = title;
	if (![_queueList valueForKey:title]) {
		NSOperationQueue *queue = [NSOperationQueue new];
		[_queueList setValue:queue forKey:title];
		_btnDownloadAll.enabled = true;
	}
	
	[self checkDownloadAll];
	[_collectionView reloadData];
}

// check download all
-(void)checkDownloadAll{
	_btnDownloadAll.enabled = false;
	NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:_recordsPath];
	for (NSDictionary *d in _images) {
		if (![root valueForKey:d[@"url"]]) {
			_btnDownloadAll.enabled = true;
			break;
		}
	}
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ResourcePictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	[cell.imgView sd_setImageWithURL:_images[indexPath.item][@"url"]];
	[cell.downloadBtn addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
	cell.downloadBtn.tag = 1000+indexPath.item;
	
	if ([self isImageDownload:_images[indexPath.item][@"url"]]) {
		cell.maskView.hidden = true;
//		NSLog(@"%@ downloaded: ",_images[indexPath.item][@"name"]);
	}else{
		cell.maskView.hidden = false;
		cell.downloadBtn.hidden = false;
	}
//	NSLog(@"%ld : %@",indexPath.item, _images[indexPath.item][@"name"]);
	cell.indicator.hidden = true;
	
    return cell;
}

// check cell
-(BOOL)isImageDownload: (NSString*)url{
	NSMutableDictionary *root = [NSMutableDictionary dictionaryWithContentsOfFile:_recordsPath];
	if ([root valueForKey:url]) {
		return YES;
	}
	return NO;
}

//download
- (void)download:(UIButton *)sender {
	NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag-1000 inSection:0];
	[self downloading:indexPath];
}

-(void)downloading: (NSIndexPath*)indexPath{
	NSLog(@"downloading: %ld",indexPath.item);
	ResourcePictureCell *cell = (ResourcePictureCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
	cell.downloadBtn.hidden = true;
	cell.indicator.hidden = false;
	[cell.indicator startAnimating];
	
	[self startDownloadImageWithIndexPath: indexPath];
}

// startDownload
-(void)startDownloadImageWithIndexPath: (NSIndexPath*)indexPath{
	NSURL *URL = [NSURL URLWithString:_images[indexPath.item][@"url"]];
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	
	NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:URL] progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
		NSString *type = [[[response suggestedFilename]componentsSeparatedByString:@"."] lastObject];
		NSString *imgName = [[_images[indexPath.item][@"url"] componentsSeparatedByString:@"file="] lastObject];
		NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
		
		return [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",imgName,type]];
		
	} completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
		if (error) {
			NSLog(@"下载失败: %@",[error description]);
			return;
		}
		NSLog(@"File downloaded to: %@", filePath);
		// 存储下载记录
		[self saveDownloadRecord:indexPath filePath:filePath.relativePath];
		[self.collectionView reloadData];
	}];
	[downloadTask resume];
}

//save records
-(void)saveDownloadRecord: (NSIndexPath*)indexPath filePath: (NSString*)path{
	NSMutableDictionary *root = [NSMutableDictionary dictionaryWithContentsOfFile:_recordsPath];
	[root setValue:@{@"name": _images[indexPath.item][@"name"],
					 @"path": path}
			forKey:_images[indexPath.item][@"url"]];
	[root writeToFile:_recordsPath atomically:true];
}

- (IBAction)downloadAll:(UIButton *)sender {
	sender.enabled = false;
	
	for (int i=0; i<_images.count; i++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
		NSDictionary *dic = _images[indexPath.item];
		NSMutableDictionary *root = [NSMutableDictionary dictionaryWithContentsOfFile:_recordsPath];
		// 没有下载过的
		if (![root valueForKey:dic[@"url"]]) {
			NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
				dispatch_async(dispatch_get_main_queue(), ^{
					[self downloading:indexPath];
				});
			}];
			NSOperationQueue *q = [_queueList valueForKey:_titleLabel.text];
			[q addOperation:op];
		}
	}
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	NSString *url = _images[indexPath.item][@"url"];
	NSDictionary *root = [NSDictionary dictionaryWithContentsOfFile:_recordsPath];
	// 已下载
	if ([root valueForKey:url]) {
		NSDictionary *dic = [root valueForKey:url];
		NSString *path = [dic valueForKey:@"path"];
		UIImage *img = [UIImage imageWithContentsOfFile:path];
		[self.delegate didSelectImage:img];
	}
	
}

@end
