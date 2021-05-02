//
//  PersonCollectionViewCell.m
//  Blingby
//
//  Created by Simon Weingand on 27/02/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "PersonCollectionViewCell.h"
#import "Person.h"

@implementation PersonCollectionViewCell

- (void) initLabel {
    [self initLabel:UIColorFromRGB(0xffd300)];
}

- (void) setPerson:(Person *)person cellWidth:(CGFloat)cellWidth {
    _person = person;
    if ( person ) {
        NSString *name = person.personFirstName ? person.personFirstName : @"";
        name = [NSString stringWithFormat:@"%@%@", name, ![name isEqualToString:@""] && person.personLastName ? @" " : @""];
        name = [NSString stringWithFormat:@"%@%@", name, (person.personLastName ? person.personLastName : @"")];
        [self setInfo:person.personImage
                title:person.personTitle
             subTitle:name
            cellWidth:cellWidth];
    }
}

@end
