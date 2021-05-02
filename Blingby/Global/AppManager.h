//
//  AppManager.h
//  Blingby
//
//  Created by Simon Weingand on 23/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Media;
@class Destination;
@class Person;
@class Item;

@interface AppManager : NSObject

+ (instancetype) sharedManager;

- (NSArray*) getRecentMedias;
- (NSArray*) getRecentDestinations;
- (NSArray*) getRecentPersons;
- (NSArray*) getSavedItems;
- (void) addRecentMedia:(Media*)media;
- (void) addRecentDestinations:(Destination*)destination;
- (void) addRecentPersons:(Person*)person;
- (void) addItem:(Item*)item;
- (void) removeItem:(Item*)item;

@end
