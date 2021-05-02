//
//  MediaItemsViewController.h
//  Blingby
//
//  Created by Simon Weingand on 21/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseItemDetailsViewController.h"
#import "VideoPlayerViewController.h"

#define kColumnsiPadLandscape 5
#define kColumnsiPadPortrait 4
#define kColumnsiPhoneLandscape 3
#define kColumnsiPhonePortrait 2

@class Media;
@class SearchResult;

@interface MediaItemsViewController : BaseItemDetailsViewController<VideoPlayerViewControllerDelegate>

@property (nonatomic, strong) Media *media;
@property (nonatomic, strong) SearchResult *searchResult;

- (void) setupViews:(CGRect)frame;

@end
