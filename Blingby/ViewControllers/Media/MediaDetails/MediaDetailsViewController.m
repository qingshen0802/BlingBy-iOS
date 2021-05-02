//
//  MediaItemViewController.m
//  Blingby
//
//  Created by Simon Weingand on 03/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "MediaDetailsViewController.h"
#import "MediaItemsViewController.h"
#import "VideoPlayerViewController.h"
#import "AppManager.h"
#import "Media.h"
#import "SearchResult.h"

@interface MediaDetailsViewController ()

@property (nonatomic, strong) VideoPlayerViewController *videoPlayerViewController;
@property (nonatomic, strong) MediaItemsViewController *mediaItemsViewController;
@property (nonatomic, strong) AppManager *appManager;

@end

@implementation MediaDetailsViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _videoPlayerViewController = [[VideoPlayerViewController alloc] init];
    _mediaItemsViewController = [[MediaItemsViewController alloc] init];
    [_videoPlayerViewController setupViews:[self getTopViewFrame]];
    [_mediaItemsViewController setupViews:[self getBottomViewFrame]];
    
    [self addChildViewController:_videoPlayerViewController];
    [self.containerView addSubview:_videoPlayerViewController.view];
    
    [self addChildViewController:_mediaItemsViewController];
    [self.containerView addSubview:_mediaItemsViewController.view];
    
    if ( _media ) {
        [_mediaItemsViewController setMedia:_media];
        [_videoPlayerViewController setMedia:_media];
        [self.navigationViewController setTitle:_media.mediaTitle];
    }
    else if ( _searchResult ) {
        [_mediaItemsViewController setSearchResult:_searchResult];
        [_videoPlayerViewController setSearchResult:_searchResult];
        [self.navigationViewController setTitle:_searchResult.mediaSubTitle];
    }
    _videoPlayerViewController.delegate = _mediaItemsViewController;

    NSString *title;
    if ( _media ) {
        title = _media.mediaTitle;
    }
    else if ( _searchResult ) {
        title = _searchResult.title;
    }
    [self makeBBStreamView:title top:_mediaItemsViewController.view.frame.origin.y];
}

- (void)setMedia:(Media *)media {
    _media = media;
    if ( _appManager == nil ) {
        _appManager = [AppManager sharedManager];
    }
    
    [_appManager addRecentMedia:media];
}

@end
