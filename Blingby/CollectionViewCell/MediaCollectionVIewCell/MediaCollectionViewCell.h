//
//  MediaCollectionViewCell.h
//  Blingby
//
//  Created by Simon Weingand on 20/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@class Media;

@interface MediaCollectionViewCell : BaseCollectionViewCell

@property (nonatomic, strong) Media *media;

- (void) setMedia:(Media *)media cellWidth:(CGFloat)cellWidth;

@end
