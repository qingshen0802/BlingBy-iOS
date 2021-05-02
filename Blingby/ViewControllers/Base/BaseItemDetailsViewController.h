//
//  BaseItemDetailsViewController.h
//  Blingby
//
//  Created by Simon Weingand on 02/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosaicLayout.h"
#import "ItemData.h"

@interface BaseItemDetailsViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, MosaicLayoutDelegate, ItemDataDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (strong, nonatomic) UICollectionView *collectionView;

- (void) setupViews:(CGRect)frame;
- (void) loadItems;
- (void) initItemDatas:(NSArray*)itemsArray;
- (UICollectionViewCell*) getCollectionViewCell:(NSIndexPath *) indexPath;

@end
