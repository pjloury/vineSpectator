//
//  VSEditBottleDataSource.m
//  VineSpectator
//
//  Created by PJ Loury on 12/24/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSEditBottleDataSource.h"

// Models
#import "VSGrapeVarietyDataSource.h"
#import "VSBottleDataSource.h"
#import "VSBottle.h"
#import "VSTagsDataSource.h"
#import "UIImage+Additions.h"

// Views
#import "VSPromptLabel.h"
#import "VSTagCollectionViewCell.h"
#import "VSTextField.h"
#import "KTCenterFlowLayout.h"
#import "VSTableViewCell.h"

// Controllers
#import "VSDetailViewController.h"

@interface VSEditBottleDataSource ()<UITextFieldDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, HTAutocompleteTextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property VSBottleDataSource *bottleDataSource;

@property (nonatomic) VSPromptLabel *grapePromptLabel;
@property (nonatomic) HTAutocompleteTextField *grapeTextField;

@property (nonatomic) VSPromptLabel *vineyardPromptLabel;
@property (nonatomic) VSTextField *vineyardTextField;

@property (nonatomic) VSPromptLabel *yearPromptLabel;
@property (nonatomic) VSTextField *yearTextField;

@property (nonatomic) VSPromptLabel *namePromptLabel;
@property (nonatomic) VSTextField *nameTextField;

@property (nonatomic) VSPromptLabel *tagsPromptLabel;
@property (nonatomic) UICollectionView *tagsCollectionView;

@property (nonatomic) UISegmentedControl *segmentedControl;

@property (nonatomic) VSWineColorType color;

@property (nonatomic) UIPickerView *pickerView;

@property (weak) UITableView *tableView;
@property NSMutableArray *years;
@property NSInteger thisYear;

@property UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation VSEditBottleDataSource

