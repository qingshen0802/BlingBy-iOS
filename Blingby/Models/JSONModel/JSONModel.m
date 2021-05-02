//
//  JSONModel.m
//  Blingby
//
//  Created by Simon Weingand on 17/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "JSONModel.h"

@implementation JSONModel

+ (BOOL) isNull:(NSDictionary*)json keyString:(NSString*)keyString {
    NSString *value = [json objectForKey:keyString];
    if ( value == nil
        || [value isKindOfClass:[NSNull class]]
        || [value isEqualToString:@"null"]
        || [value isEqualToString:@"(null)"]
        || [value isEqualToString:@"<null>"])
        return NO;
    else
        return YES;
}

+ (NSString*) getStringFromJSON:(NSDictionary*)json keyString:(NSString*)keyString {
    if ( [JSONModel isNull:json keyString:keyString] )
        return nil;
    else
        return [json objectForKey:keyString];
}
+ (int) getIntFromJSON:(NSDictionary*)json keyString:(NSString*)keyString {
    if ( [JSONModel isNull:json keyString:keyString] )
        return -1;
    else
        return [[json objectForKey:keyString] intValue];
}
+ (NSInteger) getNSIntegerFromJSON:(NSDictionary*)json keyString:(NSString*)keyString {
    if ( [JSONModel isNull:json keyString:keyString] )
        return NSIntegerMin;
    else
        return [[json objectForKey:keyString] integerValue];
}
+ (NSUInteger) getNSUIntegerFromJSON:(NSDictionary*)json keyString:(NSString*	)keyString {
    if ( [JSONModel isNull:json keyString:keyString] )
        return NSUIntegerMax;
    else
        return [[json objectForKey:keyString] unsignedIntegerValue];
}
+ (double) getDoubleFromJSON:(NSDictionary*)json keyString:(NSString*)keyString {
    if ( [JSONModel isNull:json keyString:keyString] )
        return 0;
    else
        return [[json objectForKey:keyString] doubleValue];
}
+ (float) getFloatFromJSON:(NSDictionary*)json keyString:(NSString*)keyString {
    if ( [JSONModel isNull:json keyString:keyString] )
        return 0;
    else
        return [[json objectForKey:keyString] intValue];
}

+ (BOOL) getBOOLFromJSON:(NSDictionary*)json keyString:(NSString*)keyString {
    if ( [JSONModel isNull:json keyString:keyString] )
        return NO;
    else
        return [[json objectForKey:keyString] boolValue];
}
+ (NSDictionary*) getDictionaryFromJSON:(NSDictionary*)json keyString:(NSString*)keyString {
    if ( [JSONModel isNull:json keyString:keyString] ||
        ![[json objectForKey:keyString] isKindOfClass:[NSDictionary class]] )
        return nil;
    else
        return [json objectForKey:keyString];
}
+ (NSArray*) getArrayFromJSON:(NSDictionary*)json keyString:(NSString*)keyString {
    if ( [JSONModel isNull:json keyString:keyString] ||
        ![[json objectForKey:keyString] isKindOfClass:[NSArray class]] )
        return nil;
    else
        return [json objectForKey:keyString];
}

@end
