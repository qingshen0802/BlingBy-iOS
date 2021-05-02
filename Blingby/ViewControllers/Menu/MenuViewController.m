//
//  MenuViewController.m
//  RhinoFit
//
//  Created by Simon Weingand on 10/17/14.
//  Copyright (c) 2014 Simon Weingand. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MenuItem.h"
#import "DestinationsViewController.h"
#import "PersonsViewController.h"
#import "ViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) ViewController *mainViewController;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainViewController = (ViewController*)[((UINavigationController *)self.slidingViewController.topViewController) childViewControllers][0];
    [self initializeMenuItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Properties

- (void) initializeMenuItems {
    
//    self.slidingViewController.topViewController = self.transitionsNavigationController;
    MenuItem *musicVideosMenuItem = [[MenuItem alloc] init:@"Music Videos" iconName:@"icon_music" controller:nil];
    
    UINavigationController *destinationNavigationController = [[UINavigationController alloc] initWithRootViewController:[[DestinationsViewController alloc] init]];
    destinationNavigationController.navigationBarHidden = YES;
    MenuItem *destinationsMenuItem = [[MenuItem alloc] init:@"Destinations" iconName:@"icon_movies" controller:destinationNavigationController];
    
    UINavigationController *personNavigationController = [[UINavigationController alloc] initWithRootViewController:[[PersonsViewController alloc] init]];
    personNavigationController.navigationBarHidden = YES;
    MenuItem *experiencesMenuItem = [[MenuItem alloc] init:@"Get the Experiences" iconName:@"icon_experiences" controller:personNavigationController];
    MenuItem *meMenuItem = [[MenuItem alloc] init:@"me" iconName:@"icon_me" controller:nil];
    MenuItem *moreMenuItem = [[MenuItem alloc] init:@"More..." iconName:nil controller:nil];
    
    musicVideosMenuItem.isSelected = YES;
    
    [_musicMenu setupView:musicVideosMenuItem delegate:self];
    [_moviesMenu setupView:destinationsMenuItem delegate:self];
    [_experiencesMenu setupView:experiencesMenuItem delegate:self];
    [_meMenu setupView:meMenuItem delegate:self];
    [_moreMenu setupView:moreMenuItem delegate:self];
    
    _selectedMenu = _musicMenu;
}

#pragma mark - Menu Actions

- (void) didClickMenuItem:(MenuItemView *)menuItemView {
    [_selectedMenu select:NO];
    _selectedMenu = menuItemView;
    
    if ( menuItemView.menuItem.controller ) {
        [self.mainViewController addViewController:menuItemView.menuItem.controller];
    }
    else {
        [self.mainViewController addMainViewController];
    }
    
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    [self.slidingViewController resetTopViewAnimated:YES];
}

@end
