//
//  DestinationDetailsViewController.m
//  Blingby
//
//  Created by Simon Weingand on 21/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "DestinationDetailsViewController.h"
#import "Destination.h"
#import "SearchResult.h"
#import "DestinationItemsViewController.h"
#import "AppManager.h"
#import <UIImageView+WebCache.h>

@interface DestinationDetailsViewController ()

@property (nonatomic, strong) DestinationItemsViewController *destinationItemsViewController;
@property (nonatomic, strong) AppManager *appManager;
@property (nonatomic, strong) UIImageView *topImageView;

@end

@implementation DestinationDetailsViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topImageView = [[UIImageView alloc] initWithFrame:[self getTopViewFrame]];
    _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    _topImageView.clipsToBounds = YES;
    _topImageView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    [self.containerView addSubview:_topImageView];
    _destinationItemsViewController = [[DestinationItemsViewController alloc] init];
    [_destinationItemsViewController setupViews:[self getBottomViewFrame]];
    
    [self addChildViewController:_destinationItemsViewController];
    [self.containerView addSubview:_destinationItemsViewController.view];
    
    NSString *DestinationImageUrl;
    if ( _destination && _destination.destinationImage && ![_destination.destinationImage isEqualToString:@""] ) {
        DestinationImageUrl = _destination.destinationImage;
    }
    else if ( _searchResult && _searchResult.image && ![_searchResult.image isEqualToString:@""] ) {
        DestinationImageUrl = _searchResult.image;
    }
    
    if ( ![DestinationImageUrl isEqualToString:@""] ) {
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        UIImage *DestinationImage = [imageCache imageFromDiskCacheForKey:DestinationImageUrl];
        if ( DestinationImage ) {
            _topImageView.image = DestinationImage;
        }
        else {
            [_topImageView sd_setImageWithURL:[NSURL URLWithString:DestinationImageUrl]
                             placeholderImage:[UIImage imageNamed:@"placeholer"]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        if ( image ) {
                                            [imageCache storeImage:image forKey:DestinationImageUrl toDisk:YES];
                                        }
                                    }];
        }
    }
    else {
        _topImageView.image = nil;
    }
    
    if ( _destination ) {
        [_destinationItemsViewController setDestination:_destination];
    }
    else if ( _searchResult ) {
        [_destinationItemsViewController setSearchResult:_searchResult];
    }
    
    NSString *title;
    if ( _destination ) {
        title = _destination.destinationTitle;
    }
    else if ( _searchResult ) {
        title = _searchResult.title;
    }
    [self makeBBStreamView:title top:_destinationItemsViewController.view.frame.origin.y];
}

- (void)setDestination:(Destination *)destination {
    _destination = destination;
    if ( _appManager == nil ) {
        _appManager = [AppManager sharedManager];
    }
    
    [_appManager addRecentDestinations:destination];
}

@end
