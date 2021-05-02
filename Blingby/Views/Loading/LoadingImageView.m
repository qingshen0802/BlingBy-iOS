//
//  LoadingImageView.m
//  Blingby
//
//  Created by Simon Weingand on 17/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "LoadingImageView.h"

@implementation LoadingImageView

- (id) init {
    self = [super init];
    if ( self ) {
        [self initializeLoadingImageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeLoadingImageView];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self initializeLoadingImageView];
    }
    return self;
}

- (void) initializeLoadingImageView {
    
    NSMutableArray *animationImages = [[NSMutableArray alloc] init];
    for ( int i = 1; i <= 40; i++ ) {
        [animationImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"indicator-squares%d", i]]];
    }
    
    self.animationImages = [NSArray arrayWithArray:animationImages];
    self.animationDuration = 1.0f;
    self.animationRepeatCount = 0;
    [self startAnimating];
}

@end
