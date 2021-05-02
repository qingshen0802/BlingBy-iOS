//
//  RoundedButton.h
//  FIX
//
//  Created by Simon Weingand on 9/11/14.
//  Copyright (c) 2014 gmc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedButton : UIButton

@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, assign) float borderWidth;
@property (nonatomic, assign) float cornerRadius;

- (void) draw;

@end
