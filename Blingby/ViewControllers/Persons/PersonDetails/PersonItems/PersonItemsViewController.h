//
//  PersonItemsViewController.h
//  Blingby
//
//  Created by Simon Weingand on 14/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseItemDetailsViewController.h"

@class Person;
@class SearchResult;

@interface PersonItemsViewController : BaseItemDetailsViewController

@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) SearchResult *searchResult;

@end
