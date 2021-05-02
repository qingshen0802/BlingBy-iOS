//
//  BaseTopViewController.h
//  Blingby
//
//  Created by Simon Weingand on 02/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseBlurViewController.h"
#import "NavigationViewController.h"

@interface BaseTopViewController : BaseBlurViewController

@property (nonatomic, strong) NavigationViewController *navigationViewController;

- (void) setupViews:(UIView*)view;

@end
