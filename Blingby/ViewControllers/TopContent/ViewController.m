//
//  ViewController.m
//  Blingby
//
//  Created by Simon Weingand on 07/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "PopularVideosViewController.h"
#import "MusicRecognitionViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIViewController *contentViewController;

@property (nonatomic, strong) UINavigationController *videosNavigationConroller;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *sharedInstance = [NSUserDefaults standardUserDefaults];
    if ( [sharedInstance objectForKey:USER_INFO] != nil ) {
        [self addMainViewController];
    }
    else {
        [self addFirstViewController];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMainViewController) name:kNotificationLoggedIn object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationLoggedIn object:nil];
}
	
- (void)addViewController:(UIViewController*)viewController {
    viewController.view.alpha = 0.0;
    
    [self addChildViewController:viewController];
    [self.contentView addSubview:viewController.view];
    
    __weak __block ViewController *weakSelf = self;
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         viewController.view.alpha = 1.0f;
                         if ( weakSelf.contentViewController ) {
                             weakSelf.contentViewController.view.alpha = 0.0f;
                         }
                     }
                     completion:^(BOOL finished) {
                         if ( weakSelf.contentViewController ) {
                             [weakSelf removeViewController:weakSelf.contentViewController];
                         }
                         weakSelf.contentViewController = viewController;
                     }];
}

- (void) removeViewController:(UIViewController*)viewController {
//    [viewController removeFromParentViewController];
    [viewController.view removeFromSuperview];
    viewController = nil;
}

- (void) addFirstViewController {
    [self addViewController:[[FirstViewController alloc] init]];
}

- (void) addMainViewController {
    if ( self.videosNavigationConroller == nil ) {
        self.videosNavigationConroller = [[UINavigationController alloc] initWithRootViewController:[[PopularVideosViewController alloc] init]];
    }
    self.videosNavigationConroller.navigationBarHidden = YES;
    self.videosNavigationConroller.view.backgroundColor = [UIColor clearColor];
    [self addViewController:self.videosNavigationConroller];
//    [self addViewController:[[PopularVideosViewController alloc] init]];
}

@end
