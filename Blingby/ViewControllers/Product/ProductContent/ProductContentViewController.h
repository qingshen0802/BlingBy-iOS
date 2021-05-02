//
//  ProductContentViewController.h
//  Blingby
//
//  Created by Simon Weingand on 16/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedButton.h"

@class Item;

@interface ProductContentViewController : UIViewController

@property (nonatomic, strong) Item *item;

@property (weak, nonatomic) IBOutlet RoundedButton *saveButton;
@property (weak, nonatomic) IBOutlet RoundedButton *buyButton;
@property (weak, nonatomic) IBOutlet UIView *productDetailsView;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
