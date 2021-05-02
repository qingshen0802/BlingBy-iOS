//
//  RecentCollectionReusableView.m
//  Blingby
//
//  Created by Simon Weingand on 27/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "CollectionHeaderReusableView.h"

@implementation CollectionHeaderReusableView

- (instancetype)init {
    self = [super init];
    if ( self ) {
        [self initLabel];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self initLabel];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self initLabel];
    }
    return self;
}

- (void) initLabel {
    self.backgroundColor = BLINGBY_COLOR4;
    self.headerLabel = [[UILabel alloc] init];
    self.headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerLabel.font = kCollectionViewSectionHeaderFont;
    self.headerLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.headerLabel];
    
    // 1. Create a dictionary of views
    NSDictionary *viewsDictionary = @{@"headerLabel":self.headerLabel};
    NSDictionary *metrics = @{@"margin":@(kPaddingForLabel/2)};
    
    // 2. Define the views Positions
    
    // HeaderLabel
    NSArray *headerLabel_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[headerLabel]-margin-|"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
    [self addConstraints:headerLabel_constraint_POS_H];
    
    NSArray *headerLabel_constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[headerLabel]-margin-|"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
    [self addConstraints:headerLabel_constraint_POS_V];
}

- (void)setHeaderTitle:(NSString*)title {
    _headerLabel.text = title;
}

@end
