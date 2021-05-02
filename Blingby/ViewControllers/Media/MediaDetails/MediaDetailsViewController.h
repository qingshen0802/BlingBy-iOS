//
//  MediaItemViewController.h
//  Blingby
//
//  Created by Simon Weingand on 03/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseDetailsViewController.h"

@class Media;
@class SearchResult;

@interface MediaDetailsViewController : BaseDetailsViewController

@property (nonatomic, strong) Media *media;
@property (nonatomic, strong) SearchResult *searchResult;
@end
