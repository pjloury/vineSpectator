//
//  VSEditBottleDataSource.m
//  VineSpectator
//
//  Created by PJ Loury on 12/24/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSDetailViewController.h"
#import "VSGrapeVarietyDataSource.h"
#import "VSEditBottleDataSource.h"
#import "VSBottleDataSource.h"
#import "VSBottle.h"
#import "VSPromptLabel.h"
#import "VSTextField.h"

@interface VSEditBottleDataSource ()<UITextFieldDelegate, UITextViewDelegate>

@property VSBottleDataSource *bottleDataSource;

@property (nonatomic) VSPromptLabel *grapePromptLabel;
@property (nonatomic) VSTextField *grapeTextField;

@property (nonatomic) VSPromptLabel *vineyardPromptLabel;
@property (nonatomic) VSTextField *vineyardTextField;

@property (nonatomic) VSPromptLabel *yearPromptLabel;
@property (nonatomic) VSTextField *yearTextField;

@property (nonatomic) VSPromptLabel *namePromptLabel;
@property (nonatomic) VSTextField *nameTextField;

@property (nonatomic) VSPromptLabel *tagsPromptLabel;
@property (nonatomic) UITextView *tagsTextView;

@end

@implementation VSEditBottleDataSource

- (instancetype)initWithBottleDataSource:(VSBottleDataSource *)bottleDataSource bottleID:(NSString *)bottleID
{
    self = [super init];
    if (self) {
        _bottleDataSource = bottleDataSource;
        _bottleID = bottleID;
    }
    
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
    // 0 Edit Bottle
    // 1 Photograph
    // 2 Other Options
    // 3 Drank Bottle
    // 4 Remove Bottle
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Edit bottle might actually want 3 rows.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailCell";
    //VSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor offWhiteColor];
    
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    switch (indexPath.section) {
        case 0: {
            //TODO: Refactor into a table!!
            self.grapePromptLabel = [[VSPromptLabel alloc] initWithString:@"Grape:"];
            [cell addSubview:self.grapePromptLabel];
            self.grapeTextField = [[VSTextField alloc] initWithString:bottle.grapeVarietyName];
            self.grapeTextField.tag = 0;
            self.grapeTextField.delegate = self;
            [cell addSubview:self.grapeTextField];
            
            self.vineyardPromptLabel = [[VSPromptLabel alloc] initWithString:@"Vineyard:"];
            [cell addSubview:self.vineyardPromptLabel];
            self.vineyardTextField = [[VSTextField alloc] initWithString:bottle.vineyardName];
            self.vineyardTextField.tag = 1;
            self.vineyardTextField.delegate = self;
            [cell addSubview:self.vineyardTextField];
            
            self.yearPromptLabel = [[VSPromptLabel alloc] initWithString:@"Year:"];
            [cell addSubview:self.yearPromptLabel];
            
            if (bottle.year > 0)self.yearTextField = [[VSTextField alloc] initWithString:@(bottle.year).stringValue];
            else self.yearTextField = [[VSTextField alloc] initWithString:@""];
            self.yearTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.yearTextField.tag = 2;
            self.yearTextField.delegate = self;
            [cell addSubview:self.yearTextField];
            
            self.namePromptLabel = [[VSPromptLabel alloc] initWithString:@"Name:"];
            [cell addSubview:self.namePromptLabel];
            self.nameTextField = [[VSTextField alloc] initWithString:bottle.name];
            self.nameTextField.tag = 3;
            self.nameTextField.delegate = self;
            self.nameTextField.returnKeyType = UIReturnKeyDone;
            [cell addSubview:self.nameTextField];
         
            [self.grapePromptLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.width.equalTo(@90);
                make.left.equalTo(cell.left).offset(25);
                make.top.equalTo(cell.top).offset(25);
            }];
            [self.grapeTextField mas_makeConstraints:^(MASConstraintMaker *make){
                make.centerY.equalTo(self.grapePromptLabel.centerY);
                make.right.equalTo(cell.right).offset(-20);
                make.left.equalTo(self.grapePromptLabel.right).offset(25);
                make.height.equalTo(@28);
            }];
            
            [self.vineyardPromptLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.width.equalTo(@90);
                [self.vineyardPromptLabel sizeToFit];
                make.left.equalTo(self.grapePromptLabel.left);
                make.top.equalTo(self.grapePromptLabel.bottom).offset(25);
            }];
            [self.vineyardTextField mas_makeConstraints:^(MASConstraintMaker *make){
                make.centerY.equalTo(self.vineyardPromptLabel.centerY);
                make.right.equalTo(self.grapeTextField.right);
                make.left.equalTo(self.vineyardPromptLabel.right).offset(25);
                make.height.equalTo(self.grapeTextField.height);
            }];
            
            [self.yearPromptLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.width.equalTo(@90);
                make.left.equalTo(self.grapePromptLabel.left);
                make.top.equalTo(self.vineyardPromptLabel.bottom).offset(25);
            }];
            [self.yearTextField mas_makeConstraints:^(MASConstraintMaker *make){
                make.centerY.equalTo(self.yearPromptLabel.centerY);
                make.right.equalTo(self.grapeTextField.right);
                make.left.equalTo(self.yearPromptLabel.right).offset(25);
                make.height.equalTo(self.grapeTextField.height);
            }];
            
            [self.namePromptLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.width.equalTo(@90);
                make.left.equalTo(self.grapePromptLabel.left);
                make.top.equalTo(self.yearPromptLabel.bottom).offset(25);
            }];
            [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make){
                make.centerY.equalTo(self.namePromptLabel.centerY);
                make.right.equalTo(self.grapeTextField.right);
                make.left.equalTo(self.namePromptLabel.right).offset(25);
                make.height.equalTo(self.grapeTextField.height);
            }];
            
            self.grapeTextField.autocompleteDataSource = [VSGrapeVarietyDataSource sharedInstance];
            
            break;
        }
        case 1: {
            self.imageButton = [[UIButton alloc] initWithFrame:CGRectZero];
            [cell addSubview:self.imageButton];
            [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(cell.top).offset(20);
                make.centerX.equalTo(cell.centerX);
                make.height.equalTo(@300);
                make.width.equalTo(self.imageButton.height);
            }];

            [self.imageButton addTarget:self action:@selector(didPressImageButton:) forControlEvents:UIControlEventTouchUpInside];
            self.imageButton.layer.borderColor = [UIColor brownInkColor].CGColor;
            self.imageButton.layer.borderWidth = 5.0;
            if (bottle.image) {
                [self.imageButton setImage:bottle.image forState:UIControlStateNormal];
            }
            else {
                [self.imageButton setTitle:@"Press to add a Photo" forState:UIControlStateNormal];
                self.imageButton.titleLabel.font = [UIFont fontWithName:@"STKaiti-SC-Bold" size:20.0];
                [self.imageButton setTitleColor:[UIColor brownInkColor] forState:UIControlStateNormal];
                self.imageButton.backgroundColor = [UIColor warmTanColor];
            }
