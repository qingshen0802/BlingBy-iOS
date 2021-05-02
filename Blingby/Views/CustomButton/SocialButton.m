//
//  SocialButton.m
//  Blingby
//
//  Created by Simon Weingand on 06/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "SocialButton.h"

@implementation SocialButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize:frame];
        [self draw];
    }
    return self;
}

- (void) initialize:(CGRect)frame {
    _borderWidth = -1.0f;
    _cornerRadius = 4.0f;
    _borderColor = [UIColor whiteColor];
    _backgroundColor = [UIColor clearColor];
    
    CGFloat margin = IS_PAD ? 8 : 4;
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, frame.size.height - margin * 2, frame.size.height - margin * 2)];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.titleLabel.font = [UIFont fontWithName:BLINGBY_INPUTFIELD_FONT size:BLINGBY_INPUTFIELD_FONT_SIZE];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
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

- (void)touchEffect
{
    CALayer *layer = self.layer;
    if ( _isPressed == YES ) {
        layer.opacity = 0.5f;
    }
    else {
        layer.opacity = 1.0f;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _isPressed = YES;
    [super touchesBegan:touches withEvent:event];
    [self touchEffect];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _isPressed = NO;
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
    [self touchEffect];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    _isPressed = NO;
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
    [self touchEffect];
}

- (void) draw {
    
    CALayer *layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:_cornerRadius];
    if ( _backgroundColor == nil ) {
        [layer setBackgroundColor:[[UIColor clearColor] CGColor]];
    } else {
        [layer setBackgroundColor:[_backgroundColor CGColor]];
    }
    
    if ( _borderWidth < 0 ) {
        [layer setBorderWidth:1.0f];
    }
    else {
        [layer setBorderWidth:_borderWidth];
    }
    
    if ( _borderColor == nil ) {
        [layer setBorderColor:[[UIColor whiteColor] CGColor]];
    } else {
        [layer setBorderColor:[_borderColor CGColor]];
    }
}

@end
