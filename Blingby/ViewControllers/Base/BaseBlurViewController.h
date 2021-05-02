//
//  BaseBlurViewController.h
//  Blingby
//
//  Created by Simon Weingand on 04/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseBlurViewController : UIViewController

@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *blurMask;
@property (strong, nonatomic) UIImageView *blurredBgImage;
@property (strong, nonatomic) UIView *contentView;

+ (UIImage*) getBackgroundImage;

- (void)initViews;

-(UIImage *) takeAScreenShot;
-(UIImage *)captureScreenInRect:(UIView *)view;
- (UIImage *)takeSnapshotOfView:(UIView *)view;
- (UIImage *)blurWithImageEffects:(UIImage *)image;
- (UIImage *)blurWithCoreImage:(UIImage *)sourceImage;
- (UIImage *)blurWithGPUImage:(UIImage *)sourceImage;

- (void) backgroundBlur;
- (void) showBluredImage;
- (void) hideBluredImage;

@end
