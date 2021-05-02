//
//  LoginViewController.m
//  Blingby
//
//  Created by Simon Weingand on 02/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomTextField.h"
#import "RoundedButton.h"
#import "MediaManager.h"

@interface LoginViewController ()

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) CustomTextField *emailAddressTextField;
@property (nonatomic, strong) CustomTextField *passwordTextField;
@property (nonatomic, strong) UIButton *forgotPasswordButton;
@property (nonatomic, strong) RoundedButton *goButton;

@end

@implementation LoginViewController

@synthesize descriptionLabel;
@synthesize emailAddressTextField;
@synthesize passwordTextField;
@synthesize forgotPasswordButton;
@synthesize goButton;

- (void)loadView {
    [super loadView];
    
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
    descriptionLabel.text = @"ENTER YOUR LOGIN INFO";
    descriptionLabel.textColor = [UIColor whiteColor];
    [descriptionLabel setFont:[UIFont fontWithName:BLINGBY_INPUTFIELD_FONT size:DESCRIPTION_FONT_SIZE]];
    [descriptionLabel sizeToFit];
    
    [self.view addSubview:descriptionLabel];
    
    // emailAddress TextField
    CGFloat emailAddressTextFieldTop = descriptionLabelTop + descriptionLabel.frame.size.height + textFieldSpace;
    emailAddressTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(left, emailAddressTextFieldTop, textFieldWidth, textFieldHeight)];
    emailAddressTextField.placeholder = @"enter email address";
    [emailAddressTextField setKeyboardType:UIKeyboardTypeEmailAddress];
//    [emailAddressTextField setType:TEXT_FIELD_EMAIL];
    [emailAddressTextField setFont:font];
    
    [self.view addSubview:emailAddressTextField];
    
    // password TextField
    CGFloat passwordTextFieldTop = emailAddressTextFieldTop + emailAddressTextField.frame.size.height + textFieldSpace;
    passwordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(left, passwordTextFieldTop, textFieldWidth, textFieldHeight)];
    passwordTextField.placeholder = @"enter password";
    [passwordTextField setSecureTextEntry:YES];
    [passwordTextField setFont:font];
    
    [self.view addSubview:passwordTextField];
    
    CGFloat goButtonWidth = IS_PAD ? 80 : 60;
    
    // forgot password
    CGFloat forgotPasswordTop = passwordTextFieldTop + passwordTextField.frame.size.height + textFieldSpace;
    forgotPasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(left, forgotPasswordTop, textFieldWidth - goButtonWidth, textFieldHeight)];
    [forgotPasswordButton setTitle:@"forgot your password?" forState:UIControlStateNormal];
    [forgotPasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgotPasswordButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [forgotPasswordButton.titleLabel setFont:font];
    forgotPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgotPasswordButton addTarget:self action:@selector(onForgotPassword) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:forgotPasswordButton];
    
    // go button
    goButton = [[RoundedButton alloc] initWithFrame:CGRectMake(left + textFieldWidth - goButtonWidth, forgotPasswordTop, goButtonWidth, textFieldHeight)];
    [goButton setTitle:@"go" forState:UIControlStateNormal];
    [goButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [goButton setBackgroundColor:BLINGBY_COLOR2];
    [goButton.titleLabel setFont:font];
    [goButton addTarget:self action:@selector(onGo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:goButton];
    
}

#pragma mark - Actions

- (void) onForgotPassword {
    
}

- (void) onGo {
    BOOL isValid = YES;
    if ( [emailAddressTextField validate] == NO ) {
        isValid = NO;
    }
    
    if ( [passwordTextField validate] == NO ) {
        isValid = NO;
    }
    
    if ( isValid == NO ) {
        return;
    }
    
//    [[MediaManager sharedManager] postLogin:emailAddressTextField.text
//                                   password:passwordTextField.text
//                                   callback:^(id result, NSError *error) {
//                                       if ( error == nil && self.delegate ) {
//                                           [self.delegate login];
//                                       }
//                                   }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoggedIn object:nil];
}

@end
