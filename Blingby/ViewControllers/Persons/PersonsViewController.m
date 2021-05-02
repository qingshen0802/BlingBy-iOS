//
//  ContentViewController.m
//  Blingby
//
//  Created by Simon Weingand on 11/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "PersonsViewController.h"
#import "MediaManager.h"
#import "PersonCollectionViewCell.h"
#import "LoadingCollectionViewCell.h"
#import "PersonDetailsViewController.h"

#define kReuseCollectionViewCellIdentifier  @"PersonCollectionViewCell"

@interface PersonsViewController ()

@end

@implementation PersonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationViewController setNavRoot:YES];
    [self.navigationViewController setNavTitle:@"Persons"];
    
    [self.collectionView registerClass:[PersonCollectionViewCell class] forCellWithReuseIdentifier:kReuseCollectionViewCellIdentifier];
    [self.collectionView registerClass:[LoadingCollectionViewCell class] forCellWithReuseIdentifier:kReuseLoadingIdentifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self loadMoreData];
}

#pragma mark - Load Persons

- (void) loadMoreData {
    if ( isLoaded ) {
        isLoaded = NO;
        MediaManager *mediaManager = [MediaManager sharedManager];
        [mediaManager getPersons:[NSNumber numberWithInt:pageNumber] itemsPerPage:[NSNumber numberWithInt:kItemsPerPage] callback:^(NSArray *resultArray, NSError *error) {
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
                    [self loadFromCoreData:kCoreDataEntityPerson idName:@"personId"];
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
        PersonCollectionViewCell *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier:kReuseCollectionViewCellIdentifier forIndexPath:indexPath];
        [cell setPerson:[self datas][row] cellWidth:[BaseCollectionViewController getCellSize].width];
        return cell;
    }
    else {
        UICollectionViewCell *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier:kReuseLoadingIdentifier forIndexPath:indexPath];
        if ( isLoaded ) {
            [self loadMoreData];
        }
        return cell;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void) gotoDetails:(NSIndexPath *)indexPath {
    PersonDetailsViewController *dpersonDetailsViewController = [[PersonDetailsViewController alloc] init];
    [dpersonDetailsViewController setPerson:[self datas][indexPath.row]];
    [self.navigationController pushViewController:dpersonDetailsViewController animated:YES];
}

@end
