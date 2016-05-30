//
//  VSFilterStackViewController.m
//  VineSpectator
//
//  Created by PJ Loury on 12/26/15.
//  Copyright © 2015 PJ Loury. All rights reserved.
//

#import "VSFilterStackViewController.h"
#import "VSStackView.h"
#import "VSTagsDataSource.h"
#import "VSScrollView.h"
#import "JDFTooltips.h"

@interface VSFilterStackViewController () <VSStackViewDelegate, UITextFieldDelegate>

@property VSScrollView *stackScrollView;
@property VSTagsDataSource *tagsDataSource;
@property JDFTooltipManager *manager;
@property JDFTooltipView *tagsTip;
@property JDFTooltipView *drankTip;

@end

@implementation VSFilterStackViewController

- (instancetype)init
{
    self = [super init];
    self.tagsDataSource = [[VSTagsDataSource alloc] init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightSalmonColor];
    self.stackScrollView = [[VSScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,50)];
    
    [self.view addSubview:self.stackScrollView];
    self.stackScrollView.canCancelContentTouches = YES;
    self.stackScrollView.showsHorizontalScrollIndicator = NO;
    
    self.stackView = [[VSStackView alloc] init];
    self.stackView.searchField.delegate = self;
    [self.stackView.searchField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    self.stackView.delegate = self;
    self.stackView.dataSource = self.tagsDataSource;
    
    [self.stackScrollView addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.stackScrollView.top);
        make.height.equalTo(self.stackScrollView.height);
    }];
    
    self.stackScrollView.contentOffset = CGPointZero;
    self.stackScrollView.userInteractionEnabled = YES;
    self.stackScrollView.scrollsToTop = NO;
    self.stackScrollView.clipsToBounds = NO;
    
    [self.stackView reloadData];
    
    self.stackScrollView.contentSize = self.stackView.intrinsicContentSize;
    self.stackScrollView.alwaysBounceHorizontal = YES;
    self.stackScrollView.scrollEnabled = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"seenTagsTip"];
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"seenDrankTip"];
    
    //self.tagsTip = [[JDFTooltipView alloc] initWithTargetPoint:CGPointMake(self.stackScrollView.frame.size.width - 5, self.stackScrollView.frame.size.height/2 + 3) hostView:self.view tooltipText:@"Tap + to add Tags" arrowDirection:JDFTooltipViewArrowDirectionRight width:200.0f];
    self.tagsTip = [[JDFTooltipView alloc] initWithTargetView:self.stackView.addButton hostView:self.view tooltipText:@"Tap + to add Tags" arrowDirection:JDFTooltipViewArrowDirectionRight width:200.0f];    
    self.tagsTip.dismissOnTouch = YES;
    
    self.drankTip = [[JDFTooltipView alloc] initWithTargetPoint:CGPointMake(52*2 + 52/2, self.stackScrollView.frame.size.height - 10) hostView:self.view tooltipText:@"Bottles marked as drank go here" arrowDirection:JDFTooltipViewArrowDirectionUp width:200.0f];
    self.drankTip.dismissOnTouch = YES;
    
    self.manager = [[JDFTooltipManager alloc] initWithHostView:self.view];
    [self.manager addTooltip:self.tagsTip];
    [self.manager addTooltip:self.drankTip];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.stackView reloadData];
    self.stackScrollView.contentSize = self.stackView.intrinsicContentSize;
    
    /*
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"seenTagsTip"] isEqual: @(NO)]) {
        [self.manager.tooltips.firstObject show];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"seenTagsTip"];
    } else if  ([[[NSUserDefaults standardUserDefaults] objectForKey:@"seenDrankTip"] isEqual: @(NO)]){
        //[self.manager.tooltips.lastObject show];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"seenDrankTip"];
    }
    */
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.drankTip hideAnimated:NO];
    [self.tagsTip hideAnimated:NO];
}

# pragma mark - VSStackViewDelegate
- (void)stackView:(VSStackView *)stackView didDeselectViewAtIndex:(NSInteger)index
{
    NSString *tag = [self.tagsDataSource textForStackIndex:index];
    if ([tag isEqualToString:@"Search"]) {
        self.stackScrollView.contentOffset = CGPointZero;
        [self.stackView dismissSearchField];
        [self.delegate filterStackViewController:self didDeselectTag:tag];
    }
    else if (![tag isEqualToString:@"Edit"]) {
        NSString *tag = [self.tagsDataSource textForStackIndex:index];
        [self.delegate filterStackViewController:self didDeselectTag:tag];
    }
}

- (void)stackView:(VSStackView *)stackView didSelectViewAtIndex:(NSInteger)index
{
    NSInteger totalTags = self.tagsDataSource.allTags.count;
    switch (index) {
        case VSFilterTypeSearch:
            [self.stackView revealSearchField];
            break;
        case VSFilterTypeChrono:
            [self.stackView dismissSearchField];
            [self.delegate filterStackViewController:self didSelectFilter:VSFilterTypeChrono];
            break;
        case VSFilterTypeDrank:
            [self.stackView dismissSearchField];
            [self.delegate filterStackViewController:self didSelectFilter:VSFilterTypeDrank];
            break;
        case VSFilterTypeRed:
            [self.stackView dismissSearchField];
            [self.delegate filterStackViewController:self didSelectFilter:VSFilterTypeRed];
            break;
        case VSFilterTypeWhite:
            [self.stackView dismissSearchField];
            [self.delegate filterStackViewController:self didSelectFilter:VSFilterTypeWhite];
            break;
        default:
            if (index == totalTags) {
                [self.stackView dismissSearchField];
                [self.delegate didPressViewAllTags:self];
            } else {
                [self.stackView dismissSearchField];
                 NSString *tag = [self.tagsDataSource textForStackIndex:index];
                [self.delegate filterStackViewController:self didSelectTag:tag]; // Hook in here to reload all
            }
            break;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textChanged:(UITextField *)sender
{
    [self.delegate filterStackViewController:self didReceiveSearchText:[sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate filterStackViewController:self didReceiveSearchText:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    return YES;
}

@end
