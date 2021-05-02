//
//  RoundedButton.m
//  FIX
//
//  Created by Simon Weingand on 9/11/14.
//  Copyright (c) 2014 gmc. All rights reserved.
//

#import "RoundedButton.h"

@implementation RoundedButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _borderWidth = -1.0f;
        _cornerRadius = 4.0f;
        _borderColor = [UIColor whiteColor];
        [self draw];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        _borderWidth = -1.0f;
        _cornerRadius = 4.0f;
        _borderColor = [UIColor whiteColor];
        [self draw];
    }
    return self;
}

- (void) setBorderWidth:(float)borderWidth {
    _borderWidth = borderWidth;
    [self draw];
}

- (void) setCornerRadius:(float)cornerRadius {
    _cornerRadius = cornerRadius;
    [self draw];
}

- (void) setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self draw];
}

- (void) setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self draw];
}


-(void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void) draw {
    CALayer *layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:_cornerRadius];
    if ( _backgroundColor == nil ) {
        [layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    } else {
        [layer setBackgroundColor:[_backgroundColor CGColor]];
    }
    
    if ( _borderWidth < 0 ) {
        [layer setBorderWidth:0.0f];
    }
    else {
        [layer setBorderWidth:_borderWidth];
    }
    
    [layer setBorderColor:[_backgroundColor CGColor]];
}

- (void)drawRect:(CGRect)rect
{
    CALayer *layer = self.layer;
    if ( self.selected || self.highlighted ) {
        [layer setBorderColor:[_borderColor CGColor]];
        [self setAlpha:0.7f];
    }
    else {
        [layer setBorderColor:[_backgroundColor CGColor]];
        [self setAlpha:1.0f];
    }
}

@end
