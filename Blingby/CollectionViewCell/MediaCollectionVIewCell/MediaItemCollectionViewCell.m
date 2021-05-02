//
//  MediaItemCollectionViewCell.m
//  Blingby
//
//  Created by Simon Weingand on 21/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "MediaItemCollectionViewCell.h"
#import "Item.h"

@implementation MediaItemCollectionViewCell

- (void) setItemData:(Item *)item {
    self.item = item;
    [self setItemInfo:item.itemImage title:item.itemTitle subTitlte:item.itemExperienceText];
}


@end