- (instancetype)initWithTableView:(UITableView *)tableView bottleDataSource:(VSBottleDataSource *)bottleDataSource tagsDataSource:(VSTagsDataSource *)tagsDataSource bottleID:(NSString *)bottleID
{
    self = [super init];
    if (self) {
        _bottleDataSource = bottleDataSource;
        _bottleID = bottleID;
        _tagsDataSource = tagsDataSource;
        _tableView = tableView;
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        _thisYear  = [[formatter stringFromDate:[NSDate date]] intValue];
        
        _years = [[NSMutableArray alloc] init];
        for (int i=1960; i<=_thisYear; i++) {
            [_years addObject:[NSString stringWithFormat:@"%d",i]];
        }
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailCell";
    VSTableViewCell *cell = [[VSTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    cell.backgroundColor = [UIColor offWhiteColor];
    
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    switch (indexPath.section) {
        case 0: {
            self.grapePromptLabel = [[VSPromptLabel alloc] initWithString:@"Grape Variety:"];
            self.grapePromptLabel.adjustsFontSizeToFitWidth = YES;
            self.grapePromptLabel.minimumScaleFactor = 0.8;
            [cell addSubview:self.grapePromptLabel];
            self.grapeTextField = [[VSTextField alloc] initWithString:bottle.grapeVarietyName];
            self.grapeTextField.tag = 0;
            self.grapeTextField.delegate = self;
            self.grapeTextField.showAutocompleteButton = YES;
            self.grapeTextField.autoCompleteTextFieldDelegate = self;
            self.grapeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.grapeTextField.autocompleteDataSource = [VSGrapeVarietyDataSource sharedInstance];
            [cell addSubview:self.grapeTextField];
            
            self.vineyardPromptLabel = [[VSPromptLabel alloc] initWithString:@"Winery:"];
            [cell addSubview:self.vineyardPromptLabel];
            self.vineyardTextField = [[VSTextField alloc] initWithString:bottle.vineyardName];
            self.vineyardTextField.tag = 1;
            self.vineyardTextField.delegate = self;
            self.vineyardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:self.vineyardTextField];
            
            self.yearPromptLabel = [[VSPromptLabel alloc] initWithString:@"Year:"];
            [cell addSubview:self.yearPromptLabel];
            
            self.pickerView = [[UIPickerView alloc] init];
            self.pickerView.dataSource = self;
            self.pickerView.delegate = self;
            self.pickerView.backgroundColor = [UIColor offWhiteColor];
            
            UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectZero];
            toolBar.barTintColor = [UIColor parchmentColor];
            UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                              style:UIBarButtonItemStylePlain target:self action:@selector(dismissPicker:)];
            UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            toolBar.items = @[flexibleSpace, barButtonDone];
            toolBar.backgroundColor = [UIColor parchmentColor];
            barButtonDone.tintColor=[UIColor goldColor];
            toolBar.barStyle = UIBarStyleDefault;
            toolBar.translucent = YES;
            toolBar.userInteractionEnabled = YES;
            [toolBar sizeToFit];
            
            if (bottle.year > 0) {
                self.yearTextField = [[VSTextField alloc] initWithString:@(bottle.year).stringValue];
                NSInteger difference = self.thisYear - bottle.year;
                [self.pickerView selectRow:self.years.count-1 - difference inComponent:0 animated:NO];
            } else {
                self.yearTextField = [[VSTextField alloc] initWithString:@""];
                [self.pickerView selectRow:self.years.count-5 inComponent:0 animated:NO];
            }
            self.yearTextField.inputView = self.pickerView;
            self.yearTextField.inputAccessoryView = toolBar;
            self.yearTextField.tag = 2;
            self.yearTextField.delegate = self;
            self.yearTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:self.yearTextField];
            
            self.namePromptLabel = [[VSPromptLabel alloc] initWithString:@"Name/Region:"];
            self.namePromptLabel.adjustsFontSizeToFitWidth = YES;
            self.namePromptLabel.minimumScaleFactor = 0.8;
            [cell addSubview:self.namePromptLabel];
            self.nameTextField = [[VSTextField alloc] initWithString:bottle.name];
            self.nameTextField.tag = 3;
            self.nameTextField.delegate = self;
            self.nameTextField.returnKeyType = UIReturnKeyDone;
            self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [cell addSubview:self.nameTextField];
         
            [self.grapePromptLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.width.equalTo(@110);
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
                make.width.equalTo(@110);
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
                make.width.equalTo(@110);
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
                make.width.equalTo(@110);
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
            self.imageButton.backgroundColor = [UIColor warmTanColor];
            [cell addSubview:self.imageButton];
            [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(cell.top).offset(20);
                make.center.equalTo(cell);
                make.width.equalTo(self.imageButton.height);
                make.bottom.equalTo(cell.bottom).offset(-20);
            }];

            [self.imageButton addTarget:self action:@selector(didPressImageButton:) forControlEvents:UIControlEventTouchUpInside];
            self.imageButton.layer.borderColor = [UIColor brownInkColor].CGColor;
            self.imageButton.layer.borderWidth = 5.0;
            
            if (![[VSReachability reachabilityForInternetConnection] isReachable]) {
                [self.imageButton setTitle:@"No Internet Connection" forState:UIControlStateNormal];
                self.imageButton.titleLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:15.0];
                [self.imageButton setTitleColor:[UIColor brownInkColor] forState:UIControlStateNormal];
                self.imageButton.enabled = NO;
            }
            else if (bottle == nil) {
                self.imageButton.enabled = YES;
                [self.imageButton setTitle:@"Press to add a Photo" forState:UIControlStateNormal];
                self.imageButton.titleLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:15.0];
                [self.imageButton setTitleColor:[UIColor brownInkColor] forState:UIControlStateNormal];
            } else {
                self.imageButton.enabled = YES;
                [bottle imageWithCompletion:^(BOOL success, UIImage * image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (image && success) {
                            [self.imageButton setImage:image forState:UIControlStateNormal];
                            [self.imageButton setImage:image forState:UIControlStateHighlighted];
                            //[self.imageButton setImage:[UIImage darkenedImageWithImage:image] forState:UIControlStateHighlighted];
                            self.imageButton.adjustsImageWhenHighlighted = YES;
                        } else {
                            [self.imageButton setTitle:@"Press to add a Photo" forState:UIControlStateNormal];
                            self.imageButton.titleLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:15.0];
                            [self.imageButton setTitleColor:[UIColor brownInkColor] forState:UIControlStateNormal];
                        }
                    });
                }];
            }
            
          /*
            self.descriptionTextView = [[UITextView alloc] initWithFrame:CGRectZero];
            self.descriptionTextView.text = @"Loren Ipsum dolor";
            self.descriptionTextView.font = [UIFont fontWithName:@"Baskerville" size:20.0];
            self.descriptionTextView.textColor = [UIColor oliveInkColor];
            [cell addSubview:self.descriptionTextView];
            [self.descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make){
                if (bottle.hasImage) {
                    make.top.equalTo(self.imageView.top).offset(20);
                }
                else {
                    make.top.equalTo(cell.top).offset(30);
                }
                make.left.equalTo(cell.left).offset(30);
                make.centerX.equalTo(cell.centerX);
                [self.descriptionTextView sizeToFit];
            }];
           */
            break;
        }
        case 2: {
            UIView *spacer1 = [[UIView alloc] initWithFrame:CGRectZero];
            UIView *spacer2 = [[UIView alloc] initWithFrame:CGRectZero];
            [cell addSubview:spacer1];
            [cell addSubview:spacer2];
            
            [spacer1 mas_makeConstraints:^(MASConstraintMaker *make){
                make.width.equalTo(25);
                make.left.equalTo(cell.left).offset(cell.frame.size.width/10);
                make.height.equalTo(cell.height);
                make.top.equalTo(cell.top);
            }];
            
            [spacer2 mas_makeConstraints:^(MASConstraintMaker *make){
                make.width.equalTo(spacer1);
                make.right.equalTo(cell.right);
                make.height.equalTo(cell.height);
                make.top.equalTo(cell.top);
            }];
            
            self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Red", @"White"]];
            [cell addSubview:self.segmentedControl];
            [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make){
                CGRect screenRect = [[UIScreen mainScreen] bounds];
                CGFloat screenWidth = screenRect.size.width;
                CGFloat val = screenWidth/5;
                make.left.equalTo(spacer1.right).offset(val);
                make.right.equalTo(spacer2.left).offset(-val);
                make.top.equalTo(cell.top).offset(20);
                make.height.equalTo(25);
            }];
            self.segmentedControl.tintColor = [UIColor wineColor];
            self.segmentedControl.backgroundColor = [UIColor parchmentColor];
            
            UIFont *segmentFont= [UIFont fontWithName:@"Palatino" size:16.0];
            NSDictionary *segmentAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor redInkColor], NSForegroundColorAttributeName,
                                               segmentFont, NSFontAttributeName,nil];
            [self.segmentedControl setTitleTextAttributes:segmentAttributes forState:UIControlStateNormal];
            [self.segmentedControl addTarget:self action:@selector(selectionChanged:) forControlEvents:UIControlEventValueChanged];
            
            VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
            if (bottle.color > 0 && bottle.color <= 2) {
                [self.segmentedControl setSelectedSegmentIndex:bottle.color-1];
            } else {
                VSWineColorType color = [[VSGrapeVarietyDataSource sharedInstance] colorForGrapeVariety:bottle.grapeVarietyName];
                if (color > VSWineColorTypeUnspecified) {
                    [self.segmentedControl setSelectedSegmentIndex:color-1];
                }
            }
            
            VSPromptLabel *colorLabel = [[VSPromptLabel alloc] initWithString:@"Color"];
            [cell addSubview:colorLabel];
            [colorLabel sizeToFit];
            
            [colorLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(cell.left).offset(15);
                make.top.equalTo(self.segmentedControl.top);
            }];
            
            if (self.tagsDataSource.userTags.count > 0) {
                
                KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
                layout.minimumInteritemSpacing = 10.f;
                layout.minimumLineSpacing = 10.f;
                
                VSPromptLabel *tagsLabel = [[VSPromptLabel alloc] initWithString:@"Tags"];
                [cell addSubview:tagsLabel];
                [tagsLabel sizeToFit];
                
                self.tagsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
                self.tagsCollectionView.allowsMultipleSelection = YES;
                self.tagsCollectionView.backgroundColor = [UIColor clearColor];
                self.tagsCollectionView.dataSource = self.tagsDataSource;
                cell.userInteractionEnabled = YES;
                
                [self.tagsCollectionView registerClass:[VSTagCollectionViewCell class] forCellWithReuseIdentifier:@"TagCell"];
                [cell addSubview:self.tagsCollectionView];
                
                [tagsLabel mas_makeConstraints:^(MASConstraintMaker *make){
                    make.left.equalTo(colorLabel.left);
                    make.top.equalTo(self.tagsCollectionView.top);
                }];
                
                [self.tagsCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
                    make.left.equalTo(spacer1.right);
                    make.right.equalTo(spacer2.left);
                    make.top.equalTo(self.segmentedControl.bottom).offset(20);
                    make.bottom.equalTo(cell.bottom).offset(-20);
                }];
                
                self.tagsCollectionView.delegate = self;
            }
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void)autoCompleteTextFieldDidAutoComplete:(HTAutocompleteTextField *)autoCompleteField
{
    if ([autoCompleteField isEqual:self.grapeTextField]) {
        VSWineColorType color = [[VSGrapeVarietyDataSource sharedInstance] colorForGrapeVariety:autoCompleteField.text];
        self.color = color;
        [self updateSegmentedControlForColor:self.color];
    }
}

