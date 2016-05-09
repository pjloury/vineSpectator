//
//  VSEditBottleDelegate.m
//  VineSpectator
//
//  Created by PJ Loury on 12/24/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSEditBottleDelegate.h"

#import "VSBottleDataSource.h"
#import "VSBottle.h"
#import "VSSectionView.h"

@interface VSEditBottleDelegate ()

@property VSBottleDataSource *bottleDataSource;
@property NSString *bottleID;
@property UITableView *tableView;
@property UISwitch *drunkSwitch;
@property UIButton *discardBottleButton;

@end


@implementation VSEditBottleDelegate

- (instancetype)initWithTableView:(UITableView *)tableView bottleDataSource:(VSBottleDataSource *)bottleDataSource bottleID:(NSString *)bottleID
{
    self = [super init];
    if (self) {
        _tableView = tableView;
        _bottleDataSource = bottleDataSource;
        _bottleID = bottleID;
    }
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tableView addGestureRecognizer:self.tapRecognizer];
    
    return self;
}

# pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) { // edit bottle
                case 0: // contains the image and description
                default:
                    return 260;
            }
        case 1:
            return 350;
        case 2:
            return 120; // rating and tags
        case 4:
        default:
             return 15.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
        case 2:
            return 40.0;
        case 0:
        case 3:
        default:
            return 50.0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    VSSectionView *sectionView;
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    
    switch (section) {
        case 0: {
            NSString *title = self.bottleID ? @"Edit Bottle" : @"New Bottle";
            sectionView = [[VSSectionView alloc] initWithTableView:self.tableView title:title height:50.0];
            sectionView.label.font = [UIFont fontWithName:@"Athelas-Bold" size:22.0];
            break;
        }
        case 1:
            sectionView = [[VSSectionView alloc] initWithTableView:self.tableView title:@"Photograph" height:40.0];
            break;
        case 2:
            sectionView = [[VSSectionView alloc] initWithTableView:self.tableView title:@"Other Options" height:40.0];
            break;
        case 3: {
            sectionView = [[VSSectionView alloc] initWithTableView:self.tableView title:@"" height:50.0];
            UILabel *drunkSwitchPrompt = [[UILabel alloc] initWithFrame:sectionView.frame];
            drunkSwitchPrompt.text = @"Drank Bottle";
            drunkSwitchPrompt.font = [UIFont fontWithName:@"Palatino-Bold" size:18.0];
            drunkSwitchPrompt.textAlignment = NSTextAlignmentLeft;
            drunkSwitchPrompt.textColor = [UIColor redInkColor];
            [drunkSwitchPrompt sizeToFit];
            [sectionView addSubview:drunkSwitchPrompt];
            
            UISwitch *drunkSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            drunkSwitch.on = bottle.drank;
            drunkSwitch.tintColor = [UIColor highlightedRedInkColor];
            drunkSwitch.onTintColor = [UIColor wineColor];
            [drunkSwitch sizeToFit];
            [drunkSwitch addTarget:self action:@selector(drunkSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            self.drunkSwitch = drunkSwitch;
            [sectionView addSubview:drunkSwitch];
            
            [drunkSwitchPrompt mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(sectionView.left).offset(20);
                make.centerY.equalTo(sectionView.centerY);
            }];
            
            [drunkSwitch mas_makeConstraints:^(MASConstraintMaker *make){
                make.right.equalTo(sectionView.right).offset(-20);
                make.centerY.equalTo(sectionView.centerY);
            }];
            
           [sectionView addSubview:drunkSwitchPrompt];
            break;
        }
        case 4: {
            sectionView = [[VSSectionView alloc] initWithTableView:self.tableView title:@"" height:50.0];
            UIButton *discardBottleButton = [[UIButton alloc] initWithFrame:sectionView.frame];
            [discardBottleButton setTitle:@"Discard Bottle" forState:UIControlStateNormal];
            discardBottleButton.titleLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:18.0];
            discardBottleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [discardBottleButton setTitleColor:[UIColor redInkColor] forState:UIControlStateNormal];
            [discardBottleButton setTitleColor:[UIColor highlightedRedInkColor] forState:UIControlStateHighlighted];
            [discardBottleButton addTarget:self action:@selector(didPressDiscardBottle:) forControlEvents:UIControlEventTouchUpInside];
            [sectionView addSubview:discardBottleButton];
            self.discardBottleButton = discardBottleButton;
            break;
        }
    }
    return sectionView;
}// custom view for header. will be adjusted to default or specified header height

# pragma mark - Tap Handlers

- (void)drunkSwitchChanged:(id)sender
{
    VSBottle *bottle = [self.bottleDataSource bottleForID:self.bottleID];
    bottle.drank = self.drunkSwitch.isOn;
    [bottle saveInBackground];
}

- (void)didPressDiscardBottle:(id)sender
{
    
}

@end
