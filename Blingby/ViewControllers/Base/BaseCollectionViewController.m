//
//  BaseCollectionViewController.m
//  Blingby
//
//  Created by Simon Weingand on 02/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseCollectionViewController.h"

@interface BaseCollectionViewController ()

@end

@implementation BaseCollectionViewController

static CGSize cellSize;

+ (CGSize) getCellSize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat cellWidth = (screenSize.width - COLLECTIONVIEW_CELL_SPACE * 2) / kPopularVideoCellCountPerRow - COLLECTIONVIEW_CELL_SPACE / 2;
        CGFloat cellHeight = cellWidth / kVideoRatio;
        cellSize = CGSizeMake(cellWidth, cellHeight);
    });
    
    return cellSize;
}

- (void)loadView {
    [super loadView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumLineSpacing:COLLECTIONVIEW_CELL_SPACE];
    [layout setMinimumInteritemSpacing:0];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];

    self.collectionView.clipsToBounds = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self setupViews:self.collectionView];
    
    [self initDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Medias

- (void) initDatas {
    if ( _datas == nil ) {
        _datas = [[NSMutableArray alloc] init];
        
        isLoaded = YES;
        hasMoreDatas = YES;
        pageNumber = 0;
    }
}

- (void) loadMoreData {

}

- (void) loadFromCoreData:(NSString*)entityName idName:(NSString*)idName {
    CoreDataHandler *coreDataHandler = [[CoreDataHandler alloc] init];
    _datas = [[NSMutableArray alloc] initWithArray:[coreDataHandler getAllDataForEntity:entityName sortField:idName ascending:YES]];
    int count = (int)[_datas count];
    pageNumber = (int)(count / kItemsPerPage);
    if ( count % kItemsPerPage == 0 )
        pageNumber--;
    [_collectionView reloadData];
    isLoaded = YES;
    hasMoreDatas = YES;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [[self datas] count];
    return hasMoreDatas ? count + 1 : count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCollectionViewCell:indexPath];
}

- (UICollectionViewCell*) getCollectionViewCell:(NSIndexPath *) indexPath {
    return nil;
}

- (CGSize) collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [BaseCollectionViewController getCellSize];
}

-(UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self gotoDetails:indexPath];
}

- (void) gotoDetails:(NSIndexPath *)indexPath {
    
}

@end
