//
//  BaseDetailsCollectionViewCell.h
//  Blingby
//
//  Created by Simon Weingand on 02/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface BaseItemCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) Item *item;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIView *containerView;
@property (nonatomic, strong) UIView *experienceContainerView;
@property (nonatomic, strong) UILabel *experienceTextLabel;
@property (nonatomic, strong) UILabel *titleLabel;

- (void) setItemData:(Item *)item;
- (void) setItemInfo:(NSString*)imageUrl title:(NSString*)title subTitlte:(NSString*)subTitle;

@end
