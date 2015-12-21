//
//  VSAddBottleView.m
//  VineSpectator
//
//  Created by PJ Loury on 11/22/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSAddBottleView.h"
#import "Masonry.h"
#import "TRAutocompleteView.h"
#import "HTAutocompleteManager.h"

@interface VSAddBottleView ()<UITextFieldDelegate>

// I can use interchangeable views for Add and Edit
@property UITextField *activeField;


@end

@implementation VSAddBottleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageButton];
        _imageButton.contentMode = UIViewContentModeScaleAspectFit;
        _imageButton.adjustsImageWhenHighlighted = NO;
        [_imageButton addTarget:self action:@selector(didPressImageButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _yearTextField = [[UITextField alloc] init];
        [self addSubview:_yearTextField];
        
        _grapeVarietyTextField = [[HTAutocompleteTextField alloc] init];

        [self addSubview:_grapeVarietyTextField];
//        
//        _nameTextField = [[UITextField alloc] init];
//        [self addSubview:_nameTextField];
        _vineyardTextField = [[UITextField alloc] init];
        [self addSubview:_vineyardTextField];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        [self addGestureRecognizer:tap];
        
        [self registerForKeyboardNotifications];
        
        self.showsVerticalScrollIndicator = NO;
        self.scrollEnabled = NO;
    }
    [self _configureViews];
    return self;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return self.editMode;
}

- (void)_configureViews
{
    [self configureYearTextField:self.yearTextField];
    [self configureDetailsTextField:self.nameTextField tabOrder:1];
    [self configureDetailsTextField:self.grapeVarietyTextField tabOrder:2];
    [self configureDetailsTextField:self.vineyardTextField tabOrder:3];
    self.vineyardTextField.returnKeyType = UIReturnKeyDone;
    [self layoutIfNeeded];
}

- (void)configureYearTextField:(UITextField *)textField
{
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.keyboardAppearance = UIKeyboardAppearanceDefault;
    textField.delegate = self;
}

- (void)configureDetailsTextField:(UITextField *)textField tabOrder:(NSInteger)tabOrder
{
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    textField.layer.cornerRadius = 3.0;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.tag = tabOrder;
    textField.returnKeyType = UIReturnKeyNext;
    textField.delegate = self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // if no image yet then..
    
    [self.grapeVarietyTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.nameTextField.mas_bottom).offset(20);
        make.left.equalTo(self).offset(40);
        make.width.equalTo(@300);
        //make.right.equalTo(self).offset(-40);
        make.height.equalTo(@30);
    }];
    
    // below the variety
    [self.vineyardTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.grapeVarietyTextField.mas_bottom).offset(20);
        make.left.equalTo(self).offset(40);
        make.width.equalTo(@300);
        //make.right.equalTo(self).offset(-40);
        make.height.equalTo(@30);
    }];
    
    [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.mas_top).offset(30); // border from the top
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@150);
        make.height.equalTo(self.imageButton.mas_width); // width equal to height
    }];
    
    [self.yearTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.imageButton.mas_bottom).offset(30);
//        make.left.equalTo(self).offset(40);
//        make.right.equalTo(self).offset(-40);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];
    
//    // below the year
//    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(self.yearTextField.mas_bottom).offset(20);
//        make.left.equalTo(self).offset(40);
//        make.width.equalTo(@300);
//        //make.right.equalTo(self).offset(-40);
//        make.height.equalTo(@30);
//    }];
    

    
    self.contentSize = CGSizeMake(self.frame.size.width, self.vineyardTextField.frame.origin.y + self.vineyardTextField.frame.size.height +225);
}

- (void)setImage:(UIImage *)image
{
    [self.imageButton setImage:image forState:UIControlStateNormal];
}

- (void)didPressImageButton:(id)sender
{
    if ([[self.imageButton imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"add-photo"]]) {
        [self.delegate shouldEditImage:sender];
    }
    else {
        [self.delegate shouldEditImage:sender];
//        [self.delegate shouldPresentImage:sender];
    }
}

- (void)keyBoardWillShow
{
    // get keyboard size
    // adjust bottom content inset to keyboard height
    // scroll target textfield into view
}

- (void)dismissKeyboard
{
    [self endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        [self setContentOffset: CGPointMake(0, -self.contentInset.top) animated:YES];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    self.scrollEnabled = YES;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.contentInset = contentInsets;
    self.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.contentInset = contentInsets;
    self.scrollIndicatorInsets = contentInsets;
    [self setContentOffset:CGPointZero animated:YES];
    self.scrollEnabled = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
