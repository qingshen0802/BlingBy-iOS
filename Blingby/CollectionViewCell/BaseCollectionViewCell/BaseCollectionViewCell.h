//
//  BaseCollectionCollectionViewCell.h
//  Blingby
//
//  Created by Simon Weingand on 02/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (strong, nonatomic) UIView *titleView;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIView *subTitleView;

- (void) initLabel:(UIColor*)titleBackgroundColor;
- (void) setInfo:(NSString*)imageUrl title:(NSString*)title subTitle:(NSString*)subTitle cellWidth:(CGFloat)cellWidth;
- (void) makeLayout:(CGFloat)cellWidth;

@end
