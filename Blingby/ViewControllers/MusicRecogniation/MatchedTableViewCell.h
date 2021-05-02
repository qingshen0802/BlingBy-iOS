//
//  MatchedTableViewCell.h
//  Blingby
//
//  Created by Simon Weingand on 23/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GnDataModel;

@interface MatchedTableViewCell : UITableViewCell

@property (nonatomic, strong) GnDataModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;

- (void) setDataModel:(GnDataModel*)model;

@end