# pragma mark - UICollectionVewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tag = [self.tagsDataSource textForIndexPath:indexPath];
    if (tag.length > 0 && [tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] > 0) {
        [self.tagsDataSource addTag:tag];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tag = [self.tagsDataSource textForIndexPath:indexPath];
    [self.tagsDataSource removeTag:tag];
}


# pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [self.tagsDataSource textForIndexPath:indexPath];
    CGSize size = [text sizeWithAttributes:@{@"NSFontAttributeName": [UIFont fontWithName:@"Belfast-Regular" size:15.0]}];
    size.height += 10;
    size.width += 30;
    return size;
}

- (void)updateSegmentedControlForColor:(VSWineColorType)color {
    if (color > VSWineColorTypeUnspecified) {
        [self.segmentedControl setSelectedSegmentIndex:color-1];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(dismissKeyboard)];
   [self.tableView addGestureRecognizer:self.tapGestureRecognizer];
}


- (void)dismissKeyboard
{
    [self.tableView endEditing:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.tableView removeGestureRecognizer:self.tapGestureRecognizer];
    
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    if ([textField isEqual:self.grapeTextField]) {
        bottle.grapeVarietyName = self.grapeVariety;
    }
    else if ([textField isEqual:self.vineyardTextField]) {
        bottle.vineyardName = self.vineyard;
    }
    else if ([textField isEqual:self.yearTextField]) {
        bottle.year = self.year.integerValue;
    }
    else if ([textField isEqual:self.nameTextField]) {
        bottle.name = self.name;
    }
    [bottle saveInBackground];
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

# pragma mark - Year Picker
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.years.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.years objectAtIndex:row];
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    UIFont *pickerFont =     [UIFont fontWithName:@"Palatino-Bold" size:18.0];//[UIFont fontWithName:@"Belfast-Regular" size:20.0];
    NSDictionary *pickerAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor oliveInkColor], NSForegroundColorAttributeName,
                                       pickerFont, NSFontAttributeName,nil];
    NSString *title = [self.years objectAtIndex:row];
    return [[NSAttributedString alloc] initWithString:title attributes:pickerAttributes];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *value = [self pickerView:pickerView titleForRow:row forComponent:component];
    self.yearTextField.text = value;
}

-(void)dismissPicker:(id)sender
{
    //[self.yearTextField resignFirstResponder];
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    NSString *title = [self pickerView:self.pickerView titleForRow:row forComponent:0];
    self.yearTextField.text = title;
    [self textFieldShouldReturn:self.yearTextField];
}

# pragma mark - Tap Handlers
- (void)selectionChanged:(UISegmentedControl *)sender
{
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    NSLog(@"SEGMENT %ld", sender.selectedSegmentIndex);
    if (sender.selectedSegmentIndex != bottle.color) {
        bottle.color = sender.selectedSegmentIndex + 1;
    }
    [bottle save];
    NSLog(@"%ld Color", (long)bottle.color);
}

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
