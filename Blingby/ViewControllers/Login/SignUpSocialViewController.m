//
//  SignUpSocialViewController.m
//  Blingby
//
//  Created by Simon Weingand on 02/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "SignUpSocialViewController.h"
#import "SocialButton.h"
#import "SignUpEmailViewController.h"

@interface SignUpSocialViewController ()

@property (nonatomic, strong) SocialButton *facebookButton;
@property (nonatomic, strong) SocialButton *twitterButton;
@property (nonatomic, strong) SocialButton *emailButton;

@end

@implementation SignUpSocialViewController

@synthesize facebookButton;
@synthesize twitterButton;
@synthesize emailButton;

- (void)loadView {
    [super loadView];
    
    [self addContentView];
}

#pragma mark - Setup Views

- (void) addContentView {
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    CGFloat buttonWidth = IS_PAD ? TEXT_FIELD_WIDTH : rect.size.width - HORIZENTAL_MARGIN;
    CGFloat buttonHeight = TEXT_FIELD_HEIGHT;
    CGFloat buttonSpace = TEXT_FIELD_SPACE;
    CGFloat left = (rect.size.width - buttonWidth) / 2.0;
    
    // twitter Button
    CGFloat twitterButtonTop = CONTENT_TOP;
    twitterButton = [[SocialButton alloc] initWithFrame:CGRectMake(left, twitterButtonTop, buttonWidth, buttonHeight)];
    twitterButton.iconImageView.image = [UIImage imageNamed:@"icon_twitter"];
    twitterButton.titleLabel.text = @"sign up with Twitter";

    [self.view addSubview:twitterButton];
    
    // facebook Button
    CGFloat facebookButtonTop = twitterButtonTop + twitterButton.frame.size.height + buttonSpace;
    facebookButton = [[SocialButton alloc] initWithFrame:CGRectMake(left, facebookButtonTop, buttonWidth, buttonHeight)];
    facebookButton.iconImageView.image = [UIImage imageNamed:@"icon_facebook"];
    facebookButton.titleLabel.text = @"sign up with Facebook";
    
    [self.view addSubview:facebookButton];
    
    // email Button
    CGFloat emailButtonTop = facebookButtonTop + facebookButton.frame.size.height + buttonSpace;
    emailButton = [[SocialButton alloc] initWithFrame:CGRectMake(left, emailButtonTop, buttonWidth, buttonHeight)];
    emailButton.iconImageView.image = [UIImage imageNamed:@"icon_email"];
    emailButton.titleLabel.text = @"sign up with Email";
    
    UITapGestureRecognizer *emailTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSignUpWithEmail:)];
    [emailButton addGestureRecognizer:emailTapGesture];
    
    [self.view addSubview:emailButton];
}

#pragma mark - Actions

- (void) onForgotPassword {
    
}

- (void) onGo {
    
}

- (void) onSignUpWithEmail:(UITapGestureRecognizer*)sender {
    if ( self.delegate ) {
        SignUpEmailViewController *signUpEmailViewController = [[SignUpEmailViewController alloc] init];
        [self.delegate popViewController:signUpEmailViewController];
    }
}

@end
