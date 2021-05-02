//
//  ProductActionButton.m
//  Blingby
//
//  Created by Simon Weingand on 16/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "ProductActionButton.h"

@implementation ProductActionButton

@synthesize borderColor;
@synthesize borderWidth;
@synthesize backgroundColor;
@synthesize cornerRadius;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        borderColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        [self draw];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        borderColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        [self draw];
    }
    return self;
}

- (void) draw {
    [super draw];
    CALayer *layer = [self layer];
    [layer setBorderColor:[borderColor CGColor]];
}

- (void)drawRect:(CGRect)rect
{
    CALayer *layer = self.layer;
    if ( self.selected || self.highlighted ) {
        [layer setBackgroundColor:[[UIColor colorWithWhite:0.9f alpha:1.0f] CGColor]];
        [self setAlpha:0.7f];
    }
    else {
        [layer setBackgroundColor:[backgroundColor CGColor]];
        [self setAlpha:1.0f];
    }
}

@end
