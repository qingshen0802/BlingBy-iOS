//
//  BaseBlurViewController.m
//  Blingby
//
//  Created by Simon Weingand on 04/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseBlurViewController.h"
#import "UIImage+ImageEffects.h"
#import <GPUImage/GPUImage.h>

@interface BaseBlurViewController ()

@end

@implementation BaseBlurViewController

@synthesize backgroundView;
@synthesize blurredBgImage;
@synthesize blurMask;
@synthesize contentView;

static UIImage *backgroundImage;

+ (UIImage*) getBackgroundImage {
    return backgroundImage;
}
- (void)initViews
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    backgroundView = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:backgroundView];
    
    blurredBgImage = [[UIImageView alloc] initWithFrame:rect];
    blurredBgImage.contentMode = UIViewContentModeScaleAspectFill;
    if ( backgroundImage == nil ) {
        backgroundImage = [self blurWithImageEffects:[UIImage imageNamed:@"intro-under-blur"]];
    }
    blurredBgImage.image = backgroundImage;
    [self.view addSubview:blurredBgImage];
    
    blurMask = [[UIView alloc] initWithFrame:rect];
    blurMask.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:blurMask];
    
    contentView = [[UIView alloc] initWithFrame:rect];
    contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentView];
    
    blurredBgImage.layer.mask = blurMask.layer;
}

- (void) backgroundBlur {
    // Blurred with UIImage+ImageEffects
    blurredBgImage.image = [self blurWithImageEffects:[self takeSnapshotOfView:self.backgroundView]];
    
    // Blurred with Core Image
    // blurredBgImage.image = [self blurWithCoreImage:[self takeSnapshotOfView:[self createContentView]]];
    
    // Blurring with GPUImage framework
    // blurredBgImage.image = [self blurWithGPUImage:[self takeSnapshotOfView:[self createContentView]]];
    
    blurredBgImage.layer.mask = blurMask.layer;
}

- (void) showBluredImage {
    blurMask.alpha = 1.0f;
    blurredBgImage.alpha = 1.0f;
}

- (void) hideBluredImage {
    blurMask.alpha = 0.0f;
    blurredBgImage.alpha = 0.0f;
}

- (UIImage *)takeSnapshotOfView:(UIView *)view
{
    
    CGFloat reductionFactor = 1;
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width/reductionFactor, view.frame.size.height/reductionFactor));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width/reductionFactor, view.frame.size.height/reductionFactor) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(UIImage *)captureScreenInRect:(UIView *)view {
    CALayer *layer;
    layer = view.layer;
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextClipToRect (UIGraphicsGetCurrentContext(),rect);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

-(UIImage *) takeAScreenShot {
    // here i am taking screen shot of whole UIWindow, but you can have the screenshot of any individual UIViews, Tableviews  . so in that case just use  object of your UIViews instead of  keyWindow.
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) // checking for Retina display
    {
        UIGraphicsBeginImageContextWithOptions(keyWindow.bounds.size, YES, [UIScreen mainScreen].scale);
    //if this method is not used for Retina device, image will be blurr.
    }
    else
    {
        UIGraphicsBeginImageContext(keyWindow.bounds.size);
    }
    [keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // now storing captured image in Photo Library of device
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

    return image;
}

- (UIImage *)blurWithImageEffects:(UIImage *)image
{
    return [image applyBlurWithRadius:60 tintColor:[UIColor colorWithRed:0 green:9.0 / 255.0 blue:63.0 / 255.0 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil];
}

- (UIImage *)blurWithCoreImage:(UIImage *)sourceImage
{
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    // Apply Affine-Clamp filter to stretch the image so that it does not look shrunken when gaussian blur is applied
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:inputImage forKey:@"inputImage"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    // Apply gaussian blur filter with radius of 30
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:@30 forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[inputImage extent]];
    
    // Set up output context.
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.view.frame.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, self.view.frame, cgImage);
    
    // Apply white tint
    CGContextSaveGState(outputContext);
    CGContextSetFillColorWithColor(outputContext, [UIColor colorWithWhite:1 alpha:0.2].CGColor);
    CGContextFillRect(outputContext, self.view.frame);
    CGContextRestoreGState(outputContext);
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (UIImage *)blurWithGPUImage:(UIImage *)sourceImage
{
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.blurRadiusInPixels = 30.0;
    
//    GPUImageBoxBlurFilter *blurFilter = [[GPUImageBoxBlurFilter alloc] init];
//    blurFilter.blurRadiusInPixels = 20.0;

//    GPUImageiOSBlurFilter *blurFilter = [[GPUImageiOSBlurFilter alloc] init];
//    blurFilter.saturation = 1.5;
//    blurFilter.blurRadiusInPixels = 30.0;
    
    return [blurFilter imageByFilteringImage: sourceImage];
}

@end
