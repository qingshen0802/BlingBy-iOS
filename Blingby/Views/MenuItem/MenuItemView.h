//
//  MenuItemView.h
//  Blingby
//
//  Created by Simon Weingand on 13/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@class MenuItemView;

@protocol MenuItemViewDelegate <NSObject>

@required
- (void) didClickMenuItem:(MenuItemView*)menuItemView;

@end

@interface MenuItemView : UIView

@property (nonatomic, weak) id<MenuItemViewDelegate> delegate;

@property (nonatomic, strong) MenuItem *menuItem;

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIImageView *menuIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *menuTitleLabel;

@property (nonatomic, assign) BOOL isPressed;

- (void) setupView:(MenuItem*) menu delegate:(id<MenuItemViewDelegate>)delegate;
- (void) select:(BOOL)isSelected;

@end
