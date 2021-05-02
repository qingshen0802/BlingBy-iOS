//
//  BaseTopViewController.m
//  Blingby
//
//  Created by Simon Weingand on 02/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseTopViewController.h"

@interface BaseTopViewController ()

@end

@implementation BaseTopViewController

@synthesize navigationViewController;

- (void) loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self initViews];
    self.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (void) setupViews:(UIView*)view {
    if ( navigationViewController == nil ) {
        navigationViewController = [[NavigationViewController alloc] init];
        [self addChildViewController:navigationViewController];
        [self.view addSubview:navigationViewController.view];
    }
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGRect navBarFrame = navigationViewController.view.frame;
    CGFloat contentViewTop = navBarFrame.origin.y + navBarFrame.size.height;
    if ( [view isKindOfClass:[UICollectionView class]] ) {
        view.frame = CGRectMake(COLLECTIONVIEW_CELL_SPACE, contentViewTop + COLLECTIONVIEW_CELL_SPACE, rect.size.width - COLLECTIONVIEW_CELL_SPACE * 2, rect.size.height - contentViewTop - COLLECTIONVIEW_CELL_SPACE * 2);
    }
    else {
        view.frame = CGRectMake(0, contentViewTop, rect.size.width, rect.size.height - contentViewTop);
    }
    [self.contentView addSubview:view];
}

@end
