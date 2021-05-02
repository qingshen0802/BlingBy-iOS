//
//  SearchVideosViewController.m
//  Blingby
//
//  Created by Simon Weingand on 06/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "SearchVideosViewController.h"
#import "MediaItemsViewController.h"
#import "MediaCollectionViewCell.h"
#import "DestinationCollectionViewCell.h"
#import "PersonCollectionViewCell.h"
#import "CollectionHeaderReusableView.h"
#import "SearchCollectionViewCell.h"
#import "SearchResult.h"
#import "MediaDetailsViewController.h"
#import "PersonDetailsViewController.h"
#import "DestinationDetailsViewController.h"
#import "LoadingCollectionViewCell.h"
#import "MediaManager.h"

#define kSearchResultSectionName          @"search_section_name"
#define kSearchResultSectionArray         @"search_section_array"

#define kSearchMediasString         @"Search Medias"
#define kSearchDestinationsString   @"Search Destinations"
#define kSearchPersonsString        @"Search Persons"

@interface SearchVideosViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) MediaManager *mediaManager;
@property (nonatomic, assign) NSInteger resultCount;

@end

@implementation SearchVideosViewController

static NSString * const reuseMediaIdentifier        = @"SearchMediaCollectionViewCell";
static NSString * const reuseSearchIdentifier       = @"SearchCollectionViewCell";
static NSString * const reuseDestinationIdentifier  = @"SearchDestinationCollectionViewCell";
static NSString * const reusePersonIdentifier       = @"SearchPersonCollectionViewCell";
static NSString * const reuseSectionHeaderIdentifier = @"SearchCollectionReusableView";
static NSString * const reuseLoadingIndentifier = @"LoadingCollectionViewCell";

static CGSize cellSize;

+ (CGSize) getCellSize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat cellWidth = screenSize.width / kPopularVideoCellCountPerRow - 2 * (kPopularVideoCellCountPerRow - 1);
        CGFloat cellHeight = cellWidth / kVideoRatio;
        cellSize = CGSizeMake(cellWidth, cellHeight);
    });
    
    return cellSize;
}

- (void) setupViews:(CGRect)frame {
    self.view = [[UIView alloc] initWithFrame:frame];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[CollectionHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseSectionHeaderIdentifier];
    [self.collectionView registerClass:[MediaCollectionViewCell class] forCellWithReuseIdentifier:reuseMediaIdentifier];
    [self.collectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:reuseSearchIdentifier];
    [self.collectionView registerClass:[DestinationCollectionViewCell class] forCellWithReuseIdentifier:reuseDestinationIdentifier];
    [self.collectionView registerClass:[PersonCollectionViewCell class] forCellWithReuseIdentifier:reusePersonIdentifier];
    [self.collectionView registerClass:[LoadingCollectionViewCell class] forCellWithReuseIdentifier:reuseLoadingIndentifier];
    
    _resultCount = 1;
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.collectionView];
}

