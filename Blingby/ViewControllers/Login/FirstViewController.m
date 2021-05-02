//
//  FirstViewController.m
//  Blingby
//
//  Created by Simon Weingand on 02/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "FirstViewController.h"
#import <PBJVideoPlayer/PBJVideoPlayerController.h>
#import <AVFoundation/AVAnimation.h>
#import "ILTranslucentView.h"
#import "LoginViewController.h"
#import "SignUpSocialViewController.h"
#import "SignUpEmailViewController.h"
#import "SignUpSocialViewController.h"

#define BUTTON_HEIGHT   (IS_PAD ? 60 : 48)
#define BUTTON_FONT_SIZE (IS_PAD ? 30 : 24)

@interface FirstViewController ()<PopupViewControllerCloseDelegate>

@property (nonatomic, strong) PBJVideoPlayerController *videoPlayerController;
@property (nonatomic, strong) ILTranslucentView *loginButtonView;
@property (nonatomic, strong) ILTranslucentView *signUpButtonView;
@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) NSMutableArray *popupViewControllers;

@end

@implementation FirstViewController

@synthesize videoPlayerController;
@synthesize blurMask, blurredBgImage;
@synthesize loginButtonView, signUpButtonView, logoImageView;
@synthesize popupViewControllers;

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self initViews];
    
    [self addVideoPlayerController];
    [self addContentView];
    
    blurredBgImage.alpha = 0;
    blurMask.alpha = 0;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ( videoPlayerController ) {
        [videoPlayerController playFromCurrentTime];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ( videoPlayerController ) {
        [videoPlayerController stop];
    }
}

#pragma mark - Setup Views

- (void) addVideoPlayerController {
    if ( videoPlayerController == nil ) {
        videoPlayerController = [[PBJVideoPlayerController alloc] init];
        [self addChildViewController:videoPlayerController];
        [self.backgroundView addSubview:videoPlayerController.view];
        [videoPlayerController didMoveToParentViewController:self];
        videoPlayerController.view.frame = [UIScreen mainScreen].bounds;
        
        [videoPlayerController setVideoFillMode:AVLayerVideoGravityResizeAspectFill];
        
        NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"intro" ofType:@"m4v"];
        videoPlayerController.videoPath = videoPath;
        [videoPlayerController setPlaybackLoops:YES];
        videoPlayerController.view.userInteractionEnabled = NO;
    }
}

- (void) addContentView {
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    CGFloat buttonWidth = rect.size.width;
    CGFloat buttonHeight = BUTTON_HEIGHT;
    
    // SignUp Button
    CGFloat signUpButtonTop = rect.size.height - 16 - buttonHeight;
    
    signUpButtonView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, signUpButtonTop, buttonWidth, buttonHeight)];
    signUpButtonView.translucentAlpha = 0.3;
    signUpButtonView.translucentStyle = UIBarStyleDefault;
    signUpButtonView.translucentTintColor = UIColorFromRGB(0x00093f);
    signUpButtonView.backgroundColor = [UIColor clearColor];
    
    UIButton *signUpButton = [[UIButton alloc] initWithFrame:signUpButtonView.bounds];
    [signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    signUpButton.backgroundColor = [UIColor clearColor];
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [signUpButton.titleLabel setFont:[UIFont fontWithName:@"HelveticalNeue" size:BUTTON_FONT_SIZE]];
    [signUpButton addTarget:self action:@selector(showSignUpView) forControlEvents:UIControlEventTouchUpInside];
    [signUpButtonView addSubview:signUpButton];
    
    [self.contentView addSubview:signUpButtonView];
    
    // Login Button
    CGFloat loginButtonTop = signUpButtonView.frame.origin.y - 12 - buttonHeight;
    
    loginButtonView = [[ILTranslucentView alloc] initWithFrame:CGRectMake(0, loginButtonTop, buttonWidth, buttonHeight)];
    loginButtonView.translucentAlpha = 0.3;
    loginButtonView.translucentStyle = UIBarStyleDefault;
    loginButtonView.translucentTintColor = UIColorFromRGB(0x00093f);
    loginButtonView.backgroundColor = [UIColor clearColor];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:signUpButtonView.bounds];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor clearColor];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [loginButton.titleLabel setFont:[UIFont fontWithName:@"HelveticalNeue" size:BUTTON_FONT_SIZE]];
    [loginButton addTarget:self action:@selector(showLoginView) forControlEvents:UIControlEventTouchUpInside];
    [loginButtonView addSubview:loginButton];
    
    [self.contentView addSubview:loginButtonView];
    
    // Logo Image
    CGFloat logoImageHeight = LOGO_IMAGE_HEIGHT;
    CGFloat logoImageTop = (loginButtonTop - logoImageHeight) / 2;
    
    logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, logoImageTop, buttonWidth - 60, logoImageHeight)];
    [logoImageView setImage:[UIImage imageNamed:@"logo-white-glow"]];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:logoImageView];
}