//
//            self.descriptionTextView = [[UITextView alloc] initWithFrame:CGRectZero];
//            self.descriptionTextView.text = @"Loren Ipsum dolor";
//            self.descriptionTextView.font = [UIFont fontWithName:@"Baskerville" size:20.0];
//            self.descriptionTextView.textColor = [UIColor oliveInkColor];
//            [cell addSubview:self.descriptionTextView];
//            [self.descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make){
//                if (bottle.hasImage) {
//                    make.top.equalTo(self.imageView.top).offset(20);
//                }
//                else {
//                    make.top.equalTo(cell.top).offset(30);
//                }
//                make.left.equalTo(cell.left).offset(30);
//                make.centerX.equalTo(cell.centerX);
//                [self.descriptionTextView sizeToFit];
//            }];
            break;
        }
        case 2: {
            self.tagsPromptLabel = [[VSPromptLabel alloc] initWithString:@"Tags"];
            [cell addSubview:self.tagsPromptLabel];
            
            self.tagsTextView = [[UITextView alloc] initWithFrame:CGRectZero];
            self.tagsTextView.font = [UIFont fontWithName:@"Baskerville-Bold" size:18.0];
            self.tagsTextView.textAlignment = NSTextAlignmentLeft;
            self.tagsTextView.textColor = [UIColor oliveInkColor];
            self.tagsTextView.backgroundColor = [UIColor lightSalmonColor];
            self.tagsTextView.delegate = self;
            [cell addSubview:self.tagsTextView];

            [self.tagsPromptLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(cell.top).offset(20);
                make.left.equalTo(cell.left).offset(20);
            }];
            
            [self.tagsTextView mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(self.tagsPromptLabel.top).offset(-10);
                make.centerX.equalTo(cell.centerX);
                make.height.equalTo(@50);
                make.left.equalTo(self.tagsPromptLabel.right).offset(20);
            }];
            break;
        }
        case 3:
        default:
            break;
    }
    
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

# pragma mark - Tap Handlers
- (void)didPressImageButton:(id)sender
{
    [self.imageSelectionDelegate imageButtonWasPressed:sender];
}

# pragma mark - Accessors

- (NSString*)grapeVariety
{
    return self.grapeTextField.text;
}

- (NSString *)vineyard
{
    return self.vineyardTextField.text;
}
- (NSString *)year
{
    return self.yearTextField.text;
}

- (NSString *)name
{
    return self.nameTextField.text;
}

- (UIImage *)image
{
    return [self.imageButton imageForState:UIControlStateNormal];
}

@end
