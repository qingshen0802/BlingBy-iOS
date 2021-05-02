//
//  LoadingCollectionViewCell.m
//  Blingby
//
//  Created by Simon Weingand on 08/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "LoadingCollectionViewCell.h"

@implementation LoadingCollectionViewCell

- (id) init {
    self = [super init];
    if ( self ) {
        [self addLoadingImageView];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self addLoadingImageView];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self addLoadingImageView];
    }
    return self;
}

- (void) addLoadingImageView {
    self.backgroundColor = [UIColor clearColor];
    self.loadingImageView = [[LoadingImageView alloc] init];
    self.loadingImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.loadingImageView];
    
    // 1. Create a dictionary of views
    NSDictionary *viewsDictionary = @{@"loadingView":self.loadingImageView};
    NSDictionary *metrics = @{@"loadingViewSize" : @100};
    
    // 2. Define the view Position and automatically the size
    NSArray *loadingView_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[loadingView(loadingViewSize)]"
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
    [self.loadingImageView addConstraints:loadingView_constraint_V];
    
    NSArray *loadingView_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[loadingView(loadingViewSize)]"
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
    [self.loadingImageView addConstraints:loadingView_constraint_H];
    
    
    // 3. Define the views Positions
    
    [self.contentView addConstraint:[NSLayoutConstraint
                                          constraintWithItem:self.loadingImageView
                                          attribute:NSLayoutAttributeCenterX
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.contentView
                                          attribute:NSLayoutAttributeCenterX
                                          multiplier:1.0
                                          constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint
                                          constraintWithItem:self.loadingImageView
                                          attribute:NSLayoutAttributeCenterY
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.contentView
                                          attribute:NSLayoutAttributeCenterY
                                          multiplier:1.0
                                          constant:0.0]];

}
@end
