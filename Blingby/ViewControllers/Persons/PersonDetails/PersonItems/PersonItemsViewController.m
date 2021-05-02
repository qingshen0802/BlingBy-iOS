//
//  PersonItemsViewController.m
//  Blingby
//
//  Created by Simon Weingand on 14/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "PersonItemsViewController.h"
#import "PersonItemCollectionViewCell.h"

#import "Person.h"
#import "Item.h"
#import "SearchResult.h"
#import "MediaManager.h"
#import "AppManager.h"

#define kReusePeronItemIdentifier @"PersonItemCollectionViewCell"

@interface PersonItemsViewController ()

@end

@implementation PersonItemsViewController

@synthesize items;

- (void) setupViews:(CGRect)frame {
    [super setupViews:frame];
    [self.collectionView registerClass:[PersonItemCollectionViewCell class] forCellWithReuseIdentifier:kReusePeronItemIdentifier];
}


#pragma mark - Load Person Items

- (void)setPerson:(Person*) person {
    if ( _person && [_person.personId intValue] == [person.personId  intValue] ) {
        
    }
    else {
        _person = person;
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
    if ( _person ) {
        if ( _person.personItems && [_person.personItems count] > 0 ) {
            [self initItemDatas:[_person.personItems allObjects]];
        }
        else {
            [[MediaManager sharedManager] getPersonDetails:_person.personId callback:^(id result, NSError *error) {
                if ( result && [result isKindOfClass:[Person class]] ) {
                    Person *person = result;
                    _person.personItems = person.personItems;
                }
                [self initItemDatas:[_person.personItems allObjects]];
            }];
        }
    }
    else if ( _searchResult ) {
        [[MediaManager sharedManager] getPersonDetails:_searchResult.contentId callback:^(id result, NSError *error) {
            if ( result && [result isKindOfClass:[Person class]] ) {
                _person = result;
                AppManager *appManager = [AppManager sharedManager];
                [appManager addRecentPersons:_person];
            }
            [self initItemDatas:[_person.personItems allObjects]];
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell*) getCollectionViewCell:(NSIndexPath *) indexPath {
    PersonItemCollectionViewCell *cell = [[self collectionView] dequeueReusableCellWithReuseIdentifier:kReusePeronItemIdentifier forIndexPath:indexPath];
    [cell setItemData:((ItemData*)items[indexPath.row]).item];
    return cell;
}

@end
