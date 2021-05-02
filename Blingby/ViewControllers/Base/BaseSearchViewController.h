//
//  BaseSearchViewController.h
//  Blingby
//
//  Created by Simon Weingand on 06/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseTopViewController.h"

@interface BaseSearchViewController : BaseTopViewController

@property (nonatomic, strong) UISearchBar *searchBar;

- (void) setupViews:(UIView*)view;
- (void) addSearchBarAndMusicRecognition;

@end
