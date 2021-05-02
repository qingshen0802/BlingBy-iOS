//
//  MatchedTableViewCell.m
//  Blingby
//
//  Created by Simon Weingand on 23/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "MatchedTableViewCell.h"
#import "GnDataModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MatchedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setDataModel:(GnDataModel*)model {
    self.model = model;
    if ( model ) {
        if ( model.albumImageData ) {
            self.albumImageView.image = [UIImage imageWithData:model.albumImageData];
        }
        else {
            self.albumImageView.image = [UIImage imageNamed:@"placeholder"];
        }
        self.titleLabel.text = model.trackTitle ? model.trackTitle : model.albumTitle;
        self.artistLabel.text = model.trackArtist ? model.trackArtist : model.albumArtist;
    }
}

@end
