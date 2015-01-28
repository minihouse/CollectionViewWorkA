//
// CustomCollectionViewLayout.m
// CollectionViewWork
//
// Created by 小屋敷 圭史 on 2015/01/24.
// Copyright (c) 2015年 小屋敷 圭史. All rights reserved.
//

#import "CustomCollectionViewLayout.h"

NSString *const CustomLayoutElementKindSectionTitle = @"CustomLayoutElementKindSectionTitle";

static float TitleTopMargin = 10.0f;
static float TitleRightMargin = 10.0f;
static float TitleWidth = 200.0f;
static float TitleHeight = 50.0f;
static float ItemMargin = 10.0f;

@interface CustomCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *titleFrames;
@property (nonatomic, strong) NSMutableArray *itemFrames;
@property (nonatomic) CGSize contentSize;

@end

@implementation CustomCollectionViewLayout

- (instancetype)init
{
    self = [super init];

    if(self) {
        _titleFrames = [[NSMutableArray alloc] init];
        _itemFrames = [[NSMutableArray alloc] init];
    }

    return self;
}

// レイアウト情報の生成
- (void)prepareLayout
{
    [super prepareLayout];

    // セクション数
    NSInteger numberOfSections = [self.collectionView numberOfSections];

    for(NSInteger section = 0; section < numberOfSections; section++) {
        // ヘッダーのframe作成
        CGRect titleFrame = [self titleFrameAtSection:section];

        [self.titleFrames addObject:[NSValue valueWithCGRect:titleFrame]];

        // itemのframe作成
        NSMutableArray *framesInSection = [NSMutableArray array];

        // item数
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];

        switch(numberOfItems) {
                case 1:
            {
                framesInSection = [self itemFramesForOne];
                break;
            }
                case 2:
            {
                framesInSection = [self itemFramesForTwo];
                break;
            }
                case 3:
            {
                framesInSection = [self itemFramesForThree];
                break;
            }
                case 4:
            {
                framesInSection = [self itemFramesForFour];
                break;
            }
                default:
            {
                break;
            }
        }

        [self.itemFrames addObject:framesInSection];
    }

    // コンテンツサイズの計算
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.frame);
    CGFloat sectionHeight = TitleTopMargin + TitleHeight + collectionViewWidth;

    self.contentSize = CGSizeMake(collectionViewWidth, sectionHeight * numberOfSections);
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

// 範囲内のレイアウト属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributesArray = [NSMutableArray array];

    NSInteger numberOfSections = [self.collectionView numberOfSections];

    for(NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];

        for(NSInteger item = 0; item < numberOfItems; item++) {
            // セルのレイアウト属性
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];

            // rect とitemAttributes のframe が重なりを持つかをチェック
            if(CGRectIntersectsRect(rect, itemAttributes.frame)) {
                [attributesArray addObject:itemAttributes];
            }
        }

        // 補助ビューのレイアウト属性
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *titleAttributes =
            [self layoutAttributesForSupplementaryViewOfKind:CustomLayoutElementKindSectionTitle
                                                 atIndexPath:sectionIndexPath];

        // rect とtitleAttributes のframe が重なりを持つかをチェック
        if(CGRectIntersectsRect(rect, titleAttributes.frame)) {
            [attributesArray addObject:titleAttributes];
        }
    }

    return attributesArray;
}

// セルのレイアウト属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    // prepareForLayout で計算した値を元にattributes.frame を設定する
    NSArray *frames = self.itemFrames[indexPath.section];
    CGRect frame = [frames[indexPath.item] CGRectValue];

    attributes.frame = frame;

    return attributes;
}

// 補助ビューのレイアウト属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];

    if([kind isEqualToString:CustomLayoutElementKindSectionTitle]) {
        // prepareForLayout で計算した値を元にattributes.frame を設定する
        CGRect frame = [self.titleFrames[indexPath.section] CGRectValue];

        attributes.frame = frame;
    }

    return attributes;
}

#pragma mark - private

// タイトル用frame作成
- (CGRect)titleFrameAtSection:(NSInteger)section
{
    CGFloat baseWidth = CGRectGetWidth(self.collectionView.frame);
    CGFloat titleX = baseWidth - TitleWidth - TitleRightMargin;
    CGFloat titleY = TitleTopMargin;
    CGRect titleFrame = CGRectMake(titleX, titleY, TitleWidth, TitleHeight);

    return titleFrame;
}

- (NSMutableArray *)itemFramesAtSection:(NSInteger)section
{
    NSMutableArray *framesInSection = [NSMutableArray array];

    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];

    switch(numberOfItems) {
            case 1:
        {
            framesInSection = [self itemFramesForOne];
            break;
        }
            case 2:
        {
            break;
        }
            default:
        {
            break;
        }
    }

    return framesInSection;
}

- (NSMutableArray *)itemFramesForOne
{
    NSMutableArray *framesInSection = [NSMutableArray array];

    // アイテムの基点
    CGPoint baseItemOrigin = CGPointMake(ItemMargin, TitleTopMargin + TitleHeight + ItemMargin);
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.frame);

    // 1つ目のアイテム
    CGFloat width = collectionViewWidth - ItemMargin * 2;
    CGFloat height = width;
    CGRect item1Frame = CGRectMake(baseItemOrigin.x, baseItemOrigin.y, width, height);

    [framesInSection addObject:[NSValue valueWithCGRect:item1Frame]];

    return framesInSection;
}

