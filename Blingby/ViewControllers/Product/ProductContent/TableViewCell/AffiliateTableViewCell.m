//
//  AffiliateTableViewCell.m
//  Blingby
//
//  Created by Simon Weingand on 26/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "AffiliateTableViewCell.h"
#import "Affiliate.h"

@implementation AffiliateTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAffiliate:(Affiliate *)affiliate {
    _affiliate = affiliate;
    [_affiliateNameLabel setText:affiliate.affiliateTitle];
}

@end
