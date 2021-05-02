//
//  SocialButton.h
//  Blingby
//
//  Created by Simon Weingand on 06/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialButton : UIView

@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, assign) float borderWidth;
@property (nonatomic, assign) float cornerRadius;
@property (nonatomic, assign) BOOL isPressed;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void) draw;

@end
