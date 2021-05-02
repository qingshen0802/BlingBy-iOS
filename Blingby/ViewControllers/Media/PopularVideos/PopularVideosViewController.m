//
//  PopularVideosViewController.m
//  Blingby
//
//  Created by Simon Weingand on 21/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "PopularVideosViewController.h"
#import "MediaItemsViewController.h"
#import "MediaManager.h"
#import "MediaCollectionViewCell.h"
#import "Media.h"
#import "LoadingCollectionViewCell.h"
#import "MediaDetailsViewController.h"

#define kReuseCollectionViewCellIdentifier  @"MediaCollectionViewCell"

@interface PopularVideosViewController ()

@property (nonatomic, strong) Media *selectedMedia;

@end

@implementation PopularVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationViewController setNavRoot:YES];
    [self.navigationViewController setNavTitle:nil];
    
    [self.collectionView registerClass:[MediaCollectionViewCell class] forCellWithReuseIdentifier:kReuseCollectionViewCellIdentifier];
    [self.collectionView registerClass:[LoadingCollectionViewCell class] forCellWithReuseIdentifier:kReuseLoadingIdentifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self loadMoreData];
}

#pragma mark - Load Medias

- (void) loadMoreData {
    if ( isLoaded ) {
        isLoaded = NO;
        MediaManager *mediaManager = [MediaManager sharedManager];
        [mediaManager getMedias:[NSNumber numberWithInt:pageNumber] itemsPerPage:[NSNumber numberWithInt:kItemsPerPage] callback:^(NSArray *resultArray, NSError *error) {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if ( resultArray ) {
                    if ( [resultArray count] == kItemsPerPage )
                        hasMoreDatas = YES;
                    else
                        hasMoreDatas = NO;
                    
                    [[self datas] addObjectsFromArray:resultArray];
                    pageNumber++;
                    [[self collectionView] reloadData];
                }
                else if ( error ) {
                    hasMoreDatas = NO;
                    [self loadFromCoreData:kCoreDataEntityMedia idName:@"mediaId"];
                }
                isLoaded = YES;
            });
        }];
    }
}


#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell*) getCollectionViewCell:(NSIndexPath *) indexPath {
    int row = (int)indexPath.row;
    if ( row < [[self datas] count] ) {
        MediaCollectionViewCell *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier:kReuseCollectionViewCellIdentifier forIndexPath:indexPath];
        [cell setMedia:[self datas][row] cellWidth:[BaseCollectionViewController getCellSize].width];
        return cell;
    }
    else {
        LoadingCollectionViewCell *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier:kReuseLoadingIdentifier forIndexPath:indexPath];
        if ( isLoaded ) {
            [self loadMoreData];
        }
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void) gotoDetails:(NSIndexPath *)indexPath {
    MediaDetailsViewController *mediaDetailsViewController = [[MediaDetailsViewController alloc] init];
    [mediaDetailsViewController setMedia:[self datas][indexPath.row]];
    [self.navigationController pushViewController:mediaDetailsViewController animated:YES];
}

@end
