//
//  SearchCollectionViewCell.m
//  Blingby
//
//  Created by Simon Weingand on 20/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "SearchCollectionViewCell.h"
#import "SearchResult.h"

@implementation SearchCollectionViewCell

- (void) initLabel {
    [self initLabel:UIColorFromRGB(0xffd300)];
}

- (void) setSearchResult:(SearchResult *)searchResult cellWidth:(CGFloat)cellWidth {
    _searchResult = searchResult;
    if ( [searchResult.type isEqualToString:@"media"] ) {
        [self setInfo:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/maxresdefault.jpg", searchResult.mediaYoutubeId]
                title:searchResult.title
             subTitle:searchResult.desc
            cellWidth:cellWidth];
    }
    else if ( [searchResult.type isEqualToString:@"destination"] ) {
        [self setInfo:searchResult.image
                title:searchResult.title
             subTitle:searchResult.desc
            cellWidth:cellWidth];
    }
    else if ( [searchResult.type isEqualToString:@"person"] ) {
        NSString *name = searchResult.personFirstName ? searchResult.personFirstName : @"";
        name = [NSString stringWithFormat:@"%@%@", name, ![name isEqualToString:@""] && searchResult.personLastName ? @" " : @""];
        name = [NSString stringWithFormat:@"%@%@", name, (searchResult.personLastName ? searchResult.personLastName : @"")];
        [self setInfo:searchResult.image
                title:searchResult.title
             subTitle:name
            cellWidth:cellWidth];
    }
}

@end
