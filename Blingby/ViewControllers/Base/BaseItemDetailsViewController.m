    //
//  BaseItemDetailsViewController.m
//  Blingby
//
//  Created by Simon Weingand on 02/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseItemDetailsViewController.h"
#import "Item.h"
#import "ProductPopupViewController.h"
#import "LoadingCollectionViewCell.h"

@interface BaseItemDetailsViewController ()

@property (nonatomic, strong) NSMutableArray *itemDatas;
@property (nonatomic, assign) NSInteger itemCount;

@end

@implementation BaseItemDetailsViewController

- (void)setupViews:(CGRect)frame {
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor clearColor];
    
    _itemCount = 1;
    
    MosaicLayout *layout = [[MosaicLayout alloc] init];
    [layout setDelegate:self];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[LoadingCollectionViewCell class] forCellWithReuseIdentifier:kReuseLoadingIdentifier];
    
    [self.view addSubview:self.collectionView];
}

- (void) loadItems {
    
}

- (void) initItemDatas:(NSArray*)itemsArray {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Do background work
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *results = [itemsArray sortedArrayUsingSelector:@selector(compare:)];
            if ( self.items ) {
                [self.items removeAllObjects];
            }
            else {
                self.items = [[NSMutableArray alloc] init];
            }
            if ( _itemDatas ) {
                [_itemDatas removeAllObjects];
            }
            else {
                _itemDatas = [[NSMutableArray alloc] init];
            }
            _itemCount = [results count];
            if ( [self collectionView] ) {
                [[self collectionView] reloadData];
            }
            for ( Item *item in results ) {
                ItemData *itemData = [[ItemData alloc] init];
                itemData.delegate = self;
                [_itemDatas addObject:itemData];
                [itemData setItem:item];
            }
        });
    });
}

#pragma mark - ItemDataDelegate

- (void)addItemData:(ItemData *)itemData {
    if ( itemData && itemData.item ) {
        [[self items] addObject:itemData];
        if ( [self collectionView] ) {
            [[self collectionView] reloadData];
        }
        if ( _itemDatas && [_itemDatas containsObject:itemData] ) {
            [_itemDatas removeObject:itemData];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    if ( [[self items] count] < _itemCount ) {
        return [[self items] count] + 1;
    }
    else {
        return [[self items] count];
    }
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row == [[self items] count] && _itemCount > [[self items] count] ) {
        UICollectionViewCell *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier:kReuseLoadingIdentifier forIndexPath:indexPath];
        
        return cell;
    }
    else {
        return [self getCollectionViewCell:indexPath];
    }
}

- (UICollectionViewCell*) getCollectionViewCell:(NSIndexPath *) indexPath {
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row == [[self items] count] && _itemCount > [[self items] count] ) {
        
    }
    else if ( indexPath.row < [[self items] count] ) {
        Item *item = [self getItem:indexPath];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationProductDetialsOpened object:item];
        [self showProductDetails:item];
    }
}

- (id) getItem:(NSIndexPath *) indexPath {
    return ((ItemData*)[self items][indexPath.row]).item;
}

- (void) showProductDetails:(Item*)item {
//    if ( item ) {
//        ProductPopupViewController *productPopupViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductPopupViewController"];
//        [productPopupViewController showProductDetails:self.parentViewController item:item];
//    }
}

#pragma mark - MosaicLayoutDelegate

-(float)collectionView:(UICollectionView *)collectionView relativeHeightForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self getRelativeHeight:indexPath];
}

- (float) getRelativeHeight:(NSIndexPath *) indexPath {
    if ( indexPath.row == [[self items] count] && _itemCount > [[self items] count] ) {
        return 1;
    }
    else {
        return ((ItemData*)[self items][indexPath.row]).relativeHeight;
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView isDoubleColumnAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(NSUInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView{
    return kItemCellCountPerRow;
}


@end
