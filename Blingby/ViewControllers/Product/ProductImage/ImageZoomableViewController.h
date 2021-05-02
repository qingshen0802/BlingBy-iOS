//
//  ImageZoomableViewController.h
//  Blingby
//
//  Created by Simon Weingand on 16/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageZoomableViewControllerDelegate <NSObject>

@required
- (void) closeImageZoomable;

@end

@interface ImageZoomableViewController : UIViewController

@property (nonatomic, weak) id<ImageZoomableViewControllerDelegate> delegate;

@property (nonatomic, assign) CGRect originRect;
@property (nonatomic, strong) UIImage *image;

@end