- (NSMutableArray *)itemFramesForTwo
{
    NSMutableArray *framesInSection = [NSMutableArray array];

    // アイテムの基点
    CGPoint baseItemOrigin = CGPointMake(ItemMargin, TitleTopMargin + TitleHeight + ItemMargin);
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.frame);

    // 1つ目のアイテム
    CGFloat item1X = baseItemOrigin.x;
    CGFloat item1Y = baseItemOrigin.y;
    CGFloat item1Height = collectionViewWidth - ItemMargin * 2;
    CGFloat item1Width = (collectionViewWidth - ItemMargin * 3) / 2;
    CGRect item1Frame = CGRectMake(item1X, item1Y, item1Width, item1Height);

    [framesInSection addObject:[NSValue valueWithCGRect:item1Frame]];

    // 2つめのアイテム
    CGFloat item2X = baseItemOrigin.x + item1Width + ItemMargin;
    CGFloat item2Y = baseItemOrigin.y;
    CGFloat item2Height = collectionViewWidth - ItemMargin * 2;
    CGFloat item2Width = (collectionViewWidth - ItemMargin * 3) / 2;
    CGRect item2Frame = CGRectMake(item2X, item2Y, item2Width, item2Height);

    [framesInSection addObject:[NSValue valueWithCGRect:item2Frame]];

    return framesInSection;
}

- (NSMutableArray *)itemFramesForThree
{
    NSMutableArray *framesInSection = [NSMutableArray array];

    // アイテムの基点
    CGPoint baseItemOrigin = CGPointMake(ItemMargin, TitleTopMargin + TitleHeight + ItemMargin);
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.frame);

    // 1つ目のアイテム
    CGFloat item1X = baseItemOrigin.x;
    CGFloat item1Y = baseItemOrigin.y;
    CGFloat item1Height = collectionViewWidth - ItemMargin * 2;
    CGFloat item1Width = (collectionViewWidth - ItemMargin * 3) / 2;
    CGRect item1Frame = CGRectMake(item1X, item1Y, item1Width, item1Height);

    [framesInSection addObject:[NSValue valueWithCGRect:item1Frame]];

    // 2つめのアイテム
    CGFloat item2X = baseItemOrigin.x + item1Width + ItemMargin;
    CGFloat item2Y = baseItemOrigin.y;
    CGFloat item2Height = (collectionViewWidth - ItemMargin * 3) / 2;
    CGFloat item2Width = (collectionViewWidth - ItemMargin * 3) / 2;
    CGRect item2Frame = CGRectMake(item2X, item2Y, item2Width, item2Height);

    [framesInSection addObject:[NSValue valueWithCGRect:item2Frame]];

    // 3つめのアイテム
    CGFloat item3X = baseItemOrigin.x + item1Width + ItemMargin;
    CGFloat item3Y = baseItemOrigin.y - item2Height - ItemMargin;
    CGFloat item3Height = (collectionViewWidth - ItemMargin * 3) / 2;
    CGFloat item3Width = (collectionViewWidth - ItemMargin * 3) / 2;
    CGRect item3Frame = CGRectMake(item3X, item3Y, item3Width, item3Height);

    [framesInSection addObject:[NSValue valueWithCGRect:item3Frame]];

    return framesInSection;
}

- (NSMutableArray *)itemFramesForFour
{
    NSMutableArray *framesInSection = [NSMutableArray array];

    // アイテムの基点
    CGPoint baseItemOrigin = CGPointMake(ItemMargin, TitleTopMargin + TitleHeight + ItemMargin);
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.frame);

    // 1つ目のアイテム
    CGFloat item1X = baseItemOrigin.x;
    CGFloat item1Y = baseItemOrigin.y;
    CGFloat item1Height = collectionViewWidth - ItemMargin * 2;
    CGFloat item1Width = (collectionViewWidth - ItemMargin * 3) / 2;
    CGRect item1Frame = CGRectMake(item1X, item1Y, item1Width, item1Height);

    [framesInSection addObject:[NSValue valueWithCGRect:item1Frame]];

    // 2つめのアイテム
    CGFloat item2X = baseItemOrigin.x + item1Width + ItemMargin;
    CGFloat item2Y = baseItemOrigin.y;
    CGFloat item2Height = (collectionViewWidth - ItemMargin * 4) / 3;
    CGFloat item2Width = (collectionViewWidth - ItemMargin * 3) / 2;
    CGRect item2Frame = CGRectMake(item2X, item2Y, item2Width, item2Height);

    [framesInSection addObject:[NSValue valueWithCGRect:item2Frame]];

    // 3つめのアイテム
    CGFloat item3X = baseItemOrigin.x + item1Width + ItemMargin;
    CGFloat item3Y = baseItemOrigin.y - item2Height - ItemMargin;
    CGFloat item3Height = (collectionViewWidth - ItemMargin * 4) / 3;
    CGFloat item3Width = (collectionViewWidth - ItemMargin * 3) / 2;
    CGRect item3Frame = CGRectMake(item3X, item3Y, item3Width, item3Height);

    [framesInSection addObject:[NSValue valueWithCGRect:item3Frame]];

    // 3つめのアイテム
    CGFloat item4X = baseItemOrigin.x + item1Width + ItemMargin;
    CGFloat item4Y = item3Y - item3Height - ItemMargin;
    CGFloat item4Height = (collectionViewWidth - ItemMargin * 4) / 3;
    CGFloat item4Width = (collectionViewWidth - ItemMargin * 3) / 2;
    CGRect item4Frame = CGRectMake(item4X, item4Y, item4Width, item4Height);

    [framesInSection addObject:[NSValue valueWithCGRect:item4Frame]];

    return framesInSection;
}

@end