//
//  JSONModel.h
//  Blingby
//
//  Created by Simon Weingand on 17/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONModel : NSObject

+ (NSString*) getStringFromJSON:(NSDictionary*)json keyString:(NSString*)keyString;
+ (int) getIntFromJSON:(NSDictionary*)json keyString:(NSString*)keyString;
+ (NSInteger) getNSIntegerFromJSON:(NSDictionary*)json keyString:(NSString*)keyString;
+ (NSUInteger) getNSUIntegerFromJSON:(NSDictionary*)json keyString:(NSString*)keyString;
+ (double) getDoubleFromJSON:(NSDictionary*)json keyString:(NSString*)keyString;
+ (float) getFloatFromJSON:(NSDictionary*)json keyString:(NSString*)keyString;
+ (BOOL) getBOOLFromJSON:(NSDictionary*)json keyString:(NSString*)keyString;
+ (NSDictionary*) getDictionaryFromJSON:(NSDictionary*)json keyString:(NSString*)keyString;
+ (NSArray*) getArrayFromJSON:(NSDictionary*)json keyString:(NSString*)keyString;

@end
