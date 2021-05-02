//
//  PersonDetailsViewController.h
//  Blingby
//
//  Created by Simon Weingand on 14/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseDetailsViewController.h"

@class Person;
@class SearchResult;

@interface PersonDetailsViewController : BaseDetailsViewController

@property (nonatomic, strong) Person *person;
@property (nonatomic, strong) SearchResult *searchResult;

@end
