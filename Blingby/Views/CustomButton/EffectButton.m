//
//  EffectButton.m
//  Blingby
//
//  Created by Simon Weingand on 08/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "EffectButton.h"

@implementation EffectButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CALayer *layer = self.layer;
    if ( self.selected || self.highlighted ) {
        layer.opacity = 0.7f;
    }
    else {
        layer.opacity = 1.0f;
    }
}

-(void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

@end
