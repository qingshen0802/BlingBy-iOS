//
//  BaseCollectionViewController.h
//  Blingby
//
//  Created by Simon Weingand on 02/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseSearchViewController.h"

@interface BaseCollectionViewController : BaseSearchViewController<UICollectionViewDataSource, UICollectionViewDelegate> {
    int pageNumber;
    BOOL isLoaded;
    BOOL hasMoreDatas;
}

@property (nonatomic, strong) NSMutableArray *datas;

@property (strong, nonatomic) UICollectionView *collectionView;

+ (CGSize) getCellSize;

- (void) loadMoreData;
- (void) loadFromCoreData:(NSString*)entityName idName:(NSString*)idName;
- (UICollectionViewCell*) getCollectionViewCell:(NSIndexPath *) indexPath;
- (void) gotoDetails:(NSIndexPath *)indexPath;

@end
