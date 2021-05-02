//
//  MenuItem.h
//  Blingby
//
//  Created by Simon Weingand on 13/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) NSString *iconSelectedName;
@property (nonatomic, strong) NSString *menuTitle;
@property (nonatomic, strong) UINavigationController *controller;

- (instancetype) init:(NSString*)title iconName:(NSString*)iconName controller:(UINavigationController*)controller;

@end
