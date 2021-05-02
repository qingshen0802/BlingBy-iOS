//
//  RecentCollectionViewController.m
//  Blingby
//
//  Created by Simon Weingand on 27/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "RecentCollectionViewController.h"
#import "MediaDetailsViewController.h"
#import "PersonDetailsViewController.h"
#import "DestinationDetailsViewController.h"
#import "MediaCollectionViewCell.h"
#import "DestinationCollectionViewCell.h"
#import "PersonCollectionViewCell.h"
#import "CollectionHeaderReusableView.h"
#import "AppManager.h"

#define kRecentSectionName          @"recent_section_name"
#define kRecentSectionArray         @"recent_section_array"

#define kRecentMediasString         @"YOUR VIDEOS"
#define kRecentDestinationsString   @"YOUR DESTINATIONS"
#define kRecentPersonsString        @"YOUR PERSONS"


@interface RecentCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *recents;
@property (nonatomic, strong) AppManager *appManager;

@end

@implementation RecentCollectionViewController

@synthesize appManager;

static NSString * const reuseMediaIdentifier        = @"RecentMediaCollectionViewCell";
static NSString * const reuseDestinationIdentifier  = @"RecentDestinationCollectionViewCell";
static NSString * const reusePersonIdentifier       = @"RecentPersonCollectionViewCell";
static NSString * const reuseSectionHeaderIdentifier = @"RecentCollectionReusableView";

static CGSize cellSize;

+ (CGSize) getCellSize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat cellWidth = screenSize.width / 2 - 2;
        CGFloat cellHeight = cellWidth / kVideoRatio;
        cellSize = CGSizeMake(cellWidth, cellHeight);
    });
    
    return cellSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ( appManager == nil ) {
        appManager = [AppManager sharedManager];
    }
    if ( _recents ) {
        [_recents removeAllObjects];
    }
    else {
        _recents = [[NSMutableArray alloc] init];
    }
    if ( [appManager getRecentMedias] && [[appManager getRecentMedias] count] > 0 ) {
        NSDictionary *recentMedias = @{kRecentSectionName:kRecentMediasString, kRecentSectionArray:[appManager getRecentMedias]};
        [_recents addObject:recentMedias];
    }
    
    if ( [appManager getRecentDestinations] && [[appManager getRecentDestinations] count] > 0 ) {
        NSDictionary *recentDestinations = @{kRecentSectionName:kRecentDestinationsString, kRecentSectionArray:[appManager getRecentDestinations]};
        [_recents addObject:recentDestinations];
    }
    
    if ( [appManager getRecentPersons] && [[appManager getRecentPersons] count] > 0 ) {
        NSDictionary *recentPersons = @{kRecentSectionName:kRecentPersonsString, kRecentSectionArray:[appManager getRecentPersons]};
        [_recents addObject:recentPersons];
    }
    
    if ( [_recents count] == 0 ) {
        NSDictionary *recent = @{kRecentSectionName:@"RECENT", kRecentSectionArray:@[]};
        [_recents addObject:recent];
    }
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_recents count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[_recents[section] objectForKey:kRecentSectionArray] count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseSectionHeaderIdentifier forIndexPath:indexPath];
    NSDictionary *dict = _recents[indexPath.section];
    [headerView setHeaderTitle:[dict objectForKey:kRecentSectionName]];
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *dict = _recents[indexPath.section];
    NSString *sectionName = [dict objectForKey:kRecentSectionName];
    NSArray *sectionArray = [dict objectForKey:kRecentSectionArray];
    if ( [sectionName isEqualToString:kRecentMediasString] ) {
        MediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseMediaIdentifier forIndexPath:indexPath];
        [cell setMedia:sectionArray[indexPath.row] cellWidth:[RecentCollectionViewController getCellSize].width];
        return cell;
    }
    else if ( [sectionName isEqualToString:kRecentDestinationsString] ) {
        DestinationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseDestinationIdentifier forIndexPath:indexPath];
        [cell setDestination:sectionArray[indexPath.row] cellWidth:[RecentCollectionViewController getCellSize].width];
        return cell;
    }
    else {
        PersonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusePersonIdentifier forIndexPath:indexPath];
        [cell setPerson:sectionArray[indexPath.row] cellWidth:[RecentCollectionViewController getCellSize].width];
        return cell;
    }
}

- (CGSize) collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), kCollectionViewSectionHeaderHeight);
}

- (CGSize) collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [RecentCollectionViewController getCellSize];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _recents[indexPath.section];
    NSString *sectionName = [dict objectForKey:kRecentSectionName];
    NSArray *sectionArray = [dict objectForKey:kRecentSectionArray];
    if ( [sectionName isEqualToString:kRecentMediasString] ) {
        Media *media = sectionArray[indexPath.row];
        if ( media ) {
            MediaDetailsViewController *mediaDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MediaDetailsViewController"];
            [mediaDetailsViewController setMedia:media];
            [self.navigationController pushViewController:mediaDetailsViewController animated:YES];
        }
    }
    else if ( [sectionName isEqualToString:kRecentDestinationsString] ) {
        Destination *destination = sectionArray[indexPath.row];
        if ( destination ) {
            DestinationDetailsViewController *destinationDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DestinationDetailsViewController"];
            [destinationDetailsViewController setDestination:destination];
            [self.navigationController pushViewController:destinationDetailsViewController animated:YES];
        }
    }
    else {
        Person *person = sectionArray[indexPath.row];
        if ( person ) {
            PersonDetailsViewController *personDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonDetailsViewController"];
            [personDetailsViewController setPerson:person];
            [self.navigationController pushViewController:personDetailsViewController animated:YES];
        }
    }
}

@end
