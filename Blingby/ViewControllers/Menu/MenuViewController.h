//
//  MenuViewController.h
//  RhinoFit
//
//  Created by Simon Weingand on 10/17/14.
//  Copyright (c) 2014 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItemView.h"

@interface MenuViewController : UIViewController<MenuItemViewDelegate>

@property (nonatomic, strong) MenuItemView *selectedMenu;
@property (weak, nonatomic) IBOutlet MenuItemView *homeMenu;
@property (weak, nonatomic) IBOutlet MenuItemView *musicMenu;
@property (weak, nonatomic) IBOutlet MenuItemView *moviesMenu;
@property (weak, nonatomic) IBOutlet MenuItemView *experiencesMenu;
@property (weak, nonatomic) IBOutlet MenuItemView *meMenu;
@property (weak, nonatomic) IBOutlet MenuItemView *moreMenu;

@end
