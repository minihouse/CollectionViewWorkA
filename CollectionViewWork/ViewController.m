//
// ViewController.m
// CollectionViewWork
//
// Created by 小屋敷 圭史 on 2015/01/24.
// Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "CollectionSectionHeaderView.h"

const float ItemSpaceLength = 10.0;

@interface ViewController ()

@property (nonatomic, strong) NSArray *photoData;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // 写真データ読み込み
    self.photoData = [self loadPhotoData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

// Data.plistのロード
- (NSArray *)loadPhotoData
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Data" ofType:@"plist"];

    return [[NSArray alloc] initWithContentsOfFile:path];
}

#pragma mark - collection view deleagete

#pragma mark - collection view dataSource

// セクション数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.photoData count];
}

// セクション内のセル数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *photos = self.photoData[section][@"photos"];

    return [photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell;

    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *photoName = self.photoData[indexPath.section][@"photos"][indexPath.row];

    cell.imageView.image = [UIImage imageNamed:photoName];

    return cell;
}

// ヘッダー・フッターの設定
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;

    if(kind == UICollectionElementKindSectionHeader) {
        CollectionSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];

        NSString *title = self.photoData[indexPath.section][@"title"];

        headerView.titleLabel.text = title;
        reusableview = headerView;
    }

    return reusableview;
}

#pragma mark - flow layout delegate
// - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
// {
// NSDictionary *sectionData = self.photoData[indexPath.section];
//
// NSNumber *columnCount = sectionData[@"column"];
// NSNumber *photoWidth = sectionData[@"width"];
// NSNumber *photoHeight = sectionData[@"height"];
//
// float frameWidth = CGRectGetWidth(collectionView.frame);
// int spaceCount = [columnCount intValue] + 1;
// float itemWidth = (frameWidth - ItemSpaceLength * spaceCount) / [columnCount intValue];
// float itemHeight = itemWidth / [photoWidth intValue] * [photoHeight intValue];
//
// return CGSizeMake(itemWidth, itemHeight);
// }

@end