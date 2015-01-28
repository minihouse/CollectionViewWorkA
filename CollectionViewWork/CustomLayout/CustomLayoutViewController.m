//
// CustomLayoutViewController.m
// CollectionViewWork
//
// Created by 小屋敷 圭史 on 2015/01/24.
// Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import "CustomLayoutViewController.h"
#import "CollectionViewCell.h"
#import "CollectionSectionHeaderView.h"
#import "CustomLayoutTitleView.h"

@interface CustomLayoutViewController ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation CustomLayoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // データ読み込み
    self.data = [self loadData];

    // 補助ビューのNib ファイルを登録
    UINib *nib = [UINib nibWithNibName:@"CustomLayoutTitleView" bundle:nil];

    [self.collectionView registerNib:nib
          forSupplementaryViewOfKind:CustomLayoutElementKindSectionTitle
                 withReuseIdentifier:@"CustomLayoutTitleView"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

// Data.plistのロード
- (NSArray *)loadData
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"CustomLayoutData" ofType:@"plist"];

    return [[NSArray alloc] initWithContentsOfFile:path];
}

// 文字列からUIColorを生成
- (UIColor *)colorWithName:(NSString *)colorName
{
    if([colorName isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if([colorName isEqualToString:@"yellow"]) {
        return [UIColor yellowColor];
    } else if([colorName isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if([colorName isEqualToString:@"green"]) {
        return [UIColor greenColor];
    }

    return [UIColor whiteColor];
}

#pragma mark - collection view deleagete

#pragma mark - collection view dataSource

// セクション数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.data count];
}

// セクション内のセル数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = [(NSNumber *) self.data[section][@"count"] integerValue];

    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;

    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomLayoutCell" forIndexPath:indexPath];

    NSString *colorName = self.data[indexPath.section][@"color"][indexPath.row];

    cell.backgroundColor = [self colorWithName:colorName];

    return cell;
}

// ヘッダー・フッターの設定
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;

    if(kind == CustomLayoutElementKindSectionTitle) {
        CustomLayoutTitleView *titleView = [collectionView dequeueReusableSupplementaryViewOfKind:CustomLayoutElementKindSectionTitle withReuseIdentifier:@"CustomLayoutTitleView" forIndexPath:indexPath];

        NSNumber *count = self.data[indexPath.section][@"count"];

        titleView.label.text = [NSString stringWithFormat:@"%ldつのパターン", (long) [count integerValue]];
        reusableview = titleView;
    }

    return reusableview;
}

@end