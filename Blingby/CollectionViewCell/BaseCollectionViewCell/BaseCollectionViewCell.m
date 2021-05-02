//
//  BaseCollectionViewCell.m
//  Blingby
//
//  Created by Simon Weingand on 02/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "BaseCollectionViewCell.h"
#import "UILabel+UILabelDynamicHeight.h"
#import <UIImageView+WebCache.h>

#define kFontForTitleLabel [UIFont fontWithName:@"Helvetica Neue" size:IS_PAD ? 20.0f : 18.0f]
#define kFontForSubTitleLabel [UIFont fontWithName:@"Helvetica Neue" size:IS_PAD ? 14.0f : 12.0f]

@implementation BaseCollectionViewCell

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
    
}

- (void) initLabel:(UIColor*)titleBackgroundColor {
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_imageView];
    
    _titleView = [[UIView alloc] init];
    _titleView.backgroundColor = titleBackgroundColor;
    _titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_titleView];
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setFont:kFontForTitleLabel];
    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _titleLabel.numberOfLines = 0;
    [_titleView addSubview:_titleLabel];
    
    _subTitleView = [[UIView alloc] init];
    [_subTitleView setBackgroundColor:[UIColor clearColor]];
    _subTitleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_subTitleView];
    
    _subTitleLabel = [[UILabel alloc] init];
    [_subTitleLabel setBackgroundColor:[UIColor clearColor]];
    _subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_subTitleLabel setTextColor:[UIColor whiteColor]];
    [_subTitleLabel setFont:kFontForSubTitleLabel];
    _subTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _subTitleLabel.numberOfLines = 0;
    _subTitleLabel.frame = CGRectZero;
    [_subTitleView addSubview:_subTitleLabel];
    
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void) setInfo:(NSString*)imageUrl title:(NSString*)title subTitle:(NSString*)subTitle cellWidth:(CGFloat)cellWidth {
    if ( imageUrl && ![imageUrl isEqualToString:@""] ) {
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        UIImage *cellimage = [imageCache imageFromDiskCacheForKey:imageUrl];
        if ( cellimage ) {
            _imageView.image = cellimage;
        }
        else {
            [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                          placeholderImage:[UIImage imageNamed:@"placeholder"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if ( image ) {
                                         [imageCache storeImage:image forKey:imageUrl];
                                     }
                                 }];
        }
    }
    else {
        _imageView.image = nil;
    }
    
    if ( title.length > 30 ) {
        title = [NSString stringWithFormat:@"%@...", [title substringToIndex:29]];
    }
    if ( subTitle.length > 40 ) {
        subTitle = [NSString stringWithFormat:@"%@...", [subTitle substringToIndex:39]];
    }

    
    [_titleLabel setText:title];
    [_subTitleLabel setText:subTitle];
    
    [self makeLayout:cellWidth];
}

- (void) makeLayout:(CGFloat)cellWidth {
    CGSize titleSize = [_titleLabel sizeOfMultiLineLabel:cellWidth - 2 * kPaddingForLabel];
    CGSize subTitleSize = [_subTitleLabel sizeOfMultiLineLabel:cellWidth - 2 * kPaddingForLabel];
    
    [_titleLabel removeConstraints:_titleLabel.constraints];
    [_titleView removeConstraints:_titleView.constraints];
    [_subTitleLabel removeConstraints:_subTitleLabel.constraints];
    [_subTitleView removeConstraints:_subTitleView.constraints];
    
    // 1. Create a dictionary of views
    NSDictionary *viewsDictionary = @{@"imageView":_imageView,
                                      @"titleView":_titleView,
                                      @"titleLabel":_titleLabel,
                                      @"subTitleView":_subTitleView,
                                      @"subTitleLabel":_subTitleLabel};
    NSDictionary *metrics = @{@"margin":@(kPaddingForLabel/2),
                              @"padding":@(kPaddingForLabel),
                              @"titleHeight":@(titleSize.height + 1),
                              @"titleWidth":@(titleSize.width + 2 * kPaddingForLabel + 1),
                              @"subTitleHeight":@(subTitleSize.height + 1)};
    
    // 2. Define the view Position and automatically the size
    NSArray *titleView_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleView(titleHeight)]"
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
    [_titleView addConstraints:titleView_constraint_V];
    
    NSArray *titleView_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[titleView(titleWidth)]"
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
    [_titleView addConstraints:titleView_constraint_H];
    
    NSArray *subTitleView_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[subTitleView(subTitleHeight)]"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:viewsDictionary];
    [_subTitleView addConstraints:subTitleView_constraint_V];
    
    // 3. Define the views Positions
    
    // ImageView
    NSArray *imageView_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
    [self.contentView addConstraints:imageView_constraint_POS_H];
    
    NSArray *imageView_constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
    [self.contentView addConstraints:imageView_constraint_POS_V];
    
    // SubTitle View
    NSArray *subTitleView_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subTitleView]-0-|"
                                                                                       options:0
                                                                                       metrics:metrics
                                                                                         views:viewsDictionary];
    [self.contentView addConstraints:subTitleView_constraint_POS_H];
    
    NSArray *subTitleView_constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[subTitleView]-margin-|"
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:viewsDictionary];
    [self.contentView addConstraints:subTitleView_constraint_POS_V];
    
    // SubTitle Label
    NSArray *subTitleLabel_constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[subTitleLabel]-0-|"
                                                                                           options:0
                                                                                           metrics:metrics
                                                                                             views:viewsDictionary];
    [_subTitleView addConstraints:subTitleLabel_constraint_POS_V];
    
    NSArray *subTitleLabel_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[subTitleLabel]-padding-|"
                                                                                           options:0
                                                                                           metrics:metrics
                                                                                             views:viewsDictionary];
    [_subTitleView addConstraints:subTitleLabel_constraint_POS_H];

    // Title View
    NSArray *titleView_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleView]"
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:viewsDictionary];
    [self.contentView addConstraints:titleView_constraint_POS_H];
    
    NSArray *titleView_constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleView]-margin-[subTitleView]"
                                                                                     options:0
                                                                                     metrics:metrics
                                                                                       views:viewsDictionary];
    [self.contentView addConstraints:titleView_constraint_POS_V];
    
    
    // Title Label
    NSArray *titleLabel_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[titleLabel]-padding-|"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
    [_titleView addConstraints:titleLabel_constraint_POS_H];
    
    NSArray *titleLabel_constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleLabel]-0-|"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
    [_titleView addConstraints:titleLabel_constraint_POS_V];
    
}

@end
