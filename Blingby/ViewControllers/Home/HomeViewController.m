//
//  HomeViewController.m
//  Blingby
//
//  Created by Simon Weingand on 13/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "HomeViewController.h"
#import "RecentCollectionViewController.h"
#import "SavedItemsViewController.h"
#import <PBJVideoPlayer/PBJVideoPlayerController.h>

@interface HomeViewController ()

@property (nonatomic, strong) PBJVideoPlayerController *videoPlayerController;
@property (nonatomic, strong) RecentCollectionViewController *recentCollectionViewController;
@property (nonatomic, strong) SavedItemsViewController *savedItemViewController;

@end

@implementation HomeViewController

@synthesize videoPlayerController;
@synthesize recentCollectionViewController;
@synthesize savedItemViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    [self setNavigationTitleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ( videoPlayerController == nil ) {
        [self addViewControllers];
    }
    
    if ( videoPlayerController ) {
        [videoPlayerController playFromCurrentTime];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ( !IS_PAD ) {
        [self setNavigationTitleView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ( IS_PAD ) {
        self.navigationItem.title = @"blingby";
    }
}

- (void) setNavigationTitleView {
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-white-glow"]];
    titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect rect = self.navigationController.navigationBar.bounds;
    rect.origin.y = 8;
    rect.size.height -= 16;
    titleImageView.frame = rect;
    self.navigationItem.titleView = titleImageView;
}
#pragma mark - Setup Views

- (void) addViewControllers {
//    if ( videoPlayerController == nil ) {
//        videoPlayerController = [[PBJVideoPlayerController alloc] init];
////        [self setTopView:videoPlayerController.view];
//        
//        NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"intro" ofType:@"m4v"];
//        videoPlayerController.videoPath = videoPath;
//        [videoPlayerController setPlaybackLoops:YES];
//        videoPlayerController.view.userInteractionEnabled = NO;
//        
//        UIView *contentView = [[UIView alloc] init];
//
//        if ( recentCollectionViewController == nil ) {
//            recentCollectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RecentCollectionViewController"];
//        }
//
//        if ( savedItemViewController == nil ) {
//            savedItemViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SavedItemsViewController"];
//        }
//        
//        [self addChildViewController:videoPlayerController];
//        [self.view addSubview:videoPlayerController.view];
//        [videoPlayerController didMoveToParentViewController:self];
//        
//        [self.view addSubview:contentView];
//        
//        [self addChildViewController:recentCollectionViewController];
//        [contentView addSubview:recentCollectionViewController.view];
//        
//        [self addChildViewController:savedItemViewController];
//        [contentView addSubview:savedItemViewController.view];
//        
//        [self setContentView:contentView];
//    }
//    
////    [self setFrames];
//    
//    CGSize contentSize = [self contentView].frame.size;
//    recentCollectionViewController.view.frame = CGRectMake(0, 0, contentSize.width / 2, contentSize.height);
//    savedItemViewController.view.frame = CGRectMake(contentSize.width / 2, kCollectionViewSectionHeaderHeight, contentSize.width / 2, contentSize.height - kCollectionViewSectionHeaderHeight);
//    
//    
//    // Make "Saved Product" Label
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(contentSize.width / 2 + kPaddingForLabel / 4, 0, contentSize.width / 2 - kPaddingForLabel / 4, kCollectionViewSectionHeaderHeight)];
//    view.backgroundColor = UIColorFromRGB(0x00063f);
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kPaddingForLabel, 0, view.frame.size.width - 2 * kPaddingForLabel, view.frame.size.height)];
//    label.text = @"SAVED PRODUCTS";
//    label.font = kCollectionViewSectionHeaderFont;
//    label.textColor = [UIColor whiteColor];
//    [view addSubview:label];
//    [self.contentView addSubview:view];
//    
//    [self addSearchBarAndMusicRecognition];
}

@end
