//
//  DestinationDetailsViewController.h
//  Blingby
//
//  Created by Simon Weingand on 21/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseDetailsViewController.h"

@class Destination;
@class SearchResult;

@interface DestinationDetailsViewController : BaseDetailsViewController

@property (nonatomic, strong) Destination *destination;
@property (nonatomic, strong) SearchResult *searchResult;

@end