#pragma mark - Actions

- (void) showPopupView:(UIViewController*)viewController {
    
    [videoPlayerController pause];
    [self backgroundBlur];
    [self hideBluredImage];
    
    if ( popupViewControllers == nil ) {
        popupViewControllers = [[NSMutableArray alloc] init];
    }
    else {
        [popupViewControllers removeAllObjects];
    }
    [popupViewControllers addObject:viewController];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    viewController.view.frame = CGRectMake(0, rect.size.height, rect.size.width, rect.size.height);
    viewController.view.alpha = 0;
    
    [self addChildViewController:viewController];
    [self.view insertSubview:viewController.view belowSubview:logoImageView];
    
    CGRect logoImageRect = logoImageView.frame;
    logoImageRect.origin.y = (CONTENT_TOP - LOGO_IMAGE_HEIGHT) / 2 + 20;
    
    __weak __block FirstViewController *weakSelf = self;
    
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         [weakSelf showBluredImage];
                         loginButtonView.alpha = 0.0f;
                         signUpButtonView.alpha = 0.0f;
                         logoImageView.frame = logoImageRect;
                         viewController.view.frame = rect;
                         viewController.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {

                     }];
}

- (void) showSignUpView {
    SignUpSocialViewController *signUpSocialViewController = [[SignUpSocialViewController alloc] init];
    signUpSocialViewController.delegate = self;
    [self showPopupView:signUpSocialViewController];
}

- (void) showLoginView {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    loginViewController.delegate = self;
    [self showPopupView:loginViewController];
}

#pragma mark - PopupViewControllerCloseDelegate

- (void) onClose:(BasePopupViewController*)viewController {
    CGRect rect = viewController.view.bounds;
    rect.origin.y = rect.size.height;
    [self showBluredImage];
    
    CGRect logoImageRect = logoImageView.frame;
    logoImageRect.origin.y = (loginButtonView.frame.origin.y - LOGO_IMAGE_HEIGHT) / 2;
    
    __weak __block FirstViewController *weakSelf = self;
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         [weakSelf hideBluredImage];
                         loginButtonView.alpha = 1.0f;
                         signUpButtonView.alpha = 1.0f;
                         logoImageView.frame = logoImageRect;
                         viewController.view.frame = rect;
                         viewController.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [videoPlayerController playFromCurrentTime];
                         for ( int i = (int)[popupViewControllers count] - 1; i >= 0; i-- ) {
                             UIViewController *popupViewController = [popupViewControllers lastObject];
                             [popupViewController removeFromParentViewController];
                             [popupViewController.view removeFromSuperview];
                             [popupViewControllers removeLastObject];
                         }
                     }];
}

- (void) popViewController:(BasePopupViewController*)viewController {
    UIViewController *prevViewController = [popupViewControllers lastObject];
    [popupViewControllers addObject:viewController];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    viewController.view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    viewController.view.alpha = 0;
    viewController.delegate = self;
    
    [self addChildViewController:viewController];
    [self.view insertSubview:viewController.view belowSubview:logoImageView];
    
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         prevViewController.view.alpha = 0.0;
                         viewController.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void) backViewController:(BasePopupViewController*)viewController {
    [popupViewControllers removeLastObject];
    UIViewController *prevViewController = [popupViewControllers lastObject];
    
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         prevViewController.view.alpha = 1.0;
                         viewController.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [viewController removeFromParentViewController];
                         [viewController.view removeFromSuperview];
                     }];
}

@end
