//
//  NavigationViewController.h
//  Blingby
//
//  Created by Simon Weingand on 08/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationViewController : UIViewController

@property (nonatomic, assign) BOOL isRoot;

- (void) setNavTitle:(NSString*)title;
- (void) setNavRoot:(BOOL)isRoot;

@end
