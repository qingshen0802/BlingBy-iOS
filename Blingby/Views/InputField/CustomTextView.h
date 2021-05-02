//
//  CustomTextView.h
//  CustomTextView
//
//  Created by admin on 3/2/14.
//  Copyright (c) 2014 gmc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomTextView : UITextView<UITextViewDelegate>

@property (nonatomic, setter = setRequired:) BOOL required;

- (BOOL) validate;

@end
