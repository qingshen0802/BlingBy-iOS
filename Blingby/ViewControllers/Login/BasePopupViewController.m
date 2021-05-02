//
//  BasePopupViewController.m
//  Blingby
//
//  Created by Simon Weingand on 04/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BasePopupViewController.h"

@interface BasePopupViewController ()

@end

@implementation BasePopupViewController

@synthesize closeButton;

- (void)loadView {
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

#pragma mark - Setup Views

- (void) addCloseButton {
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    CGFloat closeButtonTop = 20; // StatusBarHeight
    CGFloat closeButtonWidth = 60;
    CGFloat closeButtonHeight = IS_PAD ? 40 : 30;
    
    closeButton = [[UIButton alloc] initWithFrame:CGRectMake(rect.size.width - closeButtonWidth, closeButtonTop, closeButtonWidth, closeButtonHeight)];
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    [closeButton.titleLabel setFont:[UIFont systemFontOfSize:CLOSE_BUTTON_FONT_SIZE]];
    [closeButton setTitleColor:BLINGBY_COLOR4 forState:UIControlStateNormal];
    [closeButton setTitleColor:BLINGBY_COLOR1 forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:closeButton];
}

- (void) addBackButton {
    CGFloat backButtonTop = 20; // StatusBarHeight
    CGFloat backButtonWidth = 60;
    CGFloat backButtonHeight = IS_PAD ? 40 : 30;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, backButtonTop, backButtonWidth, backButtonHeight)];
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton setTintColor:BLINGBY_COLOR4];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backButton];
}
#pragma mark - Actions

- (void) closeView {
    [self.view endEditing:YES];
    if ( self.delegate ) {
        [self.delegate onClose:self];
    }
}

- (void) back {
    [self.view endEditing:YES];
    if ( self.delegate ) {
        [self.delegate backViewController:self];
    }
}

@end
