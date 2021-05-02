//
//  BaseDetailsViewController.m
//  Blingby
//
//  Created by Simon Weingand on 09/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseDetailsViewController.h"

@interface BaseDetailsViewController ()

@end

@implementation BaseDetailsViewController

- (void)loadView {
    [super loadView];
    
    self.containerView = [[UIView alloc] init];
    
    [self setupViews:self.containerView];
    [self.navigationViewController setNavRoot:NO];
}

- (CGFloat) getTopViewHeight {
    CGRect rect = self.containerView.bounds;
    return rect.size.width / kVideoRatio;
}
- (CGRect) getTopViewFrame {
    return CGRectMake(0, 0, self.containerView.bounds.size.width, [self getTopViewHeight]);
}
- (CGRect) getBottomViewFrame {
    CGRect rect = self.containerView.bounds;
    CGFloat topViewHeight = [self getTopViewHeight];
    return CGRectMake(0, topViewHeight, rect.size.width, rect.size.height - topViewHeight);
}

- (void)makeBBStreamView:(NSString *)title top:(CGFloat)top {
    CGSize size = self.view.bounds.size;
    
    // Make "bbStream" view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, top, size.width, kCollectionViewSectionHeaderHeight)];
    view.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kPaddingForLabel, 0, view.frame.size.width - 2 * kPaddingForLabel, view.frame.size.height)];
    label.text = title;
    [self.navigationViewController setNavTitle:title];
    label.font = kCollectionViewSectionHeaderFont;
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(size.width - kPaddingForLabel - kCollectionViewSectionHeaderHeight - kPaddingForLabel, kPaddingForLabel / 2, (kCollectionViewSectionHeaderHeight - kPaddingForLabel) * 200 / 152, kCollectionViewSectionHeaderHeight - kPaddingForLabel)];
    imageView.image = [UIImage imageNamed:@"icon-stream"];
    [view addSubview:imageView];
    
    [self.containerView addSubview:view];
}

@end
