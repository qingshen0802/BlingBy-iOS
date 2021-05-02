//
//  ProductPopupViewController.h
//  Blingby
//
//  Created by Simon Weingand on 15/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseBlurViewController.h"

@class Item;

@interface ProductPopupViewController : BaseBlurViewController

+ (void) setItem:(Item*) item;
+ (Item*) getItem;
- (void) showProductDetails:(UIViewController*)viewController item:(Item*)item;

@end
