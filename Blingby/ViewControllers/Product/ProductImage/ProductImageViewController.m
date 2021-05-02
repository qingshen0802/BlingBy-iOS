//
//  ProductImageViewController.m
//  Blingby
//
//  Created by Simon Weingand on 16/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "ProductImageViewController.h"
#import "ImageZoomableViewController.h"
#import "AppDelegate.h"

#import "ProductPopupViewController.h"
#import "Item.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import <UIImageView+WebCache.h>

@interface ProductImageViewController ()

@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UIImage *productImage;

@property (nonatomic, strong) ImageZoomableViewController *imageZoomableViewController;

@end

@implementation ProductImageViewController

@synthesize productImageView;
@synthesize productImage;
@synthesize imageZoomableViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setImageTapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self showImage];
}

- (void) showImage {
    
    productImageView = [[UIImageView alloc] init];
    [productImageView setUserInteractionEnabled:YES];
    [self.scrollView addSubview:productImageView];
    
    Item *item = [ProductPopupViewController getItem];
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    productImage = [imageCache imageFromDiskCacheForKey:item.itemImage];
    if ( productImage ) {
        productImageView.image = productImage;
        [self setupProductImageView];
    }
    else {
        __weak typeof(self) weakSelf = self;
        [productImageView sd_setImageWithURL:[NSURL URLWithString:item.itemImage]
                     placeholderImage:[UIImage imageNamed:@"placeholder"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                if ( image ) {
                                    [imageCache storeImage:image forKey:item.itemImage];
                                    [weakSelf setupProductImageView];
                                }
                            }];
    }
}

- (void) setupProductImageView {
    if ( productImage && productImageView ) {
        CGRect scrollRect = _scrollView.bounds;
        CGSize imageSize = productImage.size;
        CGFloat width = scrollRect.size.width;
        CGFloat height = imageSize.height * width / imageSize.width;
        productImageView.frame = CGRectMake(0, 0, width, height);
        productImageView.image = productImage;
        
        [self.scrollView setContentSize:CGSizeMake(width, height)];
        
        [self setImageTapGesture];
    }
}

- (void) setImageTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [productImageView addGestureRecognizer:tapGesture];
}

- (void) tapImage:(UIGestureRecognizer*) recognizer {
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = productImage;
    imageInfo.referenceRect = productImageView.frame;//CGRectMake(-rect.origin.x, -rect.origin.y, rect.size.width, rect.size.height);
    imageInfo.referenceView = productImageView.superview;
    imageInfo.referenceContentMode = UIViewContentModeScaleAspectFit;
    imageInfo.referenceCornerRadius = 0;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
    // Present the view controller.
    [imageViewer showFromViewController:self.parentViewController.parentViewController transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

@end
