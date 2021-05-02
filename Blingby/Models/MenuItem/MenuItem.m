//
//  MenuItem.m
//  Blingby
//
//  Created by Simon Weingand on 13/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

- (instancetype) init:(NSString*)title iconName:(NSString*)iconName controller:(UINavigationController*)controller
{
    self = [super init];
    if ( self ) {
        _menuTitle = title;
        _iconName = iconName;
        if ( iconName != nil )
            _iconSelectedName = [NSString stringWithFormat:@"%@_selected", iconName];
        _isSelected = NO;
        self.controller = controller;
    }
    return self;
}

@end
