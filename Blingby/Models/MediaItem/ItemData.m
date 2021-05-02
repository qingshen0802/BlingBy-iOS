//
//  MediaItem.m
//  Blingby
//
//  Created by Simon Weingand on 22/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "ItemData.h"
#import "Item.h"
#import <UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageDownloader.h>

@implementation ItemData

- (void) setItem:(Item *)item {
    _item = item;
    _relativeHeight = 1.0f;
    if ( item.itemImage && ![item.itemImage isEqualToString:@""] && ![item.itemImage isEqualToString:kBlingbyHostUrl] ) {
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        UIImage *itemimage = [imageCache imageFromDiskCacheForKey:item.itemImage];
        if ( itemimage ) {
            [self addItemData:itemimage];
        }
        else {
            [SDWebImageManager.sharedManager
                      downloadImageWithURL:[NSURL URLWithString:item.itemImage]
                      options:0
                      progress:nil
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                          if ( error ) {
                              [self addItemData:nil];
                          }
                          else {
                              [imageCache storeImage:image forKey:item.itemImage];
                              [self addItemData:image];
                          }
                      }];
        }
    }
    else {
        [self addItemData:nil];
    }
}

- (void) addItemData:(UIImage*)image {
    if ( image == nil ) {
        _relativeHeight = 1.0f;
    }
    else {
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        _relativeHeight = (height + kPaddingForLabel) / (width + kPaddingForLabel);
    }
    if ( self.delegate ) {
        [self.delegate addItemData:self];
    }
}

@end
