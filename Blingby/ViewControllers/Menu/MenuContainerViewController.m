//
//  MenuContainerViewController.m
//  Blingby
//
//  Created by Simon Weingand on 13/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "MenuContainerViewController.h"

@interface MenuContainerViewController ()

@end

@implementation MenuContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UINavigationController *menuNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuNavitationController"];
    CGRect rect = self.view.bounds;
//    rect.size.width = 276;
    menuNavigationController.view.frame = rect;
    
    [self addChildViewController:menuNavigationController];
    [self.view addSubview:menuNavigationController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
