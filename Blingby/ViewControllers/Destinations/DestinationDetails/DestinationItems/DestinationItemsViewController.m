//
//  DestinationItemsViewController.m
//  Blingby
//
//  Created by Simon Weingand on 21/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "DestinationItemsViewController.h"
#import "DestinationItemCollectionViewCell.h"

#import "Destination.h"
#import "Item.h"
#import "SearchResult.h"
#import "MediaManager.h"
#import "AppManager.h"

#define kReuseDestinationItemIdentifier @"DestinationItemCollectionViewCell"

@interface DestinationItemsViewController ()

@end

@implementation DestinationItemsViewController

@synthesize items;

- (void) setupViews:(CGRect)frame {
    [super setupViews:frame];
    [self.collectionView registerClass:[DestinationItemCollectionViewCell class] forCellWithReuseIdentifier:kReuseDestinationItemIdentifier];
}

#pragma mark - Load Destination Items

- (void)setDestination:(Destination*) destination {
    if ( _destination && [_destination.destinationId intValue] == [destination.destinationId  intValue] ) {
        
    }
    else {
        _destination = destination;
        [self loadItems];
    }
}

- (void)setSearchResult:(SearchResult *)searchResult {
    if ( _searchResult && [_searchResult.contentId intValue] == [searchResult.contentId  intValue] ) {
        
    }
    else {
        _searchResult = searchResult;
        [self loadItems];
    }
}

- (void) loadItems {
    if ( _destination ) {
        if ( _destination.destinationItems && [_destination.destinationItems count] > 0 ) {
            [self initItemDatas:[_destination.destinationItems allObjects]];
        }
        else {
            [[MediaManager sharedManager] getDestinationDetails:_destination.destinationId callback:^(id result, NSError *error) {
                if ( result && [result isKindOfClass:[Destination class]] ) {
                    Destination *destination = result;
                    _destination.destinationItems = destination.destinationItems;
                }
                [self initItemDatas:[_destination.destinationItems allObjects]];
            }];
        }
    }
    else if ( _searchResult ) {
        [[MediaManager sharedManager] getDestinationDetails:_searchResult.contentId callback:^(id result, NSError *error) {
            if ( result && [result isKindOfClass:[Destination class]] ) {
                _destination = result;
                AppManager *appManager = [AppManager sharedManager];
                [appManager addRecentDestinations:_destination];
            }
            [self initItemDatas:[_destination.destinationItems allObjects]];
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell*) getCollectionViewCell:(NSIndexPath *) indexPath {
    DestinationItemCollectionViewCell *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier:kReuseDestinationItemIdentifier forIndexPath:indexPath];
    [cell setItemData:((ItemData*)items[indexPath.row]).item];
    return cell;
}

@end
