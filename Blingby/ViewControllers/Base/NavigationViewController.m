//
//  NavigationViewController.m
//  Blingby
//
//  Created by Simon Weingand on 08/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "NavigationViewController.h"
#import "EffectButton.h"

@interface NavigationViewController ()

@property (nonatomic, strong) EffectButton *navButton;
@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, strong) UIImageView *navTitleImageView;

@end

@implementation NavigationViewController

@synthesize navButton;
@synthesize navTitleLabel;
@synthesize navTitleImageView;

- (void)loadView {
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, rect.size.width, NAVIGATION_BAR_HEIGHT)];
    
    navButton = [[EffectButton alloc] initWithFrame:CGRectMake(0, 0, NAVIGATION_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT)];
    [navButton addTarget:self action:@selector(navButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    navButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    [self.view addSubview:navButton];
    
    navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(NAVIGATION_BAR_HEIGHT, 0, rect.size.width - 2 * NAVIGATION_BAR_HEIGHT, NAVIGATION_BAR_HEIGHT)];
    navTitleLabel.font = NAVIGATION_TITLE_FONT;
    navTitleLabel.textColor = NAVIGATION_TINT_COLOR;
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:navTitleLabel];
    
    navTitleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(navTitleLabel.frame.origin.x, 16, navTitleLabel.frame.size.width, navTitleLabel.frame.size.height - 24)];
    navTitleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:navTitleImageView];
}

- (void) navButtonTapped:(id)sender {
    if ( self.isRoot ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNavMenuButtonTapped object:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) setNavRoot:(BOOL)isRoot {
    self.isRoot = isRoot;
    if ( isRoot ) {
        [navButton setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    }
    else {
        [navButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    }
}

- (void) setNavTitle:(NSString*)title {
    if ( title == nil ) {
        [navTitleLabel setHidden:YES];
        [navTitleImageView setHidden:NO];
        navTitleImageView.image = [UIImage imageNamed:@"logo-white-glow"];
    }
    else {
        [navTitleLabel setHidden:NO];
        [navTitleImageView setHidden:YES];
        navTitleLabel.text = title;
    }
}
@end
