//
//  MediaItemsViewController.m
//  Blingby
//
//  Created by Simon Weingand on 21/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "MediaItemsViewController.h"
#import "MediaItemCollectionViewCell.h"

#import "Media.h"
#import "SearchResult.h"
#import "Item.h"
#import "MediaManager.h"
#import "AppManager.h"

#define kReuseMediaItemIdentifier @"MediaItemCollectionViewCell"

@interface MediaItemsViewController ()

@end

@implementation MediaItemsViewController

@synthesize items;

- (void) setupViews:(CGRect)frame {
    [super setupViews:frame];
    [self.collectionView registerClass:[MediaItemCollectionViewCell class] forCellWithReuseIdentifier:kReuseMediaItemIdentifier];
}

#pragma mark - Load Media Items

- (void)setMedia:(Media *)media {
    if ( _media && [_media.mediaId intValue] == [media.mediaId  intValue] ) {
        
    }
    else {
        _media = media;
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
    if ( _media ) {
        if ( _media.mediaItems && [_media.mediaItems count] > 0 ) {
            [self initItemDatas:[_media.mediaItems allObjects]];
        }
        else {
            [[MediaManager sharedManager] getMediaDetails:_media.mediaId callback:^(id result, NSError *error) {
                if ( result && [result isKindOfClass:[Media class]] ) {
                    Media *media = result;
                    _media.mediaItems = media.mediaItems;
                }
                [self initItemDatas:[_media.mediaItems allObjects]];
            }];
        }
    }
    else if ( _searchResult ) {
        [[MediaManager sharedManager] getMediaDetails:_searchResult.contentId callback:^(id result, NSError *error) {
            if ( result && [result isKindOfClass:[Media class]] ) {
                _media = result;
                AppManager *appManager = [AppManager sharedManager];
                [appManager addRecentMedia:_media];
            }
            [self initItemDatas:[_media.mediaItems allObjects]];
        }];
    }
}

#pragma mark - VideoPlayerViewControllerDelegate

- (void)didChangePlayback:(NSInteger)currentPlaybackTime {
    for ( int i = 1; i < [items count]; i++ ) {
        Item *item = ((ItemData*)items[i]).item;
        if ( item.itemTimeStamp && currentPlaybackTime == [item.itemTimeStamp intValue] ) {
            [self updateItems:i];
            break;
        }
    }
}

- (void) updateItems:(NSInteger)index {
    if ( [items count] > 2 && [self collectionView] && index > 0 && [items count] > index && items[index] ) {
        [[self collectionView] reloadData];
        ItemData *itemData = items[index];
        if ( itemData ) {
            [[self collectionView]
             performBatchUpdates:^{
                 if ( itemData != nil ) {
                     [items insertObject:itemData atIndex:0];
                     [items removeObjectAtIndex:index + 1];
                     [[self collectionView] moveItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] toIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                 }
             } completion:^(BOOL finished) {
                 [[self collectionView] reloadData];
             }];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell*) getCollectionViewCell:(NSIndexPath *) indexPath {
    MediaItemCollectionViewCell *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier:kReuseMediaItemIdentifier forIndexPath:indexPath];
    
    if ( indexPath.row < [items count] && items[indexPath.row] && ((ItemData*)items[indexPath.row]).item )
        [cell setItemData:((ItemData*)items[indexPath.row]).item];
    return cell;
}

@end
