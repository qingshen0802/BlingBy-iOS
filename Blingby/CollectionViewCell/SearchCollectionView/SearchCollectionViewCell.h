//
//  SearchCollectionViewCell.h
//  Blingby
//
//  Created by Simon Weingand on 20/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@class SearchResult;

@interface SearchCollectionViewCell : BaseCollectionViewCell

@property (nonatomic, strong) SearchResult *searchResult;
- (void) setSearchResult:(SearchResult *)searchResult cellWidth:(CGFloat)cellWidth;

@end
