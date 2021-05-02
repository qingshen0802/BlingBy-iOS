//
//  ProductPopupViewController.m
//  Blingby
//
//  Created by Simon Weingand on 15/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "ProductPopupViewController.h"
#import "ProductDetailsViewController.h"
#import "Item.h"

#define POPUP_LAYOUT_MARGIN (IS_PAD ? 8.0f : 4.0f)
#define POPUP_TIME_INTERVAL 1.0f

@interface ProductPopupViewController ()<ProductDetailsViewDelegate>

@property (nonatomic, strong) ProductDetailsViewController *productDetailsViewController;

@end

@implementation ProductPopupViewController

@synthesize productDetailsViewController;


static Item *currentItem;

+ (void) setItem:(Item*) item {
    currentItem = item;
}

+ (Item*) getItem {
    return currentItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void) showProductDetails:(UIViewController*)viewController item:(Item*)item {
    [ProductPopupViewController setItem:item];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    self.view.frame = window.bounds;
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
    [self showBluredImage];
    self.blurredBgImage.alpha = 0.7;
    self.contentView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    [self showDetailViewController];
}

#pragma mark - Product Details

- (void) addProductDetailsViewController {
    if ( productDetailsViewController == nil ) {
        productDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailsViewController"];
        productDetailsViewController.delegate = self;
        [self addChildViewController:productDetailsViewController];
        [self.view addSubview:productDetailsViewController.view];
    }
}

- (void) showDetailViewController {
    
    [self addProductDetailsViewController];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat popupViewWidth = rect.size.width - 2 * POPUP_LAYOUT_MARGIN;
    CGFloat popupViewHeight = rect.size.height - 115;
    productDetailsViewController.view.frame = CGRectMake(POPUP_LAYOUT_MARGIN,
                                                         rect.size.height,
                                                         popupViewWidth,
                                                         popupViewHeight);
    [self.view setAlpha:0.0f];
//    self.view.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.5f];
    
    [UIView animateWithDuration:POPUP_TIME_INTERVAL
                     animations:^{
                         [self.view setAlpha:1.0f];
                         productDetailsViewController.view.frame = CGRectMake(POPUP_LAYOUT_MARGIN,
                                                                              rect.size.height - popupViewHeight,
                                                                              popupViewWidth,
                                                                              popupViewHeight);
                     }];
}

- (void) hideDetailViewController {
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat popupViewWidth = rect.size.width - 2 * POPUP_LAYOUT_MARGIN;
    CGFloat popupViewHeight = rect.size.height - 115;
    productDetailsViewController.view.frame = CGRectMake(POPUP_LAYOUT_MARGIN,
                                                         rect.size.height - popupViewHeight,
                                                         popupViewWidth,
                                                         popupViewHeight);
    [self.view setAlpha:1.0f];
    
    [UIView animateWithDuration:POPUP_TIME_INTERVAL
                     animations:^{
                         [self.view setAlpha:0.0f];
                         productDetailsViewController.view.frame = CGRectMake(POPUP_LAYOUT_MARGIN,
                                                                              rect.size.height,
                                                                              popupViewWidth,
                                                                              popupViewHeight);
                     }
                     completion:^(BOOL finished) {
                         [productDetailsViewController removeFromParentViewController];
                         [productDetailsViewController.view removeFromSuperview];
                         productDetailsViewController = nil;
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationProductDetailsClosed object:nil];
                     }];
}

#pragma mark - ProductDetailsViewDelegate

- (void) onClose {
    [self hideDetailViewController];
}

@end
