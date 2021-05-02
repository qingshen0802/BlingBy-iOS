//
//  BasePopupViewController.h
//  Blingby
//
//  Created by Simon Weingand on 04/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BasePopupViewController;

@protocol PopupViewControllerCloseDelegate <NSObject>

@optional
- (void) onClose:(BasePopupViewController*)viewController;
- (void) popViewController:(BasePopupViewController*)viewController;
- (void) backViewController:(BasePopupViewController*)viewController;

@end

@interface BasePopupViewController : UIViewController

@property (nonatomic, weak) id<PopupViewControllerCloseDelegate> delegate;

@property (nonatomic, strong) UIButton *closeButton;

- (void) addCloseButton;
- (void) addBackButton;
- (void) closeView;

@end
