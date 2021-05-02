//
//  ProductDetailsViewController.m
//  Blingby
//
//  Created by Simon Weingand on 16/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "ProductImageViewController.h"
#import "ProductContentViewController.h"

@interface ProductDetailsViewController ()

@property (nonatomic, strong) ProductImageViewController *productImageViewController;
@property (nonatomic, strong) ProductContentViewController *productContentViewController;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ProductDetailsViewController

@synthesize productImageViewController;
@synthesize productContentViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self setupShopDetailsViews];
}

#pragma mark - Actions

- (IBAction)onClose:(id)sender {
    if ( self.delegate )
        [self.delegate onClose];
}


#pragma mark - Product Details

/**
 * Product image, content
 * Screen Rate : 0.47 0.53 (iPad)
 */

#define IMAGEVIEW 0.47f
//#define SOCIALVIEW 0.33f
#define CONTENTVIEW 0.53f

- (void) addSubViewControllers {
    if ( productImageViewController == nil )
    {
        productImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductImageViewController"];
        [self addChildViewController:productImageViewController];
        [self.detailsContainer addSubview:productImageViewController.view];
    }
    if ( productContentViewController == nil ) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.clipsToBounds = YES;
        productContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:IS_PAD ? @"ProductContentViewController" : @"ProductContentViewControlleriPhone"];
        [self addChildViewController:productContentViewController];
        [self.scrollView addSubview:productContentViewController.view];
        [self.detailsContainer addSubview:self.scrollView];
    }
}

- (void) setupShopDetailsViews {
    [self addSubViewControllers];
    
    CGRect rect = self.detailsContainer.bounds;
    CGFloat imageViewWidth = rect.size.width * IMAGEVIEW;
    CGFloat contentViewWidth=  rect.size.width * CONTENTVIEW;
    
    productImageViewController.view.frame = CGRectMake(0, 0, imageViewWidth, rect.size.height);
    self.scrollView.frame = CGRectMake(imageViewWidth, 0, contentViewWidth, rect.size.height);
    productContentViewController.view.frame = CGRectMake(0, 0, contentViewWidth, (IS_PAD ? 650 : 550));
    self.scrollView.contentSize = CGSizeMake(contentViewWidth, productContentViewController.view.frame.size.height);
}


@end
