//
//  SavedProductCollectionViewController.m
//  Blingby
//
//  Created by Simon Weingand on 27/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "SavedItemsViewController.h"
#import "MediaItemCollectionViewCell.h"
#import "AppManager.h"

#import "Media.h"
#import "Item.h"
#import "ItemData.h"

#define kReuseSavedProductIdentifier @"SavedItemCollectionViewCell"

@interface SavedItemsViewController ()

@end

@implementation SavedItemsViewController

@synthesize items;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadItems) name:kNotificationProductChanged object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadItems];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:kNotificationProductChanged];
}

#pragma mark - Load Items

- (void) loadItems {
    if ( items )
        [items removeAllObjects];
    else
        items = [[NSMutableArray alloc] init];
    
    if ( [self collectionView] ) {
        [[self collectionView] reloadData];
    }
    
    [self initItemDatas:[[AppManager sharedManager] getSavedItems]];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell*) getCollectionViewCell:(NSIndexPath *) indexPath {
    MediaItemCollectionViewCell *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier:kReuseSavedProductIdentifier forIndexPath:indexPath];
    
    if ( indexPath.row < [items count] && items[indexPath.row] && ((ItemData*)items[indexPath.row]).item )
        [cell setItemData:((ItemData*)items[indexPath.row]).item];
    return cell;

}

#pragma mark - MosaicLayoutDelegate

-(NSUInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView{
    return kSavedAndSearchItemCellCountPerRow;
}

@end
