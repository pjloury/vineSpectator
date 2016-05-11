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

// Views
#import "VSPromptLabel.h"
#import "VSTagCollectionViewCell.h"
#import "VSTextField.h"
#import "KTCenterFlowLayout.h"

// Controllers
#import "VSDetailViewController.h"

@interface VSEditBottleDataSource ()<UITextFieldDelegate, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

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

@end

@implementation VSEditBottleDataSource

- (instancetype)initWithBottleDataSource:(VSBottleDataSource *)bottleDataSource bottleID:(NSString *)bottleID
{
    self = [super init];
    if (self) {
        _bottleDataSource = bottleDataSource;
        _bottleID = bottleID;
        _tagsDataSource = [[VSTagsDataSource alloc] initWithBottleDataSource:bottleDataSource bottleID:bottleID];
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
    //VSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor offWhiteColor];
    
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    switch (indexPath.section) {
        case 0: {
            self.grapePromptLabel = [[VSPromptLabel alloc] initWithString:@"Grape:"];
            [cell addSubview:self.grapePromptLabel];
            self.grapeTextField = [[VSTextField alloc] initWithString:bottle.grapeVarietyName];
            self.grapeTextField.tag = 0;
            self.grapeTextField.delegate = self;
            self.grapeTextField.showAutocompleteButton = YES;
            self.grapeTextField.autoCompleteTextFieldDelegate = self;
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
                self.imageButton.titleLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:15.0];
                [self.imageButton setTitleColor:[UIColor brownInkColor] forState:UIControlStateNormal];
                self.imageButton.backgroundColor = [UIColor warmTanColor];
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
            KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
            layout.minimumInteritemSpacing = 10.f;
            layout.minimumLineSpacing = 10.f;
            
            VSPromptLabel *tagsLabel = [[VSPromptLabel alloc] initWithString:@"Tags"];
            [cell addSubview:tagsLabel];
            
            UIView *spacer1 = [[UIView alloc] initWithFrame:CGRectZero];
            UIView *spacer2 = [[UIView alloc] initWithFrame:CGRectZero];
            [cell addSubview:spacer1];
            [cell addSubview:spacer2];
            
            self.tagsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            self.tagsCollectionView.allowsMultipleSelection = YES;
            self.tagsCollectionView.backgroundColor = [UIColor clearColor];
            self.tagsCollectionView.dataSource = self.tagsDataSource;
            
            self.tagsCollectionView.delegate = self;
            [self.tagsCollectionView registerClass:[VSTagCollectionViewCell class] forCellWithReuseIdentifier:@"TagCell"];
            [cell addSubview:self.tagsCollectionView];
            
            [spacer1 mas_makeConstraints:^(MASConstraintMaker *make){
                make.width.equalTo(10);
                make.left.equalTo(tagsLabel.right);
                make.height.equalTo(cell.height);
                make.top.equalTo(cell.top);
            }];
            
            [spacer2 mas_makeConstraints:^(MASConstraintMaker *make){
                make.width.equalTo(spacer1);
                make.right.equalTo(cell.right);
                make.height.equalTo(cell.height);
                make.top.equalTo(cell.top);
            }];
            
            [tagsLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(cell.left).offset(15);
                make.top.equalTo(self.tagsCollectionView.top).offset(-5);
                make.width.equalTo(100);
            }];
            
            [self.tagsCollectionView mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(spacer1.right);
                make.right.equalTo(spacer2.left);
                make.top.equalTo(cell.top).offset(20);
                make.bottom.equalTo(cell.bottom).offset(-20);
            }];
            
            self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Red", @"White"]];
            [cell addSubview:self.segmentedControl];
            [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(spacer1.right).offset(30);
                make.right.equalTo(spacer2.left).offset(-30);
                make.bottom.equalTo(cell.bottom).offset(-20);
                make.height.equalTo(25);
            }];
            self.segmentedControl.tintColor = [UIColor redInkColor];
            self.segmentedControl.backgroundColor = [UIColor parchmentColor];
            
            UIFont *segmentFont= [UIFont fontWithName:@"Palatino" size:16.0];
            NSDictionary *segmentAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor redInkColor], NSForegroundColorAttributeName,
                                               segmentFont, NSFontAttributeName,nil];
            [self.segmentedControl setTitleTextAttributes:segmentAttributes forState:UIControlStateNormal];
            [self.segmentedControl addTarget:self action:@selector(selectionChanged:) forControlEvents:UIControlEventValueChanged];
            
            VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
            if (bottle) {
                [self updateSegmentedControlForColor:bottle.color];
            } else {
                [self updateSegmentedControlForColor:self.color -1];
            }
            
            VSPromptLabel *colorLabel = [[VSPromptLabel alloc] initWithString:@"Color"];
            [cell addSubview:colorLabel];
            [colorLabel sizeToFit];
            
            [colorLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(tagsLabel.left);
                make.top.equalTo(self.segmentedControl.top);
            }];
            break;
        }
        case 3:
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
    }
}

# pragma mark - UICollectionVewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tag = [self.tagsDataSource textForIndexPath:indexPath];
    [self.tagsDataSource addTag:tag];
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
    CGSize size = [text sizeWithAttributes:@{@"NSFontAttributeName": [UIFont fontWithName:@"YuMin-Medium" size:15.0]}];
    size.height += 10;
    size.width += 30;
    return size;
}

- (void)updateSegmentedControlForColor:(VSWineColorType)color {
    if (color > VSWineColorTypeUnspecified) {
        [self.segmentedControl setSelectedSegmentIndex:color-1];
    }
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

# pragma mark

//- (NSArray *)tags {
//    NSString *trimmedString = [self.tagsTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    return [trimmedString componentsSeparatedByString:@","];
//}

@end
