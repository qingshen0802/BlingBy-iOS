//
//  PersonDetailsViewController.m
//  Blingby
//
//  Created by Simon Weingand on 14/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "PersonDetailsViewController.h"
#import "Person.h"
#import "SearchResult.h"
#import "PersonItemsViewController.h"
#import "AppManager.h"
#import <UIImageView+WebCache.h>

@interface PersonDetailsViewController ()

@property (nonatomic, strong) PersonItemsViewController *personItemsViewController;
@property (nonatomic, strong) AppManager *appManager;
@property (nonatomic, strong) UIImageView *topImageView;

@end

@implementation PersonDetailsViewController

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
    _personItemsViewController = [[PersonItemsViewController alloc] init];
    [_personItemsViewController setupViews:[self getBottomViewFrame]];
    
    [self addChildViewController:_personItemsViewController];
    [self.containerView addSubview:_personItemsViewController.view];
    
    NSString *personImageUrl;
    if ( _person && _person.personImage && ![_person.personImage isEqualToString:@""] ) {
        personImageUrl = _person.personImage;
    }
    else if ( _searchResult && _searchResult.image && ![_searchResult.image isEqualToString:@""] ) {
        personImageUrl = _searchResult.image;
    }
    
    if ( ![personImageUrl isEqualToString:@""] ) {
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        UIImage *DestinationImage = [imageCache imageFromDiskCacheForKey:personImageUrl];
        if ( DestinationImage ) {
            _topImageView.image = DestinationImage;
        }
        else {
            [_topImageView sd_setImageWithURL:[NSURL URLWithString:personImageUrl]
                             placeholderImage:[UIImage imageNamed:@"placeholer"]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        if ( image ) {
                                            [imageCache storeImage:image forKey:personImageUrl toDisk:YES];
                                        }
                                    }];
        }
    }
    else {
        _topImageView.image = nil;
    }
    
    if ( _person ) {
        [_personItemsViewController setPerson:_person];
    }
    else if ( _searchResult ) {
        [_personItemsViewController setSearchResult:_searchResult];
    }
    
    NSString *title;
    if ( _person ) {
        title = _person.personTitle;
    }
    else if ( _searchResult ) {
        title = _searchResult.title;
    }
    [self makeBBStreamView:title top:_personItemsViewController.view.frame.origin.y];
}

- (void)setPerson:(Person *)person {
    _person = person;
    if ( _appManager == nil ) {
        _appManager = [AppManager sharedManager];
    }
    
    [_appManager addRecentPersons:person];
}

@end
