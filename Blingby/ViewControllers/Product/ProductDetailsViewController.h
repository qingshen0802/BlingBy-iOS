//
//  ProductDetailsViewController.h
//  Blingby
//
//  Created by Simon Weingand on 16/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductDetailsViewDelegate <NSObject>

@required
- (void) onClose;

@end

@interface ProductDetailsViewController : UIViewController

@property (weak, nonatomic) id<ProductDetailsViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *detailsContainer;

@end
