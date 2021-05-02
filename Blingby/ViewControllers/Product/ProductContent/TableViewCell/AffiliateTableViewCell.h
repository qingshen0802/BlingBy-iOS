//
//  AffiliateTableViewCell.h
//  Blingby
//
//  Created by Simon Weingand on 26/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Affiliate;

@interface AffiliateTableViewCell : UITableViewCell

@property (nonatomic, strong) Affiliate *affiliate;

@property (weak, nonatomic) IBOutlet UILabel *affiliateNameLabel;

@end
