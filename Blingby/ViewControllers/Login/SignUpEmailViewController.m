//
//  SignUpEmailViewController.m
//  Blingby
//
//  Created by Simon Weingand on 02/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "SignUpEmailViewController.h"
#import "CustomTextField.h"
#import "RoundedButton.h"
#import <M13Checkbox/M13Checkbox.h>

@interface SignUpEmailViewController ()

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) CustomTextField *usernameTextField;
@property (nonatomic, strong) CustomTextField *emailAddressTextField;
@property (nonatomic, strong) CustomTextField *passwordTextField;
@property (nonatomic, strong) CustomTextField *retypePasswordTextField;
@property (nonatomic, strong) CustomTextField *birthTextField;
@property (nonatomic, strong) M13Checkbox *agreeCheckBox;
@property (nonatomic, strong) RoundedButton *goButton;
@property (nonatomic, strong) UIButton *termsButton;

@end

@implementation SignUpEmailViewController

@synthesize descriptionLabel;
@synthesize usernameTextField;
@synthesize emailAddressTextField;
@synthesize passwordTextField;
@synthesize retypePasswordTextField;
@synthesize birthTextField;
@synthesize agreeCheckBox;
@synthesize goButton;
@synthesize termsButton;

- (void)loadView {
    [super loadView];
    
    [self addBackButton];
    [self addContentView];
}

#pragma mark - Setup Views

- (void) addContentView {
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    CGFloat textFieldWidth = IS_PAD ? TEXT_FIELD_WIDTH : rect.size.width - HORIZENTAL_MARGIN;
    CGFloat textFieldHeight = TEXT_FIELD_HEIGHT;
    CGFloat textFieldSpace = TEXT_FIELD_SPACE;
    CGFloat left = (rect.size.width - textFieldWidth) / 2.0;
    
    UIFont *font = [UIFont fontWithName:BLINGBY_INPUTFIELD_FONT size:BLINGBY_INPUTFIELD_FONT_SIZE];
    
    // description label
    CGFloat descriptionLabelTop = CONTENT_TOP;
    
    descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, descriptionLabelTop, textFieldWidth, 0)];
    descriptionLabel.text = @"CREATE An ACCOUNT";
    descriptionLabel.textColor = [UIColor whiteColor];
    [descriptionLabel setFont:[UIFont fontWithName:BLINGBY_INPUTFIELD_FONT size:DESCRIPTION_FONT_SIZE]];
    [descriptionLabel sizeToFit];
    
    [self.view addSubview:descriptionLabel];
    
    // username TextField
    CGFloat usernameTextFieldTop = descriptionLabelTop + descriptionLabel.frame.size.height + textFieldSpace;
    usernameTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(left, usernameTextFieldTop, textFieldWidth, textFieldHeight)];
    usernameTextField.placeholder = @"create a username";
    [usernameTextField setType:TEXT_FIELD_NORMAL];
    [usernameTextField setFont:font];
    
    [self.view addSubview:usernameTextField];
    
    // emailAddress TextField
    CGFloat emailAddressTextFieldTop = usernameTextFieldTop + usernameTextField.frame.size.height + textFieldSpace;
    emailAddressTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(left, emailAddressTextFieldTop, textFieldWidth, textFieldHeight)];
    emailAddressTextField.placeholder = @"enter your email address";
    [emailAddressTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [emailAddressTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [emailAddressTextField setType:TEXT_FIELD_EMAIL];
    [emailAddressTextField setFont:font];
    
    [self.view addSubview:emailAddressTextField];
    
    // password TextField
    CGFloat passwordTextFieldTop = emailAddressTextFieldTop + emailAddressTextField.frame.size.height + textFieldSpace;
    passwordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(left, passwordTextFieldTop, textFieldWidth, textFieldHeight)];
    passwordTextField.placeholder = @"create a password";
    [passwordTextField setSecureTextEntry:YES];
    [passwordTextField setFont:font];
    
    [self.view addSubview:passwordTextField];
    
    // re-type password TextField
    CGFloat retypePasswordTextFieldTop = passwordTextFieldTop + passwordTextField.frame.size.height + textFieldSpace;
    retypePasswordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(left, retypePasswordTextFieldTop, textFieldWidth, textFieldHeight)];
    retypePasswordTextField.placeholder = @"re-enter password";
    [retypePasswordTextField setSecureTextEntry:YES];
    [retypePasswordTextField setFont:font];
    
    [self.view addSubview:retypePasswordTextField];
    
    // birthday TextField
    CGFloat birthdayTextFieldTop = retypePasswordTextFieldTop + passwordTextField.frame.size.height + textFieldSpace;
    birthTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(left, birthdayTextFieldTop, textFieldWidth, textFieldHeight)];
    birthTextField.placeholder = @"enter your date of birth";
    [birthTextField setType:TEXT_FIELD_DATE];
    [birthTextField setFont:font];
    
    [self.view addSubview:birthTextField];
    
    // agree CheckBox
    CGFloat agreeCheckBoxTop = birthdayTextFieldTop + birthTextField.frame.size.height + textFieldSpace * 2;
    agreeCheckBox = [[M13Checkbox alloc] initWithFrame:CGRectMake(left, agreeCheckBoxTop, textFieldWidth, textFieldHeight * 2 / 3)];
    agreeCheckBox.titleLabel.text = @"I agree to the terms of service";
    agreeCheckBox.titleLabel.font = font;
    agreeCheckBox.titleLabel.textColor = [UIColor whiteColor];
    agreeCheckBox.checkAlignment = M13CheckboxAlignmentLeft;
    [agreeCheckBox setTintColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
    [agreeCheckBox setStrokeColor:[UIColor whiteColor]];
    [agreeCheckBox setUncheckedColor:[UIColor colorWithWhite:1.0 alpha:0.3f]];
    [agreeCheckBox addTarget:self action:@selector(checkChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:agreeCheckBox];
    
    // go button
    CGFloat goButtonWidth = IS_PAD ? 80 : 60;
    CGFloat goButtonTop = agreeCheckBoxTop + agreeCheckBox.frame.size.height + textFieldSpace * 2;
    goButton = [[RoundedButton alloc] initWithFrame:CGRectMake(left + textFieldWidth - goButtonWidth, goButtonTop, goButtonWidth, textFieldHeight)];
    [goButton setTitle:@"go" forState:UIControlStateNormal];
    [goButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [goButton setBackgroundColor:BLINGBY_COLOR2];
    [goButton.titleLabel setFont:font];
    [goButton addTarget:self action:@selector(onGo) forControlEvents:UIControlEventTouchUpInside];
    
    [goButton setEnabled:NO];
    
    [self.view addSubview:goButton];
    
    // terms Button
    CGFloat termsButtonTop = rect.size.height - 20 - textFieldHeight;
    termsButton = [[UIButton alloc] initWithFrame:CGRectMake(left, termsButtonTop, textFieldWidth, textFieldHeight)];
    [termsButton setTitle:@"terms of service" forState:UIControlStateNormal];
    [termsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [termsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [termsButton setBackgroundColor:[UIColor clearColor]];
    [termsButton.titleLabel setFont:font];
    [termsButton addTarget:self action:@selector(onTerms) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:termsButton];
}

#pragma mark - Actions

- (void)checkChangedValue:(id)sender
{
    if ( [agreeCheckBox checkState] == M13CheckboxStateChecked ) {
        [goButton setEnabled:YES];
    }
    else {
        [goButton setEnabled:NO];
    }
}

- (void) onGo {
    
}

- (void) onTerms {
    
}

@end
