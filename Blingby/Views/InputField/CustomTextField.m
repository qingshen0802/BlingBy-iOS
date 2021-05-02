//
//  CustomTextField.m
//  CustomTextField
//
//  Created by Simon Weingand on 02/04/15.
//  Copyright (c) 2015 Simon Weingand. All rights reserved.
//

#import "CustomTextField.h"

@interface CustomTextField() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIPickerView *pickerView;

@end

@implementation CustomTextField

@synthesize required;
@synthesize isEmailField;

@synthesize pickerArray;

@synthesize datePicker;
@synthesize pickerView;

- (instancetype) init {
    self = [super init];
    if ( self ) {
        [self initialize];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initialize];
}

- (void) initialize {
    [self setBorderStyle:UITextBorderStyleNone];
    
    [self setFont: [UIFont fontWithName:BLINGBY_INPUTFIELD_FONT size:BLINGBY_INPUTFIELD_FONT_SIZE]];
    [self setTintColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]];
    [self setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.3f]];
    
    _cornerRadius = 4.0f;
    _borderColor = [UIColor whiteColor];
    self.layer.borderColor = [_borderColor CGColor];
    self.layer.cornerRadius = _cornerRadius;
    self.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
    
    required = YES;
}

- (void) setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = [_borderColor CGColor];
}
- (void) setCornerRadius:(NSInteger)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}
- (void) setType:(NSInteger)type {
    _type = type;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 5);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 5);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    
    [layer setBorderWidth: 0.8];
}

- (void) drawPlaceholderInRect:(CGRect)rect {
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.8 alpha:0.8], NSFontAttributeName: [UIFont fontWithName:BLINGBY_INPUTFIELD_FONT size:BLINGBY_INPUTFIELD_FONT_SIZE]};
    CGRect boundingRect = [self.placeholder boundingRectWithSize:rect.size options:0 attributes:attributes context:nil];
    [self.placeholder drawAtPoint:CGPointMake(0, (rect.size.height/2)-boundingRect.size.height/2) withAttributes:attributes];
}

- (BOOL) validate
{
    self.layer.borderColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.5].CGColor;
    
    if (required && [self.text isEqualToString:@""]){
        return NO;
    }
    else if (_type == TEXT_FIELD_EMAIL){
        NSString *emailRegEx =
        @"(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[a-"
        @"z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if (![emailTest evaluateWithObject:self.text]){
            return NO;
        }
    }
    
    self.layer.borderColor = [_borderColor CGColor];
    
    return YES;
}

#pragma mark - UITextField notifications

- (void)textFieldDidBeginEditing:(UITextField *) textField
{
    self.layer.borderColor = [_borderColor CGColor];
    if ( _type == TEXT_FIELD_DATE ) {
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.inputView = datePicker;
    }
    else if ( _type == TEXT_FIELD_DATETIME ) {
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.inputView = datePicker;
    }
    else if ( _type == TEXT_FIELD_SEX ) {
        pickerArray = [NSMutableArray arrayWithObjects:@"", @"Male", @"Female", nil];
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
        [pickerView setDataSource:self];
        [pickerView setDelegate:self];
        pickerView.showsSelectionIndicator = YES;
        self.inputView = pickerView;
    }
    else if ( _type == TEXT_FIELD_PICKER ) {
        pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
        [pickerView setDataSource:self];
        [pickerView setDelegate:self];
        pickerView.showsSelectionIndicator = YES;
        self.inputView = pickerView;
    }
}

- (void)textFieldDidEndEditing:(UITextField *) textField
{    
    [self validate];
}

#pragma mark - UIDatePicker Delegate

- (void) datePickerValueChanged:(id)sender {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if ( _type == TEXT_FIELD_DATE )
        [df setDateFormat:@"dd/MM/YYYY"];
    else
        [df setDateFormat:@"dd/MM/YYYY hh:mm:ss"];
    self.text = [df stringFromDate:datePicker.date];
}

#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}

#pragma mark - UIPickerView Delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [pickerArray objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.text = [pickerArray objectAtIndex:row];
}


@end
