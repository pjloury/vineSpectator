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
            
//            UILabel *vineyardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//            vineyardLabel.textColor = [UIColor redInkColor];
//            vineyardLabel.font = [UIFont fontWithName:@"STKaiti-SC-Bold" size:23.0];
//            vineyardLabel.text = bottle.vineyardName;
//            [vineyardLabel sizeToFit];
//            [sectionView addSubview:vineyardLabel];
//            
//            UILabel *grapeVarietyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//            grapeVarietyLabel.text = bottle.grapeVarietyName;
//            grapeVarietyLabel.textColor = [UIColor oliveInkColor];
//            grapeVarietyLabel.font = [UIFont fontWithName:@"STKaiti-SC-Regular" size:23.0];
//            [grapeVarietyLabel sizeToFit];
//            [sectionView addSubview:grapeVarietyLabel];
            
//            [vineyardLabel mas_makeConstraints:^(MASConstraintMaker *make){
//                make.left.top.equalTo(sectionView).offset(10);
//            }];
//            
//            [grapeVarietyLabel mas_makeConstraints:^(MASConstraintMaker *make){
//                make.top.equalTo(vineyardLabel.top);
//                make.left.equalTo(vineyardLabel.right).offset(5);
//            }];
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
            drunkSwitchPrompt.font = [UIFont fontWithName:@"STKaiti-SC-Bold" size:24.0];
            drunkSwitchPrompt.textAlignment = NSTextAlignmentLeft;
            drunkSwitchPrompt.textColor = [UIColor redInkColor];
            [drunkSwitchPrompt sizeToFit];
            [sectionView addSubview:drunkSwitchPrompt];
            
            UISwitch *drunkSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            drunkSwitch.on = bottle.drank;
            drunkSwitch.tintColor = [UIColor highlightedRedInkColor];
            drunkSwitch.onTintColor = [UIColor wineColor];
            [drunkSwitch sizeToFit];
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
            UIButton *editBottleButton = [[UIButton alloc] initWithFrame:sectionView.frame];
            [editBottleButton setTitle:@"Discard Bottle" forState:UIControlStateNormal];
            editBottleButton.titleLabel.font = [UIFont fontWithName:@"STKaiti-SC-Bold" size:24.0];
            editBottleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [editBottleButton setTitleColor:[UIColor redInkColor] forState:UIControlStateNormal];
            [editBottleButton setTitleColor:[UIColor highlightedRedInkColor] forState:UIControlStateHighlighted];
            [editBottleButton addTarget:self action:@selector(didPressDiscardBottle:) forControlEvents:UIControlEventTouchUpInside];
            [sectionView addSubview:editBottleButton];
            break;
        }
    }
    return sectionView;
}// custom view for header. will be adjusted to default or specified header height

# pragma mark - Tap Handlers


- (void)didPressDiscardBottle:(id)sender
{
    
}

@end
