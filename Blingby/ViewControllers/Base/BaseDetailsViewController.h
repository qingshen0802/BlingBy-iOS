//
//  BaseDetailsViewController.h
//  Blingby
//
//  Created by Simon Weingand on 09/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseSearchViewController.h"

@interface BaseDetailsViewController : BaseSearchViewController

@property (nonatomic, strong) UIView *containerView;

- (CGRect) getTopViewFrame;
- (CGRect) getBottomViewFrame;
- (void)makeBBStreamView:(NSString *)title top:(CGFloat)top;

@end
