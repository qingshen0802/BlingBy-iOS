//
//  AppManager.m
//  Blingby
//
//  Created by Simon Weingand on 23/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "AppManager.h"
#import "Media.h"
#import "Destination.h"
#import "Person.h"
#import "Item.h"
#import "CoreDataHandler.h"

static AppManager *sharedManager = nil;

@interface AppManager()

@property (nonatomic, strong) NSMutableArray *recentMedias;
@property (nonatomic, strong) NSMutableArray *recentDestinations;
@property (nonatomic, strong) NSMutableArray *recentPersons;
@property (nonatomic, strong) NSMutableArray *savedItems;

@property (nonatomic, strong) NSMutableArray *recentMediaIds;
@property (nonatomic, strong) NSMutableArray *recentDestinationIds;
@property (nonatomic, strong) NSMutableArray *recentPersonIds;
@property (nonatomic, strong) NSMutableArray *savedItemIds;

@end

@implementation AppManager

+ (instancetype) sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AppManager alloc] init];
        [sharedManager initVariables];
    });
    
    return sharedManager;
}

- (void) initVariables {
    _recentMediaIds = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kRecentMedias]];
    _recentDestinationIds = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kRecentDestinations]];
    _recentPersonIds = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kRecentPersons]];
    _savedItemIds = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kSavedItems]];
    
    if ( _recentMediaIds == nil )
        _recentMediaIds = [[NSMutableArray alloc] init];
    
    if ( _recentDestinationIds == nil )
        _recentDestinationIds = [[NSMutableArray alloc] init];
    
    if ( _recentPersonIds == nil )
        _recentPersonIds = [[NSMutableArray alloc] init];
    
    if ( _savedItemIds == nil )
        _savedItemIds = [[NSMutableArray alloc] init];
    
    _recentMedias = [self loadRecents:kCoreDataEntityMedia idName:@"mediaId" ids:_recentMediaIds];
    _recentDestinations = [self loadRecents:kCoreDataEntityDestination idName:@"destinationId" ids:_recentDestinationIds];
    _recentPersons = [self loadRecents:kCoreDataEntityPerson idName:@"personId" ids:_recentPersonIds];
    _savedItems = [self loadRecents:kCoreDataEntityItem idName:@"itemId" ids:_savedItemIds];
}

- (NSMutableArray*) loadRecents:(NSString*)entityName idName:(NSString*)idName ids:(NSArray*)ids{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if ( ids == nil)
        return result;
    
    CoreDataHandler *coreDataHandler = [[CoreDataHandler alloc] init];
    for ( NSNumber *recentId in ids ) {
        NSArray *object = [coreDataHandler getEntityDataByID:entityName idField:idName idValue:recentId];
        if (object && [object count] > 0 )
            [result addObject:object[0]];
    }
    return result;
}

- (NSArray*) getRecentMedias {
    return _recentMedias;
}

- (NSArray*) getRecentDestinations {
    return _recentDestinations;
}

- (NSArray*) getRecentPersons {
    return _recentPersons;
}

- (NSArray *)getSavedItems {
    return _savedItems;
}

- (void) addRecentMedia:(Media*)media {
    if ( media && media.mediaId ) {
        [_recentMedias insertObject:media atIndex:0];
        [_recentMediaIds insertObject:[NSString stringWithFormat:@"%@", media.mediaId] atIndex:0];
        for ( int i = 1; i < [_recentMediaIds count]; i++ ) {
            NSNumber *recentMediaId = _recentMediaIds[i];
            if ( [media.mediaId intValue] == [recentMediaId intValue] ) {
                [_recentMediaIds removeObjectAtIndex:i];
                [_recentMedias removeObjectAtIndex:i];
                break;
            }
        }
        for ( int i = (int)[_recentMedias count] - 1; i >= kRecentMaxLimit; i-- ) {
            [_recentMedias removeObjectAtIndex:i];
            [_recentMediaIds removeObjectAtIndex:i];
        }
        [[NSUserDefaults standardUserDefaults] setObject:_recentMediaIds forKey:kRecentMedias];
    }
}

- (void) addRecentDestinations:(Destination*)destination {
    if ( destination && destination.destinationId ) {
        [_recentDestinations insertObject:destination atIndex:0];
        [_recentDestinationIds insertObject:[NSString stringWithFormat:@"%@", destination.destinationId] atIndex:0];
        for ( int i = 1; i < [_recentDestinationIds count]; i ++ ) {
            NSNumber *recentDestinationId = _recentDestinationIds[i];
            if ( [destination.destinationId intValue] == [recentDestinationId intValue] ) {
                [_recentDestinationIds removeObjectAtIndex:i];
                [_recentDestinations removeObjectAtIndex:i];
                break;
            }
        }
        for ( int i = (int)[_recentDestinations count] - 1; i >= kRecentMaxLimit; i-- ) {
            [_recentDestinations removeObjectAtIndex:i];
            [_recentDestinationIds removeObjectAtIndex:i];
        }
        [[NSUserDefaults standardUserDefaults] setObject:_recentDestinationIds forKey:kRecentDestinations];
    }
}

- (void) addRecentPersons:(Person*)person {
    if ( person && person.personId ) {
        [_recentPersons insertObject:person atIndex:0];
        [_recentPersonIds insertObject:[NSString stringWithFormat:@"%@", person.personId] atIndex:0];
        for ( int i = 1; i < [_recentPersonIds count]; i ++ ) {
            NSNumber *recentPersonId = _recentPersonIds[i];
            if ( [person.personId intValue] == [recentPersonId intValue] ) {
                [_recentPersonIds removeObjectAtIndex:i];
                [_recentPersons removeObjectAtIndex:i];
                break;
            }
        }
        for ( int i = (int)[_recentPersons count] - 1; i >= kRecentMaxLimit; i-- ) {
            [_recentPersons removeObjectAtIndex:i];
            [_recentPersonIds removeObjectAtIndex:i];
        }
        [[NSUserDefaults standardUserDefaults] setObject:_recentPersonIds forKey:kRecentPersons];
    }
}

- (void) addItem:(Item *)item {
    if ( item && item.itemId ) {
        [_savedItemIds insertObject:[NSString stringWithFormat:@"%@", item.itemId] atIndex:0];
        [_savedItems insertObject:item atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:_savedItemIds forKey:kSavedItems];
    }
}

- (void)removeItem:(Item *)item {
    if ( item && item.itemId ) {
        for ( int i = 0; i < [_savedItemIds count]; i++ ) {
            if ( [item.itemId intValue] == [_savedItemIds[i] intValue] ) {
                [_savedItemIds removeObjectAtIndex:i];
                [_savedItems removeObjectAtIndex:i];
                [[NSUserDefaults standardUserDefaults] setObject:_savedItemIds forKey:kSavedItems];
                break;
            }
        }
    }
}

@end