- (void) getResults:(NSString*)searchText {
    if ( _mediaManager == nil ) {
        _mediaManager = [MediaManager sharedManager];
    }
    else {
        [_mediaManager cancelAllObjectRequestOperationsWithMethod:RKRequestMethodGET matchingPathPattern:@"/api/search/:searchString"];
    }
    
    if ( _searchResults ) {
        [_searchResults removeAllObjects];
    }
    else {
        _searchResults = [[NSMutableArray alloc] init];
    }
    _resultCount = 1;
    [self.collectionView reloadData];
    
    [_mediaManager getSearchResult:[searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                              page:[NSNumber numberWithInt:0]
                      itemsPerpage:[NSNumber numberWithInt:kItemsPerPage]
                          callback:^(NSArray *resultArray, NSError *error) {
                              if ( error == nil && resultArray && [resultArray count] > 0 ) {
                                  [self setResults:resultArray];
                              }
                              else {
                                  _resultCount = 0;
                                  [[self collectionView] reloadData];
                              }
                              _mediaManager = nil;
                          }];

}
- (void) setResults:(NSArray*)results {
    
    if ( results ) {
        if ( _searchResults ) {
            [_searchResults removeAllObjects];
        }
        else {
            _searchResults = [[NSMutableArray alloc] init];
        }
        NSMutableArray *medias = [[NSMutableArray alloc] init];
        NSMutableArray *persons = [[NSMutableArray alloc] init];
        NSMutableArray *destinations = [[NSMutableArray alloc] init];
        for ( SearchResult *result in results ) {
            if ( [result.type isEqualToString:@"media"] ) {
                [medias addObject:result];
            }
            else if ( [result.type isEqualToString:@"person"] ) {
                [persons addObject:result];
            }
            else if ( [result.type isEqualToString:@"destination"] ) {
                [destinations addObject:result];
            }
        }
        if ( [medias count] > 0 ) {
            [_searchResults addObject:@{kSearchResultSectionName:kSearchMediasString, kSearchResultSectionArray:medias}];
        }
        if ( [destinations count] > 0 ) {
            [_searchResults addObject:@{kSearchResultSectionName:kSearchDestinationsString, kSearchResultSectionArray:destinations}];
        }
        if ( [persons count] > 0 ) {
            [_searchResults addObject:@{kSearchResultSectionName:kSearchPersonsString, kSearchResultSectionArray:persons}];
        }
    }
    
    _resultCount = [_searchResults count];
    if ( [self collectionView] ) {
        [[self collectionView] reloadData];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.parentViewController.view endEditing:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _resultCount;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_searchResults count] == 0 ? 1 : [[_searchResults[section] objectForKey:kSearchResultSectionArray] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseSectionHeaderIdentifier forIndexPath:indexPath];
    if ( [_searchResults count] > 0 ) {
        NSDictionary *dict = _searchResults[indexPath.section];
        headerView.headerLabel.text = [dict objectForKey:kSearchResultSectionName];
    }
    else {
        headerView.headerLabel.text = @"";
    }
    return headerView;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ( [_searchResults count] > 0 ) {
        return CGSizeMake(0, 50);
    }
    else {
        return CGSizeZero;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ( [_searchResults count] > 0 ) {
        NSDictionary *dict = _searchResults[indexPath.section];
        NSArray *sectionArray = [dict objectForKey:kSearchResultSectionArray];
        SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseSearchIdentifier forIndexPath:indexPath];
        [cell setSearchResult:sectionArray[indexPath.row] cellWidth:[SearchVideosViewController getCellSize].width];
        return cell;
    }
    else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseLoadingIndentifier forIndexPath:indexPath];
        return cell;
    }
}

- (CGSize) collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [SearchVideosViewController getCellSize];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ( [_searchResults count] == 0 )
        return;
    
    NSDictionary *dict = _searchResults[indexPath.section];
    NSString *sectionName = [dict objectForKey:kSearchResultSectionName];
    NSArray *sectionArray = [dict objectForKey:kSearchResultSectionArray];
    SearchResult *searchResult = sectionArray[indexPath.row];
    if ( [sectionName isEqualToString:kSearchMediasString] ) {
        if ( searchResult ) {
            MediaDetailsViewController *mediaDetailsViewController = [[MediaDetailsViewController alloc] init];
            [mediaDetailsViewController setSearchResult:searchResult];
            [self.navigationController pushViewController:mediaDetailsViewController animated:YES];
        }
    }
    else if ( [sectionName isEqualToString:kSearchDestinationsString] ) {
        if ( searchResult ) {
            DestinationDetailsViewController *destinationDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DestinationDetailsViewController"];
            [destinationDetailsViewController setSearchResult:searchResult];
            [self.navigationController pushViewController:destinationDetailsViewController animated:YES];
        }
    }
    else {
        if ( searchResult ) {
            PersonDetailsViewController *personDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonDetailsViewController"];
            [personDetailsViewController setSearchResult:searchResult];
            [self.navigationController pushViewController:personDetailsViewController animated:YES];
        }
    }
}

@end
