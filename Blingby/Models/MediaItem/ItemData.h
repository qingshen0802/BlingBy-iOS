//
//  MediaItem.h
//  Blingby
//
//  Created by Simon Weingand on 22/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;
@class ItemData;

@protocol ItemDataDelegate <NSObject>

@optional
- (void) addItemData:(ItemData*)item;

@end

@interface ItemData : NSObject

@property (weak, nonatomic) id<ItemDataDelegate> delegate;

@property (nonatomic, strong) Item *item;
@property (nonatomic, assign) CGFloat relativeHeight;

@end
