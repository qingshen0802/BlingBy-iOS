//
//  DestinationItemCollectionViewCell.m
//  Blingby
//
//  Created by Simon Weingand on 21/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "DestinationItemCollectionViewCell.h"
#import "Item.h"

@implementation DestinationItemCollectionViewCell

- (void) setItemData:(Item *)item {
    self.item = item;
    [self setItemInfo:item.itemImage title:item.itemTitle subTitlte:item.itemDescription];
}

@end
