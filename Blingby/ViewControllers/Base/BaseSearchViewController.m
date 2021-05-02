//
//  BaseSearchViewController.m
//  Blingby
//
//  Created by Simon Weingand on 06/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseSearchViewController.h"
#import "SearchVideosViewController.h"
#import "MusicRecognitionViewController.h"
#import "MediaManager.h"

@interface BaseSearchViewController ()<UISearchBarDelegate, MusicRecognitionViewControllerDelegate> {
    BOOL isCanceledSearch;
}

@property (nonatomic, strong) SearchVideosViewController *searchViewController;
@property (nonatomic, strong) MusicRecognitionViewController *musicRecognitionViewController;
@property (nonatomic, strong) UIView *musicRecognitionView;
@property (nonatomic, strong) UIView *soundBarView;
@property (nonatomic, strong) UIButton *soundButton;

@end

@implementation BaseSearchViewController

- (void) loadView {
    [super loadView];
}

- (void) setupViews:(UIView*)view {
    [super setupViews:view];
    [self addSearchBarAndMusicRecognition];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isCanceledSearch = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ( self.musicRecognitionView.alpha == 1.0f ) {
        [self closeMusicRecognition];
    }
}

- (void) addSearchBarAndMusicRecognition {
    if ( self.searchBar == nil ) {
        self.searchBar = [[UISearchBar alloc] init];
        [self.contentView addSubview:self.searchBar];
        self.searchBar.backgroundColor = [UIColor clearColor];
        self.searchBar.barTintColor = UIColorFromRGB(0x00041f);
        self.searchBar.tintColor = [UIColor whiteColor];
        self.searchBar.delegate = self;
        [self.searchBar sizeToFit];
        CGRect rect = self.searchBar.bounds;
        rect.origin.y = self.navigationViewController.view.frame.origin.y + self.navigationViewController.view.frame.size.height;
        self.searchBar.frame = rect;
        self.searchBar.alpha = 0.3;
        
        CGSize size = self.view.bounds.size;
        CGFloat top = self.searchBar.frame.origin.y + self.searchBar.frame.size.height;
        CGFloat width = size.width;
        CGFloat height = size.height - top;
        self.searchViewController = [[SearchVideosViewController alloc] init];
        [self.searchViewController setupViews:CGRectMake(0, top, width, height)];
        
        self.musicRecognitionView = [[UIView alloc] init];
        self.musicRecognitionView.alpha = 0.0f;
        self.musicRecognitionView.clipsToBounds = true;
        [self.musicRecognitionView setHidden:YES];
        self.musicRecognitionView.frame = CGRectMake(0, 0, size.width, size.height);
        
        [self.view addSubview:self.musicRecognitionView];
        
        [self addChildViewController:self.searchViewController];
        [self.contentView addSubview:self.searchViewController.view];
        
        [self.searchViewController.view setHidden:YES];
        
        // SoundBar
        CGFloat soundBarHeight = kSoundBarHeight;
        CGFloat soundButtonSize = kSoundBarHeight - 8;
        self.soundBarView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height - soundBarHeight, size.width, soundBarHeight)];
        self.soundBarView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        self.soundButton = [[UIButton alloc] initWithFrame:CGRectMake(self.soundBarView.frame.size.width / 2 - soundButtonSize / 2, (soundBarHeight - soundButtonSize) / 2, soundButtonSize, soundButtonSize)];
        [self.soundButton setImage:[UIImage imageNamed:@"sound"] forState:UIControlStateNormal];
        [self.soundButton addTarget:self action:@selector(onMusicRecognition:) forControlEvents:UIControlEventTouchUpInside];
        [self.soundBarView addSubview:self.soundButton];
        
        [self.view addSubview:self.soundBarView];	
        
    }
}
#pragma mark - MusicRecognitionViewControllerDelegate

- (void) onMusicRecognition:(id) sender {

    if ( self.musicRecognitionView.alpha != 1.0f ) {
        
        self.musicRecognitionViewController = [[MusicRecognitionViewController alloc] init];
        self.musicRecognitionViewController.delegate = self;
        self.musicRecognitionViewController.view.frame = self.musicRecognitionView.bounds;
        [self addChildViewController:self.musicRecognitionViewController];
        [self.musicRecognitionView addSubview:self.musicRecognitionViewController.view];
        
        [self.musicRecognitionView setHidden:NO];
        self.soundButton.enabled = NO;
        CGSize size = self.musicRecognitionViewController.view.bounds.size;
        self.musicRecognitionViewController.view.frame = CGRectMake(0, size.height, size.width, size.height);
        self.musicRecognitionView.alpha = 0.0f;
        [self.musicRecognitionView setHidden:NO];
        [UIView animateWithDuration:.5f
                         animations:^{
                             self.musicRecognitionViewController.view.frame = CGRectMake(0, 0, size.width, size.height);
                             self.musicRecognitionView.alpha = 1.0f;
                         }
                         completion:^(BOOL finished) {
                             [self.musicRecognitionViewController startRecognition];
                         }];
    }
    else {
        [self.musicRecognitionViewController startRecognition];
    }
}

-(void) enableOrDisableControls:(BOOL) enable {
    self.soundButton.enabled = YES;
}

- (void) closeMusicRecognition {
    CGSize size = self.musicRecognitionViewController.view.frame.size;
    self.musicRecognitionViewController.view.frame = CGRectMake(0, 0, size.width, size.height);
    self.musicRecognitionView.alpha = 1.0f;
    [UIView animateWithDuration:.5f
                     animations:^{
                         self.musicRecognitionViewController.view.frame = CGRectMake(0, size.height, size.width, size.height);
                         self.musicRecognitionView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self.musicRecognitionView setHidden:YES];
                         self.soundButton.enabled = YES;
                         [self.musicRecognitionViewController removeFromParentViewController];
                         [self.musicRecognitionViewController.view removeFromSuperview];
                         self.musicRecognitionViewController = nil;
                     }];
}

- (void) selectedDataModel:(NSString*) title {
    [self closeMusicRecognition];
    [self.searchBar setText:title];
    [self search:title];
    [self.searchBar becomeFirstResponder];
    [self search:title];
}

#pragma mark - UISearchBarDelegate

- (void) search:(NSString*)searchText {
    if ( searchText.length > 1 ) {
        [self.searchViewController getResults:searchText];
    }
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self showSearchBar];
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self search:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self hideSearchBar];
}

- (void) showSearchBar {
    if ( isCanceledSearch ) {
        self.searchBar.alpha = 0.3;
        [self.searchBar setShowsCancelButton:YES animated:YES];
        [self.searchViewController.view setAlpha:0.0f];
        [self.searchViewController.view setHidden:NO];
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.searchBar.alpha = 1.0;
                             [self.searchViewController.view setAlpha:1.0f];
                         }
                         completion:^(BOOL finished) {
                             [self.searchViewController.view setHidden:NO];
                             [self.searchBar becomeFirstResponder];
                         }];
    }
    isCanceledSearch = NO;
}

- (void) hideSearchBar {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchViewController.view setHidden:YES];
    [self.searchViewController.view setAlpha:1.0f];
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.searchBar.alpha = 0.3;
                         [self.searchViewController.view setAlpha:0.0f];
                     }
                     completion:^(BOOL finished) {
                         [self.searchViewController.view setHidden:YES];
                         [self.searchViewController setResults:nil];
                         isCanceledSearch = YES;
                     }];
}
@end
