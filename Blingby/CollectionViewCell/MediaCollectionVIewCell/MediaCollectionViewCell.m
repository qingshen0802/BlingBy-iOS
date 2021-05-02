//
//  MediaCollectionViewCell.m
//  Blingby
//
//  Created by Simon Weingand on 20/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "MediaCollectionViewCell.h"
#import "Media.h"
#import "UILabel+UILabelDynamicHeight.h"

@implementation MediaCollectionViewCell

- (void) initLabel {
    [self initLabel:UIColorFromRGB(0x00b8e2)];
}

- (void) setMedia:(Media *)media cellWidth:(CGFloat)cellWidth {
    _media = media;
    [self setInfo:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/maxresdefault.jpg", media.mediaYoutubeId]
            title:media.mediaTitle
         subTitle:media.mediaType
        cellWidth:cellWidth];
}

@end
