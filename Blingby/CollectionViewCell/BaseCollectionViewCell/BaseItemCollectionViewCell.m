//
//  BaseDetailsCollectionViewCell.m
//  Blingby
//
//  Created by Simon Weingand on 02/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseItemCollectionViewCell.h"
#import "UILabel+UILabelDynamicHeight.h"
#import "Item.h"
#import <UIImageView+WebCache.h>

#define kFontForExperienceTextLabel [UIFont fontWithName:@"Helvetica-Bold" size:IS_PAD ? 20.0f : 16.0f]
#define kFontForTitleLabel [UIFont fontWithName:@"Helvetica-Bold" size:IS_PAD ? 16.0f : 12.0f]

@implementation BaseItemCollectionViewCell

- (CGFloat) getCellWidth {
    static CGFloat cellWidth;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        cellWidth = (screenSize.width / kItemCellCountPerRow) - kPaddingForLabel;
    });
    
    return cellWidth;
}
- (id) init {
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
    _containerView = [[UIView alloc] init];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _imageView = [[UIImageView alloc] init];
    [_imageView setBackgroundColor:[UIColor colorWithWhite:0.3f alpha:0.5f]];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addSubview:_imageView];
    
    _experienceContainerView = [[UIView alloc] init];
    [_experienceContainerView setBackgroundColor:UIColorFromRGB(0x00aee4)];
    _experienceContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _experienceTextLabel = [[UILabel alloc] init];
    [_experienceTextLabel setBackgroundColor:[UIColor clearColor]];
    _experienceTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_experienceTextLabel setTextColor:[UIColor whiteColor]];
    [_experienceTextLabel setFont:kFontForExperienceTextLabel];
    _experienceTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _experienceTextLabel.numberOfLines = 0;
    _experienceTextLabel.frame = CGRectZero;
    [_experienceContainerView addSubview:_experienceTextLabel];
    [_containerView addSubview:_experienceContainerView];
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setFont:kFontForTitleLabel];
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 0;
    _titleLabel.frame = CGRectZero;
    
    [_containerView addSubview:_titleLabel];
    
    [self.contentView addSubview:_containerView];
    [self setBackgroundColor:[UIColor clearColor]];
    self.contentView.clipsToBounds = YES;
}

- (void) setItemData:(Item *)item {
    
}
- (void) setItemInfo:(NSString*)imageUrl title:(NSString*)title subTitlte:(NSString*)subTitle {
    if ( imageUrl && ![imageUrl isEqualToString:@""] ) {
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        UIImage *itemimage = [imageCache imageFromDiskCacheForKey:imageUrl];
        if ( itemimage ) {
            _imageView.image = itemimage;
        }
        else {
            [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                          placeholderImage:nil
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if ( image ) {
                                         [imageCache storeImage:image forKey:imageUrl toDisk:YES];
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
    [_experienceTextLabel setText:subTitle];
    
    [self resizeLabels];
}

- (void) resizeLabels {
    CGSize titleSize = [_titleLabel sizeOfMultiLineLabel:[self getCellWidth] - 2 * kPaddingForLabel];
    CGSize experienceSize = [_experienceTextLabel sizeOfMultiLineLabel:[self getCellWidth] - 2 * kPaddingForLabel];
    
    [_containerView removeConstraints:_containerView.constraints];
    [self.contentView removeConstraints:self.contentView.constraints];
    [_imageView removeConstraints:_imageView.constraints];
    [_titleLabel removeConstraints:_titleLabel.constraints];
    [_experienceTextLabel removeConstraints:_experienceTextLabel.constraints];
    [_experienceContainerView removeConstraints:_experienceContainerView.constraints];
    
    
    // 1. Create a dictionary of views
    NSDictionary *viewsDictionary = @{@"container":_containerView,
                                      @"imageView":_imageView,
                                      @"experienceContainerView":_experienceContainerView,
                                      @"experienceTextLabel":_experienceTextLabel,
                                      @"titleLabel":_titleLabel};
    NSDictionary *metrics = @{@"margin":@(kPaddingForLabel/2),
                              @"padding":@(kPaddingForLabel),
                              @"experienceHeight":@(experienceSize.height + 1),
                              @"experienceWidth":@(experienceSize.width + 2 * kPaddingForLabel + 1),
                              @"titleHeight":@(titleSize.height + 1)};
    
    // 2. Define the view Position and automatically the size
    NSArray *titleView_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel(titleHeight)]"
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
    [_titleLabel addConstraints:titleView_constraint_V];
    
    NSArray *experienceView_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[experienceContainerView(experienceWidth)]"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:viewsDictionary];
    [_experienceContainerView addConstraints:experienceView_constraint_H];
    
    NSArray *experienceView_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[experienceContainerView(experienceHeight)]"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:viewsDictionary];
    [_experienceContainerView addConstraints:experienceView_constraint_V];
    
    // 3. Define the views Positions
    
    // Container
    NSArray *containerView_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[container]-margin-|"
                                                                                      options:0
                                                                                      metrics:metrics
                                                                                        views:viewsDictionary];
    [self.contentView addConstraints:containerView_constraint_POS_H];
    
    NSArray *containerView_constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[container]-margin-|"
                                                                                      options:0
                                                                                      metrics:metrics
                                                                                        views:viewsDictionary];
    [self.contentView addConstraints:containerView_constraint_POS_V];
    
    // ImageView
    NSArray *imageView_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
    [_containerView addConstraints:imageView_constraint_POS_H];
    
    NSArray *imageView_constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
    [_containerView addConstraints:imageView_constraint_POS_V];
    
    // Title Label
    NSArray *titleView_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[titleLabel]-padding-|"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
    [_containerView addConstraints:titleView_constraint_POS_H];
    
    NSArray *titleView_constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel]-padding-|"
                                                                                  options:0
                                                                                  metrics:metrics
                                                                                    views:viewsDictionary];
    [_containerView addConstraints:titleView_constraint_POS_V];
    
    
    // Experience View
    NSArray *experienceView_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[experienceContainerView]"
                                                                                       options:0
                                                                                       metrics:metrics
                                                                                         views:viewsDictionary];
    [_containerView addConstraints:experienceView_constraint_POS_H];
    
    NSArray *experienceView_constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[experienceContainerView]-padding-[titleLabel]"
                                                                                       options:0
                                                                                       metrics:metrics
                                                                                         views:viewsDictionary];
    [_containerView addConstraints:experienceView_constraint_POS_V];
    
    // Experience Text
    NSArray *experienceTextView_constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[experienceTextLabel]-0-|"
                                                                                           options:0
                                                                                           metrics:metrics
                                                                                             views:viewsDictionary];
    [_experienceContainerView addConstraints:experienceTextView_constraint_POS_V];
    
    NSArray *experienceTextView_constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[experienceTextLabel]-padding-|"
                                                                                           options:0
                                                                                           metrics:metrics
                                                                                             views:viewsDictionary];
    [_experienceContainerView addConstraints:experienceTextView_constraint_POS_H];
}

@end
