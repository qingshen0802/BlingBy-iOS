//
//  ProductContentViewController.m
//  Blingby
//
//  Created by Simon Weingand on 16/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "ProductContentViewController.h"
#import "AppManager.h"
#import "Item.h"
#import "Product.h"
#import "Affiliate.h"
#import "Image.h"
#import "MediaManager.h"
#import "AffiliateTableViewCell.h"
#import "ProductPopupViewController.h"
#import <SVWebViewController/SVWebViewController.h>
#import <UIImageView+WebCache.h>

#define SCROLL_IMAGE_SPACE (IS_PAD ? 4.0f : 1.0f)

@interface ProductContentViewController ()<UITableViewDataSource, UITableViewDelegate> {
    BOOL isSavedItem;
}

@property (nonatomic, strong) NSMutableArray *affiliates;
@property (nonatomic, strong) AppManager *appManager;
@property (nonatomic, strong) Product *product;
@end

@implementation ProductContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appManager = [AppManager sharedManager];
    _item = [ProductPopupViewController getItem];
    [self loadProducts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Load Products

- (void) loadProducts {
    
    [self initProducts];
    
    if ( _item ) {
        if ( _item.itemProducts && [_item.itemProducts count] ) {
            if ( _item && [_item.itemProducts count] > 0 )
                _product = [_item.itemProducts allObjects][0];
                [self setupProducts:_product];
        }
        else {
            [[MediaManager sharedManager] getItemDetails:_item.itemId callback:^(id result, NSError *error) {
                if ( result && [result isKindOfClass:[Item class]] ) {
                    _item = result;
                    if ( _item && [_item.itemProducts count] > 0 ) {
                        _product = [_item.itemProducts allObjects][0];
                        [self setupProducts:_product];
                    }
                }
                else if ( result && [result isKindOfClass:[Product class]] ) {
                    [self setupProducts:result];
                }
            }];
        }
    }
}

- (void) initProducts {
    [_likesCountLabel setText:@""];
    [_descriptionTextView setText:@""];
    [_buyButton setEnabled:NO];
    [_saveButton setEnabled:NO];
}

- (void) setupProducts:(Product*) product {
    if ( product ) {
        [self setupSaveButton:_item];
        [_descriptionTextView setText:product.productDescription];
        [self setupImageScrollView:[product.productImages allObjects]];
        if ( _affiliates ) {
            [_affiliates removeAllObjects];
        }
        else {
            _affiliates = [[NSMutableArray alloc] init];
        }
        for ( Affiliate *affiliates in [product.productAffiliates allObjects] ) {
            if ( affiliates.affiliateUrl && ![affiliates.affiliateUrl isEqualToString:@""] ) {
                [_affiliates addObject:affiliates];
            }
        }
        if ( _affiliates && [_affiliates count] > 0 && ((Affiliate*)_affiliates[0]).affiliateUrl ) {
            [_buyButton setEnabled:YES];
        }
        else {
            [_buyButton setEnabled:NO];
        }
        [_tableView reloadData];
    }
}

- (void) setupSaveButton:(Item*) item {
    if ( item ) {
        isSavedItem = NO;
        NSArray *savedItems = [_appManager getSavedItems];
        for ( Item *savedItem in savedItems ) {
            if ( [savedItem.itemId intValue] == [item.itemId intValue] ) {
                isSavedItem = YES;
                break;
            }
        }
        
        [self setProductButton];
        
        [_saveButton setEnabled:YES];
    }
}

- (void) setProductButton {
    if ( isSavedItem ) {
        [_saveButton setTitle:@"Unsave" forState:UIControlStateNormal];
    }
    else {
        [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
    }
}

- (void) setupImageScrollView:(NSArray*)images {
    if ( images && [images count] > 0 ) {
        CGFloat imageSize = _scrollView.bounds.size.height;
        _scrollView.contentSize = CGSizeMake(0, imageSize);
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        for ( int i = 1; i < [images count]; i++ ) {
            NSString *imagePath = ((Image*)images[i]).image;
            UIImage *otherimage = [imageCache imageFromDiskCacheForKey:imagePath];
            if ( otherimage ) {
                [self addImageToScrollView:otherimage];
            }
            else {
                UIImageView *imageView = [[UIImageView alloc] init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imagePath]
                             placeholderImage:nil
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        if ( image ) {
                                            [imageCache storeImage:image forKey:imagePath];
                                            [self addImageToScrollView:image];
                                        }
                                    }];
            }
        }
    }
}

- (void) addImageToScrollView:(UIImage*)image {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = image;
    
    CGSize contentSize = _scrollView.contentSize;
    CGFloat width = contentSize.height * image.size.width / image.size.height;
    imageView.frame = CGRectMake(contentSize.width + SCROLL_IMAGE_SPACE, 0, width, contentSize.height);
    [_scrollView addSubview:imageView];
    _scrollView.contentSize = CGSizeMake(contentSize.width + SCROLL_IMAGE_SPACE + width, contentSize.height);
}

#pragma mark - Actions

- (IBAction)onSave:(id)sender {
    if ( isSavedItem ) {
        [_appManager removeItem:_item];
        isSavedItem = NO;
    }
    else {
        [_appManager addItem:_item];
        isSavedItem = YES;
    }
    [self setProductButton];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationProductChanged object:nil];
}

- (IBAction)onBuy:(id)sender {
    if ( _affiliates && [_affiliates count] > 0 ) {
        Affiliate *affiliate = _affiliates[0];
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:affiliate.affiliateUrl];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ( _affiliates && [_affiliates count] > 1 ) {
        return [_affiliates count] - 1;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AffiliateTableViewCell";
    AffiliateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setAffiliate:_affiliates[indexPath.row + 1]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Affiliate *affiliate = _affiliates[indexPath.row + 1];
    if ( affiliate.affiliateUrl && ![affiliate.affiliateUrl isEqualToString:@""] ) {
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:affiliate.affiliateUrl];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

@end
