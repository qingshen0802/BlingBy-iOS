//
//  DestinationCollectionViewCell.h
//  Blingby
//
//  Created by Simon Weingand on 27/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@class Destination;

@interface DestinationCollectionViewCell : BaseCollectionViewCell

@property (nonatomic, strong) Destination *destination;

- (void) setDestination:(Destination *)destination cellWidth:(CGFloat)cellWidth;

@end
