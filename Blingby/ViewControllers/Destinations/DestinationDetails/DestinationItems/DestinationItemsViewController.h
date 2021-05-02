//
//  DestinationItemsViewController.h
//  Blingby
//
//  Created by Simon Weingand on 21/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseItemDetailsViewController.h"

@class Destination;
@class SearchResult;

@interface DestinationItemsViewController : BaseItemDetailsViewController

@property (nonatomic, strong) Destination *destination;
@property (nonatomic, strong) SearchResult *searchResult;

@end
