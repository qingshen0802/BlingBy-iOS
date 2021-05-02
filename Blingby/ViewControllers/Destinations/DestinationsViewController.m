//
//  DestinationsCollectionViewController.m
//  Blingby
//
//  Created by Simon Weingand on 12/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "DestinationsViewController.h"
#import "MediaManager.h"
#import "DestinationCollectionViewCell.h"
#import "LoadingCollectionViewCell.h"
#import "DestinationDetailsViewController.h"

#define kReuseCollectionViewCellIdentifier  @"DestinationCollectionViewCell"

@interface DestinationsViewController ()

@end

@implementation DestinationsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationViewController setNavRoot:YES];
    [self.navigationViewController setNavTitle:@"Destinations"];
    
    [self.collectionView registerClass:[DestinationCollectionViewCell class] forCellWithReuseIdentifier:kReuseCollectionViewCellIdentifier];
    [self.collectionView registerClass:[LoadingCollectionViewCell class] forCellWithReuseIdentifier:kReuseLoadingIdentifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self loadMoreData];
}

#pragma mark - Load Destinations

- (void) loadMoreData {
    if ( isLoaded ) {
        isLoaded = NO;
        MediaManager *mediaManager = [MediaManager sharedManager];
        [mediaManager getDestinations:[NSNumber numberWithInt:pageNumber] itemsPerPage:[NSNumber numberWithInt:kItemsPerPage] callback:^(NSArray *resultArray, NSError *error) {
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
                    [self loadFromCoreData:kCoreDataEntityDestination idName:@"destinationId"];
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
        DestinationCollectionViewCell *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier:kReuseCollectionViewCellIdentifier forIndexPath:indexPath];
        [cell setDestination:[self datas][row] cellWidth:[BaseCollectionViewController getCellSize].width];
        return cell;
    }
    else {
        LoadingCollectionViewCell *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier:kReuseLoadingIdentifier forIndexPath:indexPath];
        if ( isLoaded ) {
            [self loadMoreData];
        }
        return cell;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void) gotoDetails:(NSIndexPath *)indexPath {
    DestinationDetailsViewController *destinationDetailsViewController = [[DestinationDetailsViewController alloc] init];
    [destinationDetailsViewController setDestination:[self datas][indexPath.row]];
    [self.navigationController pushViewController:destinationDetailsViewController animated:YES];
}

@end
