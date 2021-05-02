//
//  CustomTextField.h
//  CustomTextField
//
//  Created by Simon Weingand on 02/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TEXT_FIELD_NORMAL,
    TEXT_FIELD_EMAIL,
    TEXT_FIELD_DATE,
    TEXT_FIELD_DATETIME,
    TEXT_FIELD_SEX,
    TEXT_FIELD_PICKER
}TextFieldType;

// Application specific customization.
@interface CustomTextField : UITextField

@property (nonatomic, setter = setRequired:) BOOL required;
@property (nonatomic, setter = setEmailField:) BOOL isEmailField;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger cornerRadius;
@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, strong) NSMutableArray *pickerArray;

- (BOOL) validate;


@end
