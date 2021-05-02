//
//  PersonCollectionViewCell.h
//  Blingby
//
//  Created by Simon Weingand on 27/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@class Person;

@interface PersonCollectionViewCell : BaseCollectionViewCell

@property (nonatomic, strong) Person *person;

- (void) setPerson:(Person *)person cellWidth:(CGFloat)cellWidth;

@end
