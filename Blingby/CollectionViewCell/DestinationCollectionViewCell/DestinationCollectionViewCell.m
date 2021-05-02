//
//  DestinationCollectionViewCell.m
//  Blingby
//
//  Created by Simon Weingand on 27/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "DestinationCollectionViewCell.h"
#import "Destination.h"

@implementation DestinationCollectionViewCell

- (void) initLabel {
    [self initLabel:UIColorFromRGB(0xffd300)];
}

- (void) setDestination:(Destination *)destination cellWidth:(CGFloat)cellWidth {
    _destination = destination;
    if ( destination ) {
        [self setInfo:destination.destinationImage
                title:destination.destinationTitle
             subTitle:destination.destinationDescription
            cellWidth:cellWidth];
    }
}

@end
