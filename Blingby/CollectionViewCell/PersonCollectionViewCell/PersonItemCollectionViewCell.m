//
//  PersonItemCollectionViewCell.m
//  Blingby
//
//  Created by Simon Weingand on 14/03/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "PersonItemCollectionViewCell.h"
#import "Item.h"

@implementation PersonItemCollectionViewCell

- (void) setItemData:(Item *)item {
    self.item = item;
    [self setItemInfo:item.itemImage title:item.itemTitle subTitlte:item.itemDescription];
}

@end
